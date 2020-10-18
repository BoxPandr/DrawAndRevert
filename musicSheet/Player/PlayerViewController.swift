//
//  PlayerViewController.swift
//  musicSheet
//
//  Created by Jz D on 2019/9/12.
//  Copyright © 2019 Jz D. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit


import RxSwift

import RxCocoa
 
class PlayerViewController: UIViewController{
   

    var currentIndex: Float = 0
    
    
    lazy var map = {() -> UICollectionView in
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = .zero
        flow.minimumInteritemSpacing = .zero
        let tb = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flow)
        tb.backgroundColor = UIColor.white
        tb.showsVerticalScrollIndicator = false
        tb.showsHorizontalScrollIndicator = false
        tb.register(cell: MapPiece.self)
        tb.register(header: EmptyReuseView.self)
        tb.register(footer: EmptyReuseView.self)
        tb.delegate = self
        tb.dataSource = self
        tb.isScrollEnabled = true
        tb.isPrefetchingEnabled = false
        return tb
    }()
    
    
    lazy var set_more_btn = { () -> HotP_Img in
        let img = HotP_Img(image: UIImage(named: "set_more_btn_p").temp)
        img.tintColor = UIColor.newPlayer
        return img
    }()
 
    var score: GeneralSingle<MusicScore>?
    
    
    var layout_info = ComposeLayout(nil)
    
    lazy var drawAdmin = DrawManager(delegate: self)
    
    //MARK:- 以下均为画板属性

    
    // MARK:- life cycle
    
    
    lazy var userMarkingC: UserDrawingC = {
        let ctrl = UserDrawingC()
        ctrl.proxy = self
        return ctrl
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        
        
        view.addSubs( [map, set_more_btn] )
        
        set_more_btn.snp.makeConstraints { (m) in
            m.size.equalTo(CGSize(width: 32, height: 32))
            m.centerY.equalTo(view.snp.top).offset(11 + 58 * 0.5)
            m.trailing.equalToSuperview().offset(-13)
        }

        
        
        let setBeats = UITapGestureRecognizer()
        set_more_btn.addGestureRecognizer(setBeats)
        let settingSignal = setBeats.rx.event
        
        settingSignal.bind { [weak self]  (event) in
            guard let `self` = self else { return }
            self.comeMarking()
        
        }.disposed(by: rx.disposeBag)
        
        
        do{
            
            if let path = Bundle.main.url(forResource: "oneX", withExtension: "plist"){
                let data = try Data(contentsOf: path)
                let decoder = PropertyListDecoder()
                let score_Jz = try decoder.decode(GeneralSingle<MusicScore>.self, from: data)
                self.score = score_Jz
                self.layout_info = ComposeLayout(score_Jz.data)
                map.reloadData()
                addDrawBottom()
            }

          
            
        }
        catch let error as NSError{
            
            print("gg \(error)")
        }

        
        
    }
    
    
}








extension PlayerViewController{
 
    func closeBeatsContent(from src: ContentOption) {
        userMarkingC.getOut()
    }
}


// iOS 端的录音算法，还要做一个降噪



struct GeneralSingle<T>: Decodable  where T: Decodable {
    let code: Int
    var data: T
    var state: Int
//  直接改为动态的
}
