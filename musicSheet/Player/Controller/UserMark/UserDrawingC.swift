//
//  UserDrawingC.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/25.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit

import SnapKit



enum UserBehave{
    case show(Int), hide, edit, construct, rm
}


enum ContentOption{
    case beats, draw
}




protocol UserDrawingBehaveProxy: class {
    func userDrawingBehave(option src: UserBehave)
    func closeBeatsContent(from src: ContentOption)
}

class UserDrawingC: UIViewController {
    
    
    lazy var markingView = DrawingUserView()
    
    
    var leadingConstraintSideCtrl: Constraint?
    
    let mask = MyLibMask()
    
    
    weak var proxy: UserDrawingBehaveProxy?
    
    
    
    
    
    
    init() {

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        view.addSubs([mask])
        mask.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        markingView.delegate = self
        
        view.addSubview(markingView)
        markingView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.width.equalTo(Split.width)
            self.leadingConstraintSideCtrl = maker.leading.equalTo(self.view.snp.trailing).constraint
        }
        
        
        actions()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        leadingConstraintSideCtrl?.update(offset: 0)
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.leadingConstraintSideCtrl?.update(offset: -Split.width)
            self.view.layoutIfNeeded()
        }
    }

    
    
    func actions(){
        let tap = UITapGestureRecognizer()
        mask.addGestureRecognizer(tap)
        tap.rx.event.bind { [weak self]  (event) in
            guard let `self` = self else { return }
            self.closeBeatsContent(from: .draw)
            }.disposed(by: rx.disposeBag)
        
        
        mask.isUserInteractionEnabled = true
        
        
        
        // 这个是，做一层覆盖
        
        let pan = RightPanGesture(target: self, action: #selector(self.push(_:)))
        mask.addGestureRecognizer(pan)
      
        
        markingView.newDo.rx.tap.subscribe(onNext: { () in
            self.proxy?.userDrawingBehave(option: .construct)
            
        }).disposed(by: rx.disposeBag)
        
        
        
        let tapBack = UITapGestureRecognizer()
        markingView.arrow.addGestureRecognizer(tapBack)
        tapBack.rx.event.bind { [unowned self] (event) in
            self.closeBeatsContent(from: .draw)
            }.disposed(by: rx.disposeBag)
    }
    
    
    
    @objc func push(_ gesture: RightPanGesture){
        closeBeatsContent(from: .draw)
    }
}




extension UserDrawingC: UserDrawingBehaveProxy{
    func userDrawingBehave(option src: UserBehave) {
        proxy?.userDrawingBehave(option: src)
    }
    
    func closeBeatsContent(from src: ContentOption) {
        proxy?.closeBeatsContent(from: src)
    }
    
}


extension UserDrawingC{
    func reload(){
        markingView.refresh()
    }
    
}


