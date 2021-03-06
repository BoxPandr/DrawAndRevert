//
//  CtrlAdd.swift
//  musicSheet
//
//  Created by Jz D on 2020/5/11.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit



extension UIViewController{


    func get(in vc:  UIViewController){
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        view.layoutIfNeeded()
        
    }
    

    
    func get(inBounds vc:  UIViewController){
        addChild(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        
    }
    
    
    func config(side cs: [UIViewController]){
        cs.forEach {
            addChild($0)
            view.addSubview($0.view)
            $0.view.snp.makeConstraints { (m) in
                m.top.bottom.equalToSuperview()
                m.width.equalTo(Split.width - SideContainerLayout.offsetX)
            }
        }
    }
    
    

    func getOut(){
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        
    }


}




