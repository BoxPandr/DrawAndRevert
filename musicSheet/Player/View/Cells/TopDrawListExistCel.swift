//
//  PlayTopMoreListPi.swift
//  musicSheet
//
//  Created by Jz D on 2020/5/9.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


enum UserCelOption{
    case show(Int), hide, rm, change
}

protocol DrawExistCelProxy: class {
    func cellDrawingBehave(option src: UserCelOption)
}





class TopDrawListExistCel: UITableViewCell {
    
    
    
    @IBOutlet weak var img: UIImageView!
    
    
    @IBOutlet weak var displayB: UIButton!
    
    
    
    @IBOutlet weak var editB: UIButton!
    
    
    
    
    @IBOutlet weak var title: UILabel!
    
    var item: Int?
    
    weak var delegate: DrawExistCelProxy?
    
    func config(ip index: Int, selected choose: Bool){
        title.text = "试着玩"
        item = index
        displayB.isSelected = choose
        if choose{
            self.displayB.showChoose()
        }
        else{
            self.displayB.showDefault()
        }
        
        
        img.isHidden = false
        
        displayB.isHidden = false
        editB.isHidden = false
    }
    
    
    
    
    func example(ip index: Int, selected choose: Bool){
        title.text = "示例"
        
        
        item = index
        displayB.isSelected = choose
        if choose{
            self.displayB.showChoose()
        }
        else{
            self.displayB.showDefault()
        }
        
        img.isHidden = true
        displayB.isHidden = false
        editB.isHidden = true
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        displayB.setTitle("显示", for: .normal)
        displayB.setTitle("隐藏", for: .selected)
        
        img.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        img.addGestureRecognizer(tap)
        tap.rx.event.bind { [unowned self] (event) in
            
                self.delegate?.cellDrawingBehave(option: .rm)
            
            }.disposed(by: rx.disposeBag)
        
        
        
        displayB.corner(6)
        
        displayB.rx.tap.subscribe(onNext: { () in
            guard let i = self.item else{
                return
            }
            if self.displayB.isSelected{
                self.displayB.showDefault()
                self.delegate?.cellDrawingBehave(option: .hide)
            }
            else{
                self.displayB.showChoose()
                self.delegate?.cellDrawingBehave(option: .show(i))
            }
            self.displayB.isSelected.toggle()
        }).disposed(by: rx.disposeBag)
        
        
        
        
        editB.corner(6)
        
        editB.rx.tap.subscribe(onNext: { () in
            
            self.delegate?.cellDrawingBehave(option: .change)
            
        }).disposed(by: rx.disposeBag)
    }
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}





extension UIButton{
    func showChoose(){
        layer.borderColor = UIColor(rgb: 0x925EA8).cgColor
        layer.borderWidth = 1
    }
    
    
    func showDefault(){
        layer.borderWidth = 0
    }
}
