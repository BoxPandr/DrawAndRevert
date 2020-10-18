//
//  PlayerViewCtrlDelegateAdd.swift
//  musicSheet
//
//  Created by Jz D on 2019/9/22.
//  Copyright © 2019 Jz D. All rights reserved.
//

import UIKit

extension PlayerViewController: UICollectionViewDelegateFlowLayout{
    
    

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard layout_info.imgList.count > 0, let data = layout_info.rowHeights else {
            return CGSize.zero
        }
        let h = data[indexPath.row] ?? CGFloat.zero

        return CGSize(width: UI.width, height: h)
    }
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionReusableView.header else {
            let football = collectionView.dequeue(footer: EmptyReuseView.self, ip: indexPath)
            return football
        }
        let football = collectionView.dequeue(header: EmptyReuseView.self, ip: indexPath)
        return football
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
       
        if drawAdmin.modeOnDng == 2{
            return CGSize(width: UI.width, height: 260)
        }
        else{
            return CGSize(width: UI.width, height: 60)
        }
        
    }
    


}




extension PlayerViewController: UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard layout_info.imgList.count > 0 else {
            return 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layout_info.imgList.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(cell: MapPiece.self, ip: indexPath)
  
        let row = indexPath.row
   
        if let pads = layout_info.rowPaddings, let edge = pads[row]{
     //       print("debug  ..... \n idx: \(row), edge: \(edge)")
            cell.config(play: layout_info.imgList[row], edge: edge, debugR: row)
        }

        return cell
    }
    
}


 
