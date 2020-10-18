//
//  PaintingControl.swift
//  musicSheet
//
//  Created by  on 2020/8/18.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

extension PlayerViewController {
    
 
    /**
     点击标注cell使用的方法
     */
    func enterPainterViewFromEdit(){
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let file = documentPath.appendingPathComponent("label")
        
        do {
            let content = try Data(contentsOf: file, options: .dataReadingMapped)
            let itemList = try JSONDecoder().decode([PaintItem].self, from: content)
            
            self.drawAdmin.showExsit()

            let tempList = self.percentageToList(list: itemList)
            self.drawAdmin.painterView.refresh(action: tempList)
            self.drawAdmin.painterView.drawList(actionList: tempList)
        } catch let err as NSError {
            print(err)
            
        }
    }
    
    
    func showPainterView(src index : Int){
        drawAdmin.change(mode: true)
        
        drawAdmin.modeOnDng = 2
        map.reloadData()
        var path: URL?
        if index == 1{
                let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let file = documentPath.appendingPathComponent("label")
                path = file
        }
        else if let file = Bundle.main.url(forResource: "label", withExtension: nil){
            path = file
        }
        guard let filePath = path else {
            return
        }
        
        do {
            let content = try Data(contentsOf: filePath, options: .dataReadingMapped)
            let itemList = try JSONDecoder().decode([PaintItem].self, from: content)
            readOnlyShowPainterView()


            let tempList = self.percentageToList(list: itemList)
            self.drawAdmin.painterReadOnly.refresh(action: tempList)
            self.drawAdmin.painterReadOnly.drawList(actionList: tempList)
        } catch let err as NSError {
            print(err)
            
        }
    }
    
    
    func percentageToList(list: [PaintItem]) -> [PaintItem] {
        let width = UIScreen.main.bounds.width
        
        var height: CGFloat = 200
        if let heights = score?.data.heights {
            for item in heights {
                height += item.value
            }
        }
           
        var tempList: [PaintItem] = []
        for item in list {
            var tempItem = item
            if let pointList = item.pointList {
                tempItem.pointList?.removeAll()
                for point in pointList {
                    let x = point.x * width / 10000
                    let y = (point.y * height) / 10000
                    tempItem.pointList?.append(MyPoint(x: x, y: y))
                }
            }
            if let pos = item.pos {
                let x = pos.x * width  / 10000
                let y = (pos.y * height) / 10000
                tempItem.pos = MyPoint(x: x, y: y)
            }
            tempList.append(tempItem)
        }
        return tempList
    }
  
    
}


extension PlayerViewController {
    
    func listToPercentageList(list: [PaintItem]) -> [PaintItem] {
        let width = UIScreen.main.bounds.width

        var height: CGFloat = 200
        if let heights = score?.data.heights {
            for item in heights {
                height += item.value
            }
        }
    
        
        var tempList: [PaintItem] = []
        for item in list {
            var tempItem = item
            if let pointList = item.pointList {
                tempItem.pointList?.removeAll()
                for point in pointList {
                    let x = point.x / width
                    let y = point.y / height
                    tempItem.pointList?.append(MyPoint(x: x, y: y))
                }
            }
            if let pos = item.pos {
                let x = pos.x / width
                let y = pos.y / height
                tempItem.pos = MyPoint(x: x, y: y)
            }
            tempList.append(tempItem)
        }
        return tempList
    }
    
   
    
}





extension PlayerViewController {



    func readOnlyShowPainterView(){
        
        map.isScrollEnabled = true
        currentIndex = 0
        var accuHeight: CGFloat = 0
        for item in self.score!.data.heights {
            accuHeight = accuHeight + item.value
            if map.contentOffset.y > accuHeight {
                self.currentIndex += 1.001
            }
        }
    }


    
    
}
