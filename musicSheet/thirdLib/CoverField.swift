//
//  CoverField.swift
//  musicSheet
//
//  Created by Jz D on 2020/10/14.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit

class CoverField: UITextField {

       
       init() {
           super.init(frame: CGRect.zero)
           
           setup()
           
       }
       
       
       func setup() {

           font = UIFont.regular(ofSize: 20)
           clearButtonMode = .whileEditing
           
           textColor = UIColor(rgb: 0x333333)
           backgroundColor = UIColor.white
           layer.borderColor = UIColor(rgb: 0xF4F4F4).cgColor
           layer.borderWidth = 1
           corner(4)
           
       }
       
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setup()
           
       }
       
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       
    
    
       let leftOffset: CGFloat = 16
       
       
       
       override func textRect(forBounds bounds: CGRect) -> CGRect {
           var text = super.textRect(forBounds: bounds)
           text.origin.x += leftOffset
           text.size.width -= leftOffset * 2
           return text
       }
       
       override func editingRect(forBounds bounds: CGRect) -> CGRect {
           var editing = super.textRect(forBounds: bounds)
           editing.origin.x += leftOffset
           editing.size.width -= leftOffset * 2
           return editing
       }
       

}
