//
//  CornerRadius.swift
//  musicSheet
//
//  Created by Jz D on 2020/1/5.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


import RxSwift
import RxCocoa

import NSObject_Rx


extension UIView{
    
    func cornerHalf(){
        clipsToBounds = true
        rx.observe(CGRect.self, #keyPath(UIView.bounds))
            .subscribe(onNext: { _ in
                // _ : CGRect? in
                self.layer.cornerRadius = self.bounds.height * 0.5
            }).disposed(by: rx.disposeBag)
    }
    
    
}
