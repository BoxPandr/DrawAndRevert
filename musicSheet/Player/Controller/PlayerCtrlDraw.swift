//
//  PlayerCtrlDraw.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/11.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


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


