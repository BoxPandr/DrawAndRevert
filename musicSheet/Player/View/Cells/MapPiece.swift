//
//  MapPiece.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/24.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


import Kingfisher




class MapPiece: UICollectionViewCell {
    
    
    
    @IBOutlet weak var debugCount: UILabel!
    @IBOutlet weak var photoPiece: UIImageView!
    
    @IBOutlet weak var maskCover: UIView!
    
    @IBOutlet weak var maskTrailing: NSLayoutConstraint!
    
    
    @IBOutlet weak var maskTop: NSLayoutConstraint!
    @IBOutlet weak var maskLeading: NSLayoutConstraint!
    @IBOutlet weak var maskButtom: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        debugCount.text = ""
        debugCount.isHidden = true
    }

    
    
    func debugCount(ip index: IndexPath){
        if index.section == 0{
            debugCount.text = "dummy head"
        }
        else{
            debugCount.text = "\(index.row)"
        }
        debugCount.isHidden = false
    }
}










extension MapPiece{
    

    
    func config(play name: String, edge: UIEdgeInsets, debugR row: Int) {
       // print("row:\(row)       name: \(name)")
        photoPiece.kf.img_P(name)
        maskLeading.constant = edge.left
        maskTop.constant = edge.top
        
        
        maskTrailing.constant = edge.right
        maskButtom.constant = edge.bottom
    
        
        contentView.layoutIfNeeded()
    }
    
    
    
    private func mask(_ willHide: Bool){
        maskCover.isHidden = willHide
    }
    
    
    func show(){
        mask(false)
    }
    
    func hide(){
        mask(true)
    }
    
    func empty(){
        photoPiece.image = UIImage(named: "deng_use_holder")
        maskCover.isHidden = true
        
        maskLeading.constant = 0
        maskTop.constant = 0
        maskTrailing.constant = 0
        maskButtom.constant = 0
        contentView.layoutIfNeeded()
    
    }
}


