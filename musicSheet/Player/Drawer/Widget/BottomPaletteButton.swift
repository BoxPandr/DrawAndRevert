//
//  BottomPaletteButton.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/11.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit

class BottomPaletteButton: UICollectionViewCell {
    
    
    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var bg: UIView!
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                bg.backgroundColor = UIColor(rgb: 0xFFDFDF)
            }
            else{
                bg.backgroundColor = UIColor(rgb: 0xFEF0F0)
            }
        }
    }
    
    var enabled: Bool = true{
        didSet{
            if enabled{
                icon.alpha = 1
                name.alpha = 1
            }
            else{
                icon.alpha = 0.5
                name.alpha = 0.5
            }
        }
    }
    
    func config(display info: Pen){
        icon.image = UIImage(named: info.img)
        name.text = info.title
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    
}
