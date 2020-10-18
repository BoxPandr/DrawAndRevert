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
 




struct GeneralSingle<T>: Decodable  where T: Decodable {
    let code: Int
    var data: T
    var state: Int
//  直接改为动态的
}







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
                let scoreData = try decoder.decode(GeneralSingle<MusicScore>.self, from: data)
                self.score = scoreData
                self.layout_info = ComposeLayout(scoreData.data)
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





extension PlayerViewController{
    
    func addDrawBottom(){
        
        view.addSubs([ drawAdmin.bottomBar])
        map.addSubs([drawAdmin.painterView, drawAdmin.painterReadOnly])
       
        view.addSubs([drawAdmin.arrowPair,  drawAdmin.engineeringCover])
        drawAdmin.bottomBar.snp.makeConstraints { (m) in
            m.leading.trailing.bottom.equalToSuperview()
            m.height.equalTo(50 + Pen.reimburse)
        }
      
        drawAdmin.arrowPair.snp.makeConstraints { (m) in
            m.trailing.equalToSuperview().offset(-4)
            m.size.equalTo(CGSize(width: 50 + 20, height: 130 + 20))
            m.centerY.equalToSuperview()
        }
        
        drawAdmin.engineeringCover.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        
        var height: CGFloat = 200
        guard let heights = self.score?.data.heights else {
            return
        }
        for item in heights {
            height += item.value
        }
        drawAdmin.painterView.snp.makeConstraints { (m) in
            m.leading.top.width.equalTo(map)
            m.height.equalTo(height)
        }
        
        
        drawAdmin.painterReadOnly.snp.makeConstraints { (m) in
            m.leading.top.width.equalTo(map)
            m.height.equalTo(height)
        }
    }
    
    
}






extension PlayerViewController: DrawManagerCalling{
    
    
    func showBack(){
        map.isScrollEnabled = true
        map.reloadData()
        set_more_btn.isHidden = false
        comeMarking()
    }
    
    
    
    // 根据 contentOffset.y,
    // 算出 item 的 index
    func scroll(map upwards: Bool){
        
        if upwards{
            if self.currentIndex > Float(Int(self.currentIndex)) {
                self.currentIndex = Float(Int(self.currentIndex)) + 1
            }
            if self.currentIndex == 0 {
                self.xxScroll(0)
                return
            }
            
            self.currentIndex -= 1
        }
        else{
            let heights = self.score?.data.heights
            if Int(self.currentIndex) >= heights!.count - 1 {
                return
            }
            self.currentIndex += 1
        }
        
        xxScroll(Int(self.currentIndex))
        
    }
    
    
    func xxScroll(_ item: Int = 0){
        guard let pads = layout_info.rowHeights else{
            return
        }
        
        var h: CGFloat = 0
        
        switch item {
        case -2:
            ()
        case 0, 1:
            h = 0
        default:
            //  1...
            h = -1
            for i in 0..<(item - 1){
                if let height = pads[i]{
                    h += height
                }
            }
        }
        map.setContentOffset(CGPoint(x: 0, y: h ), animated: true)
    }
}


