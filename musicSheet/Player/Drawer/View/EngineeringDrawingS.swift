//
//  EngineeringDrawingS.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/12.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


import SnapKit


enum ResultFallOut{
    case hehe
    case ok
    case editOK
}



protocol EngineeringDrawingSaveProxy: class {
    func done(engineeringDrawing ok: ResultFallOut)
}


class EngineeringDrawingS: UIView {

    
    let s = CGSize(width: 536, height: 310)
    
    
    weak var delegate: DrawManagerProxy?
    
    var maskSs = MyLibMask()
    
    lazy var saveCover = DrawingSaveCover()
    
    var centerY_constraint: ConstraintMakerEditable?
    
 
    init(){

        super.init(frame: .zero)
        
        isHidden = true
        saveCover.proxy = self
        
        
        addSubs([maskSs, saveCover])
        
        
        maskSs.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        
        saveCover.snp.makeConstraints { (m) in
            m.size.equalTo(s)
            m.centerX.equalToSuperview()
            centerY_constraint = m.centerY.equalToSuperview()
        }
        
        
        
        
        NotificationCenter.default.addObserver(self,
                             selector: #selector(self.keyboardWillShow(noti:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        NotificationCenter.default.addObserver(self,
                             selector: #selector(self.keyboardWillHide(noti:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    


    @objc
    func keyboardWillShow(noti notification: NSNotification){
        centerY_constraint?.constraint.update(offset: s.height * (-0.5))
        layoutIfNeeded()
    }
    
    
    

    @objc
    func keyboardWillHide(noti notification: NSNotification){
        centerY_constraint?.constraint.update(offset: 0)
        layoutIfNeeded()
    }
    
    
    
}


extension EngineeringDrawingS: EngineeringDrawingSaveProxy{
    
    func done(engineeringDrawing ok: ResultFallOut) {
        endEditing(true)
        delegate?.done(drawManager: .cover(ok))
        isHidden = true
    }
}




