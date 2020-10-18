//
//  Board.swift
//  musicSheet
//
//  Created by  on 2020/8/11.
//  Copyright © 2020 . All rights reserved.
//

import UIKit



class BoardReadOnly: UIImageView {
    
    var actionList = [PaintItem]()
    
    var textFieldList = [PainterTextField]()
    
    var brush = Brush(type: .pencil)
    
    var realImage: UIImage?
    
    var action: PaintItem?
    
    var path = UIBezierPath()
    
    var ctx: CGContext?
    
    
    init() {
        super.init(frame: .zero)
        isHidden = true
        isUserInteractionEnabled = false
        backgroundColor = UIColor.clear
        
        //  layer.debug()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /**
     重绘textfield
     */
    func rePlaceTextField(id: Int, point: MyPoint, content: String) {
        let tf = PainterTextField(id: id, dele: self)
        tf.borderGG()
        tf.isUserInteractionEnabled = false
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
    
    
 
    
}

extension BoardReadOnly: PainterTextEventDelegate {
    
    func onTextModified(textViewId: Int, content: String){ }
    
}



extension BoardReadOnly{
  
    
    
    func refresh(action items: [PaintItem]){
        drawEmptyBitch()
        textFieldList.forEach {
            $0.removeFromSuperview()
        }
        textFieldList.removeAll()
        actionList.removeAll()
        actionList.append(contentsOf: items)
    }
    
 
    private
    func drawEmptyBitch(){
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.realImage = UIGraphicsGetImageFromCurrentImageContext()
        UIColor.clear.setFill()
        UIRectFill(self.bounds)
        self.image = self.realImage
        UIGraphicsEndImageContext()
    }
}
