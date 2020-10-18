//
//  RhsArrowPair.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/12.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit

class RhsArrowPair: UIView {

    
    weak var delegate: DrawManagerProxy?
    
    
    
    lazy var upper = UIButton()
    
    lazy var lower = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupDecoration()
        
        upper.rx.tap.subscribe(onNext: { () in
            self.delegate?.done(drawManager: .arrows(true))
        }).disposed(by: rx.disposeBag)
        
        lower.rx.tap.subscribe(onNext: { () in
            self.delegate?.done(drawManager: .arrows(false))
        }).disposed(by: rx.disposeBag)
        
      //  layer.debug()
    }
    
    
    
    func setupDecoration(){
        isHidden = true
        backgroundColor = UIColor.clear
        upper.setImage(UIImage(named: "BottomPalette_arrow_up"), for: .normal)
        lower.setImage(UIImage(named: "BottomPalette_arrow_down"), for: .normal)
        
        addSubs([upper, lower])
        
        upper.snp.makeConstraints { (m) in
            m.size.equalTo(CGSize(width: 50, height: 50))
            m.top.equalTo(self.snp.top).offset(10)
            m.centerX.equalTo(self.snp.centerX).offset(10)
        }
        
        lower.snp.makeConstraints { (m) in
            m.size.centerX.equalTo(upper)
            m.bottom.equalTo(self.snp.bottom).offset(10.neg)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    
    
    
}
