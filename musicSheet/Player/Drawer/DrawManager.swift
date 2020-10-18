//
//  DrawManager.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/11.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


enum DrawManagerOption{
    case bottom(Int)
    case arrows(Bool)  // true, upper
    case cover(ResultFallOut)   // true, toSave
}





protocol DrawManagerProxy: class {
    func done(drawManager opt: DrawManagerOption)
}


protocol DrawManagerCalling: class {
    func showBack()
    func scroll(map upwards: Bool)
    func onLabelEditSubmitConfirmed()
    func newLabelSubmitConfirmed()
    
}





class DrawManager: NSObject{

    lazy var bottomBar = BottomPaletteView()
    
    lazy var arrowPair = RhsArrowPair()
    
    lazy var engineeringCover = EngineeringDrawingS()
    
    weak var proxy: DrawManagerCalling?
    
    
    lazy var painterView = BoardX()
    
    lazy var painterReadOnly = BoardReadOnly()
    
    
    
    // 0, 没有画板
    // 1，画板在前面, edit
    
    // 2, readonly
    var modeOnDng = 0
    

    
    
    
    init(delegate calling: DrawManagerCalling) {
       
        proxy = calling
        super.init()
        
        bottomBar.delegate = self
        
        arrowPair.delegate = self
        
        engineeringCover.delegate = self
    }
}



extension DrawManager: DrawManagerProxy{
    
    func done(drawManager opt: DrawManagerOption) {
        switch opt {
        case .cover(let toSave):
            switch toSave {
            case .editOK:
                proxy?.onLabelEditSubmitConfirmed()
            case .ok:
                proxy?.newLabelSubmitConfirmed()
            case .hehe:
                ()
            }
            finishCover()
        case .bottom(let idx):
            bottom(select: idx)
        case .arrows(let upper):
            proxy?.scroll(map: upper)
        }

        
    }
    
    
    
    
    func finishCover(){
        
        bottomBar.isHidden = true
        arrowPair.isHidden = true
        painterView.isHidden = true
        modeOnDng = 0
        proxy?.showBack()
        
        
    }
    
    
    func bottom(select idx: Int){
        switch idx {
        case 0:
            painterView.isTextModeOpen = false
            painterView.brush.type = .pencil
            painterView.brush.strokePencil()
        case 1:
            painterView.isTextModeOpen = true
        case 2:
            painterView.isTextModeOpen = false
            painterView.brush.type = .eraser
            painterView.brush.strokeEraser()
        case 3:
            rollback()
        case 4:
            clearBoard()
        case 5:
            painterView.terminate()
            painterView.endEditing(true)
            engineeringCover.isHidden = false
        default:
            ()
        }
    }
}





extension DrawManager{
    
    func showNew(title saveT: String){
        
        editableInit()
 
    }
    
    
    
    func showExsit(){
        editableInit()
      
    }
    
    
    
    private
    func editableInit(){
        clearBoard()
        bottom(select: 0)
        bottomBar.enter()
        arrowPair.isHidden = false
        
        painterView.isHidden = false
        painterView.trigger()
    }
    
    
    
    
    
    
    func clearBoard(){
        
        painterView.drawEmpty()
        painterView.textFieldList.forEach {
            $0.removeFromSuperview()
        }
        painterView.textFieldList.removeAll()
        painterView.actionList.removeAll()
    }
}



extension DrawManager{

    func rollback(){
        painterView.image = nil
        painterView.realImage = nil
        guard painterView.actionList.count > 0 else{
            return
        }
        let _ = painterView.actionList.removeLast()
        
        
        painterView.textFieldList.forEach {
            $0.removeFromSuperview()
        }
        painterView.textFieldList.removeAll()
        painterView.drawList(actionList: painterView.actionList)
    }



}



extension DrawManager{

    
    func change(mode isRead: Bool){
        painterReadOnly.isHidden = !isRead
        painterView.isHidden = isRead
    }
}
