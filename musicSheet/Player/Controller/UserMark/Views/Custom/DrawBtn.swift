//
//  DrawBtn.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/25.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit

class DrawBtn: UIButton {

     let imageSide: CGFloat = 22
     let titleWidth: CGFloat = 80
     let spacing: CGFloat = 6
    
     let bgColor = UIColor(rgb: 0xFF2954)
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(named: "new_do_it"), for: .normal)
        
        setTitleColor(UIColor.white, for: UIControl.State.normal)
        setTitle("新增标注", for: UIControl.State.normal)
        titleLabel?.font = UIFont.regular(ofSize: 20)
            
            
        normal()
     }
    
    
    
     required init?(coder: NSCoder) {
         fatalError()
     }
    
    
    
    
     override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
         let h: CGFloat = 28
         let y: CGFloat = contentRect.minY + (contentRect.height - h) * 0.5 + 1
       
         let x = contentRect.minX + (contentRect.width - imageSide - spacing - titleWidth) * 0.5 + spacing + imageSide
         return CGRect(x: x, y: y, width: titleWidth, height: h)
     }
     
     
     override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
         let x = contentRect.minX + (contentRect.width - imageSide - spacing - titleWidth) * 0.5
         let y = contentRect.minY + (contentRect.height - imageSide) * 0.5
         return CGRect(x: x, y: y, width: imageSide, height: imageSide)
     }
    

    
}




extension DrawBtn{
    func normal(){
        backgroundColor = bgColor
        isEnabled = true
    }
    
    
    func disabled(){
        backgroundColor = bgColor.withAlphaComponent(0.5)
        isEnabled = false
    }
}
