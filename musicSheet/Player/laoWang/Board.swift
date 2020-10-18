//
//  Board.swift
//  musicSheet
//
//  Created by  on 2020/8/11.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

enum DrawingState {
    case began, moved, ended
}

class BoardX: UIImageView {
    
    
    var actionList = [PaintItem]()
    
    var textFieldList = [PainterTextField]()
    
    private var drawingState: DrawingState!
    
    var brush = Brush(type: .pencil)
    
    var realImage: UIImage?
    
    var action: PaintItem?
    
    var isTextModeOpen = false
    
    var boundary = true
    
    var ctx: CGContext?
    
    
    var timer: Timer?
    
    
    var runs = false
    var actionDotsQueue = [CGPoint]()
    
    let intervalSpan: TimeInterval = 0.15
    
    
    init() {
        super.init(frame: .zero)
        isHidden = true
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
        
        //  layer.debug()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /**
     创建一个放置在画板上的textview
     */
    func createTextField(id: Int) -> PainterTextField {
        let tv = PainterTextField(id: id, dele: self)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        tv.addGestureRecognizer(panGesture)
        return tv
    }
    

    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        if point.y < 0 || point.y > self.bounds.size.height {
            return
        }
        let tran = sender.translation(in: self)
        var x = (sender.view?.center.x)! + tran.x
        if x < PaintLayout.s.width/3 {
            x = PaintLayout.s.width/3
        }
        if x > UI.width - PaintLayout.s.width/3 {
            x = UI.width - PaintLayout.s.width/3
        }
        var y = (sender.view?.center.y)! + tran.y
        let oldY = y
        var reY = convert(CGPoint(x: 0, y: y), to: nil)
        let relativeOldY = reY
        if relativeOldY.y < PaintLayout.s.height/2{
            reY.y = PaintLayout.s.height/2
            y = oldY + reY.y - relativeOldY.y
            print(y)
            
            
        }
        var stdY = UI.height - 70
        let gg = convert(frame.end, to: nil)
        let ggY = gg.y - PaintLayout.s.height/2
        if stdY > ggY{
            stdY = ggY
        }
        var goodCondition = false
        if relativeOldY.y > stdY{
            reY.y = stdY
            y = oldY + reY.y - relativeOldY.y
            print(y)
            if boundary{
                goodCondition = true
                boundary = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.boundary = true
                }
            }
            
        }
        sender.view?.center = CGPoint(x: x, y: y)
        sender.setTranslation(.zero, in: self)
        if sender.state == UIPanGestureRecognizer.State.ended{
            goodCondition = true
        }
        if goodCondition, let origin = sender.view?.frame.origin{
            let tf = sender.view as! PainterTextField
            
            let item = PaintItem(id: tf.id_Dng, action: 3, pointList: nil, text: nil, pos: origin.toMyPoint())
            self.actionList.append(item)
        }
    }
    
    
    
    func placeTextField(id: Int, point: MyPoint) {
        let tf = createTextField(id: id)
        textFieldList.append(tf)
        tf.becomeFirstResponder()
        let act = PaintItem(id: id, action: 1, pointList: nil, text: "", pos: point)
        self.actionList.append(act)
        self.addSubview(tf)
        tf.frame.size = PaintLayout.s
        tf.frame.origin = point.toCGPoint()
    }
    /**
     重绘textfield
     */
    func rePlaceTextField(id: Int, point: MyPoint, content: String) {
        let tf = createTextField(id: id)
        tf.borderGG()
        tf.text = content
        textFieldList.append(tf)
        self.addSubview(tf)
        var s = PaintLayout.s
        s.width = PaintLayout.s.width + content.count.paintWidth
        tf.frame.size = s
        tf.frame.origin = point.toCGPoint()
    }
    
    
    
    /**
     重新绘制动作列表的内容
     */
    func drawList(actionList: [PaintItem]) {
        var actionQueue = [PaintItem]()
        for ca in actionList{
            if [0, 2].contains(ca.action){
                actionQueue.append(ca)
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(self.bounds)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setLineCap(.round)
        for item in actionQueue{
            var points = [MyPoint]()
            if let ps = item.pointList{
                points.append(contentsOf: ps)
            }
            let brush: Brush
            if item.action == 0{
                brush = Brush(type: .pencil)
            }
            else{
                brush = Brush(type: .eraser)
            }
            
            context.setLineWidth(brush.strokeWidth)
            context.setStrokeColor(brush.strokeColor.cgColor)
          
            
            // 4.
            brush.draw(in: context, pairs: points)
        
            context.strokePath()
        }
        realImage = UIGraphicsGetImageFromCurrentImageContext()
        actionQueue.removeAll()
        
        for item in actionList {
            switch item.action {
            case 1: // textfield
                let id = item.id
                let point = item.pos
                let str = item.text
                self.rePlaceTextField(id: id, point: point!, content: str!)
            case 3: // 移动
                let id = item.id  
                let diff = item.pos
                
                for tf in self.textFieldList {
                    if tf.id_Dng == id, let p = diff?.toCGPoint(){
                        tf.frame.origin = p
                    }
                }
            case 4:
                let id = item.id
                let newStr = item.text
                for tf in self.textFieldList {
                    if tf.id_Dng == id {
                        tf.text = newStr
                    }
                }
            default:
                //  0: 铅笔
                //  2: 橡皮擦
                ()
            }
            
        }
        self.image = self.realImage
        UIGraphicsEndImageContext()
    }
    
    
    
    func drawEmpty(){
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.realImage = UIGraphicsGetImageFromCurrentImageContext()
        UIColor.clear.setFill()
        UIRectFill(self.bounds)
        self.image = self.realImage
        UIGraphicsEndImageContext()
    }
    
    func drawListItem(brush: Brush, points: [MyPoint]) {
        brush.beginPoint = points.first
        
        brush.lastPoint = nil
        let context = UIGraphicsGetCurrentContext()!
        context.setLineCap(.round)
        context.setLineWidth(brush.strokeWidth)
        context.setStrokeColor(brush.strokeColor.cgColor)
 
        for point in points {
            brush.endPoint = point
            
            if let realImage = self.realImage {
                realImage.draw(in: self.bounds)
            }
            // 4.
            brush.drawInContext(context: context);
            context.strokePath()
            // 5.
            
            brush.lastPoint = brush.endPoint
        }
        self.realImage = UIGraphicsGetImageFromCurrentImageContext()
        
    }
    
}




extension BoardX: PainterTextEventDelegate {
    
    func onTextModified(textViewId: Int, content: String){
        for i in 0..<(actionList.count){
            if actionList[i].action == 1, actionList[i].id == textViewId{
                actionList[i].text = content
            }
        }
    }
    
}



extension BoardX{
    
    
    func refresh(action items: [PaintItem]){
        actionList.removeAll()
        actionList.append(contentsOf: items)
    }
    
    
    
    var createID: Int{
        var id = -1
        for item in actionList{
            if item.id > id{
                id = item.id
            }
        }
        return (id + 1)
    }
    
    
    
}


extension BoardX{
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        brush.lastPoint = nil
        guard let touchPoint = touches.first?.location(in: self) else {
            return
        }
        guard isTextModeOpen == false else{
            placeTextField(id: createID, point: touchPoint.toMyPoint())
            return
        }
        actionDotsQueue.removeAll()
        runs = true
        brush.beginPoint = touchPoint.toMyPoint()
        brush.endPoint = brush.beginPoint
        actionDotsQueue.append(touchPoint)
        if brush.type == .pencil {
            action = PaintItem(id: createID, action: 0, pointList: [], text: nil, pos: nil)
        } else if brush.type == .eraser {
            action = PaintItem(id: createID, action: 2, pointList: [], text: nil, pos: nil)
        }
        
        action?.pointList!.append(brush.beginPoint)
        
        self.drawingState = .began
        // 1.
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(self.bounds)
        ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineCap(.butt)
        
    }
    
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            if self.isTextModeOpen {
                return
            }
            
            for oneTouch in touches{
                let judgeTouch = oneTouch.location(in: self)
                if judgeTouch.y >= self.height {
                    self.drawingState = .ended
                    continue
                }
                let touchP = judgeTouch.toMyPoint()
                if touchP.x == self.brush.endPoint.x, touchP.y == self.brush.endPoint.y {
                    continue
                }
                self.brush.endPoint = touchP
                actionDotsQueue.append(judgeTouch)
                self.action?.pointList!.append(self.brush.endPoint)
            }
            self.drawingState = .moved
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        self.runs = false
        
        if self.isTextModeOpen {
            return
        }
        drawingImage()
        actionDotsQueue.removeAll()
        if let judgeTouch = touches.first?.location(in: self){
            brush.beginPoint = judgeTouch.toMyPoint()
            self.drawingState = .ended
            self.actionList.append(action!)
            UIGraphicsEndImageContext()
        }
        
    }
    
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        runs = false
        actionDotsQueue.removeAll()
        brush.endPoint = nil
        if ctx != nil{
            UIGraphicsEndImageContext()
        }
    }
    

    
    private func drawingImage() {
        guard let context = ctx else {
            return
        }
        
        
        context.setLineWidth(brush.strokeWidth)
        context.setStrokeColor(brush.strokeColor.cgColor)
        
        // 3.
        if let realImage = self.realImage {
            realImage.draw(in: self.bounds)
        }
        
        // 4.
        brush.draw(in: context, dots: actionDotsQueue)
        context.strokePath()
        
        // 5.
        image = UIGraphicsGetImageFromCurrentImageContext()
        if self.drawingState != .ended {
            self.realImage = image
        }
        brush.lastPoint = brush.endPoint
        let lastP = actionDotsQueue.last
        actionDotsQueue.removeAll()
        if let oneTouch = lastP{
            actionDotsQueue.append(oneTouch)
        }
    }
    
    
    
    func trigger(){
        timer = Timer.scheduledTimer(withTimeInterval: intervalSpan, repeats: true) { (t) in
            guard self.runs else{
                return
            }
            self.drawingImage()
        }
    }
    
    
    
    func terminate(){
        timer?.invalidate()
        timer = nil
    }
}



// 边缘检测

// 采点困难计时器

// buffer points

// 计时器，最后的 buffer

// 内存打爆，

// 卡顿和内存，都是尽量少调用拉图片方法


// 手绘，就是一个一个很小段的直线


// 路径，

// 显示路径


// 单一路径，

// 显示路径
// 1， show , 2, show


// 复合路径，

// 显示路径

// 1 , 2, show
