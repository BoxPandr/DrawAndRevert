//
//  DrawingSaveCover.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/12.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


enum DrawingSaveCoverOption{
    case origin
    case edit
}


class DrawingSaveCover: UIView {

    
    var head = UILabel()
    
    let createB = { (name: String) -> UIButton in
        let bb = UIButton()
        bb.setTitle(name, for: .normal)
        bb.cornerHalf()
        bb.titleLabel?.font = UIFont.regular(ofSize: 20)
        return bb
    }
    
    
    lazy var saveBtn = createB("立即保存")
    
    lazy var ggBtn = createB("放弃保存")
    
    weak var proxy: EngineeringDrawingSaveProxy?
    
    var from = DrawingSaveCoverOption.origin
    
    
    
    init(){
        
        super.init(frame: .zero)
     
        
        doDecorate()
        doPosition()
        doActions()
        
    }
    
    func doDecorate(){
        backgroundColor = UIColor.white
        corner(8)
        
        head.text = "保存标注"
        head.textColor = UIColor(rgb: 0x333333)
        head.textAlignment = .center
        head.font = UIFont.medium(ofSize: 24)
        
        
        saveBtn.setTitleColor(UIColor.white, for: .normal)
        saveBtn.backgroundColor = UIColor(rgb: 0xFF2D55)
        
        ggBtn.setTitleColor(UIColor(rgb: 0x999999), for: .normal)
        ggBtn.backgroundColor = UIColor(rgb: 0xF0F0F0)
    }
    
    
    
    func doPosition(){
        
        addSubs([head, saveBtn, ggBtn ])
        
        head.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().offset(56)
        }
        
        let lhsOffset: CGFloat = 54
        saveBtn.snp.makeConstraints { (m) in
            m.size.equalTo(CGSize(width: 160, height: 50))
            m.leading.equalToSuperview().offset(lhsOffset)
            m.bottom.equalToSuperview().offset(56.neg)
        }
        
        ggBtn.snp.makeConstraints { (m) in
            m.size.bottom.equalTo(saveBtn)
            m.trailing.equalToSuperview().offset(lhsOffset.neg)
        }
        
        
        
        
    }
    
    
    
    
    func doActions(){
        saveBtn.rx.tap.subscribe(onNext: { () in
            switch self.from{
            case .origin:
                
                self.proxy?.done(engineeringDrawing: .ok)
            case .edit:
                
                self.proxy?.done(engineeringDrawing: .editOK)
            }
            
        }).disposed(by: rx.disposeBag)
        
        
        ggBtn.rx.tap.subscribe(onNext: { () in
            
            self.proxy?.done(engineeringDrawing: .hehe)
            
        }).disposed(by: rx.disposeBag)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}



