//
//  PlayerSideMarking.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/25.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit




extension PlayerViewController{
    
    
    func comeMarking(){
        userMarkingC.reload()
        get(in: userMarkingC)
    }
    
    
    
    
    
    
}




extension PlayerViewController: UserDrawingBehaveProxy{
    func userDrawingBehave(option src: UserBehave) {
        
        switch src {
        case .edit, .construct:
            set_more_btn.isHidden = true
            closeBeatsContent(from: .draw)
        default:
            ()
        }
        
        
        
        switch src {
        case .show(let idx):
            showPainterView(src: idx)
        case .hide:
            map.reloadData()
            drawAdmin.painterView.isHidden = true
            drawAdmin.painterReadOnly.isHidden = true
        default:
            ()
        }
        
        switch src {
        case .construct:
            newDrawing()
        case .edit:
            openEdit()
        case .rm:
            onDeleteButtonClicked()
        default:
            ()
        }
        
        
    }
    
    
}
    
    
extension PlayerViewController{
    
    
    private
    func editable(){
        
        drawAdmin.modeOnDng = 1
        map.reloadData()
        map.isScrollEnabled = false
        currentIndex = 0
        var accuHeight: CGFloat = 0
        for item in self.score!.data.heights {
            accuHeight = accuHeight + item.value
            if map.contentOffset.y > accuHeight {
                currentIndex += 1.001
            }
        }
    }
    
    
    
    func newDrawing(){
        editable()
        drawAdmin.change(mode: false)
        userMarkingC.markingView.clear()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.drawAdmin.showNew(title: "试着玩")
        }
    }
    
    

    
    func openEdit() {
        editable()
        
        drawAdmin.change(mode: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.enterPainterViewFromEdit()
        }
    }
    
 

  
}





extension PlayerViewController{
    
    func onDeleteButtonClicked(){
  
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let labelUrl = documentsURL.appendingPathComponent("label")
        if FileManager.default.fileExists(atPath: labelUrl.path){
            do {
                try FileManager.default.removeItem(atPath: labelUrl.path)
            } catch {
                print(error)
            }
            
        }
        
        drawAdmin.painterReadOnly.isHidden = true
        drawAdmin.clearBoard()
        userMarkingC.reload()
    }
}







extension PlayerViewController{
    func onLabelEditSubmitConfirmed() {
        let list = drawAdmin.painterView.actionList
        
        let tempList = listToPercentageList(list: list)
        
        if let jsonData = try? JSONEncoder().encode(tempList) {
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let labelUrl = documentsURL.appendingPathComponent("label")
            try? jsonData.write(to: labelUrl)
        }
    }
    
    
    func newLabelSubmitConfirmed() {
        let list = drawAdmin.painterView.actionList
        let tempList = listToPercentageList(list: list)
        if let jsonData = try? JSONEncoder().encode(tempList) {
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let labelUrl = documentsURL.appendingPathComponent("label")
            try? jsonData.write(to: labelUrl)
            drawAdmin.finishCover()
        }
        
    }
    
    
}







extension Int{
    var mark: String{
        "标注 \(self)"
    }
}
