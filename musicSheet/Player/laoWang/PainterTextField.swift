//
//  PainterTextField.swift
//  musicSheet
//
//  Created by  on 2020/8/18.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

protocol PainterTextEventDelegate {
    func onTextModified(textViewId: Int, content: String)
}



struct PaintLayout {
    static let s = CGSize(width: 150, height: 50)
}

class PainterTextField: UITextField, UITextFieldDelegate {
    
    var id_Dng = -1
    
    var dele: PainterTextEventDelegate
    
    var content: String = ""
    
 
    
    
    
    init(id: Int, dele: PainterTextEventDelegate){
        id_Dng = id
        self.dele = dele
        super.init(frame: .zero)
        
        clearButtonMode = .whileEditing
        textColor = UIColor(rgb: 0xFF2D55)
        font = UIFont.regular(ofSize: 16)
        text = ""
        self.delegate = self
        
        backgroundColor = UIColor.clear
        
        borderActive()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        borderActive()
        guard let text = textField.text else {
            return
        }
        self.content = text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        borderGG()
        if let str = textField.text, self.content == str {
            return
        }
        dele.onTextModified(textViewId: id_Dng, content: textField.text ?? "")
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var back = true
        if let textFieldText = textField.text{
            let count = textFieldText.count
            
            if count > 7{
                var f = frame
                f.size.width = PaintLayout.s.width + count.paintWidth
                frame = f
                back = false
            }
        }
        if back{
            var f = frame
            f.size.width = PaintLayout.s.width
            frame = f
        }
        
        
        return true
    }
    
    
}



extension PainterTextField{
    
    func borderActive(){
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1.0
    }
    
    
    func borderGG(){
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
    }
    
}




extension Int{
    var paintWidth: CGFloat{
        if self > 7{
            return 12 * CGFloat(self - 7)
        }
        else{
            return .zero
        }
    }
    
    

}
