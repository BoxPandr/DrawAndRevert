//
//  BottomPaletteView.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/11.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


struct Pen {
    let img: String
    let title: String
    
    
    static let reimburse: CGFloat = 12
}


class BottomPaletteView: UIView {
    
    
    weak var delegate: DrawManagerProxy?
    var lastIP: IndexPath?
    
    
    let data = [Pen(img: "BottomPaletteBtn_pen", title: "画笔"),
                Pen(img: "BottomPaletteBtn_txt", title: "文本"),
                Pen(img: "BottomPaletteBtn_Eraser", title: "橡皮擦"),
                Pen(img: "BottomPaletteBtn_undo", title: "撤销"),
                Pen(img: "BottomPaletteBtn_rm", title: "清除"),
                Pen(img: "BottomPaletteBtn_fork", title: "退出")]

    lazy var content: UICollectionView = {
        let tb = UICollectionView(frame: .zero, collectionViewLayout: DrawBottomLayout())
        tb.backgroundColor = UIColor.clear
        
        tb.dataSource = self
        tb.delegate = self
        tb.allowsMultipleSelection = true
        tb.register(cell: BottomPaletteButton.self)
        tb.register(top: BottomPalettePlaceHolder.self)
        return tb
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
      //  layer.debug()
        addSubs([ content ])
        content.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
}


extension BottomPaletteView: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.done(drawManager: .bottom(indexPath.item))
        if [3, 4, 5].contains(indexPath.item){
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        else{
            if let last = lastIP, last != indexPath{
                collectionView.deselectItem(at: last, animated: true)
            }
            lastIP = indexPath
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionReusableView.addTop:
            let header = collectionView.dequeue(top: BottomPalettePlaceHolder.self, ip: indexPath)
            return header
        default:
            return UICollectionReusableView.placeHolder
        }
    }
   
}



extension BottomPaletteView: UICollectionViewDataSource{
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cel = collectionView.dequeue(cell: BottomPaletteButton.self, ip: indexPath)
        let last = data.count - 1
        if indexPath.item == last{
            cel.config(display: data[last])
        }
        else{
            cel.config(display: data[indexPath.item])
        }
        
        return cel
    }
    
}




extension BottomPaletteView{
    
    
    func enter(){
        isHidden = false
        if let last = lastIP{
            content.deselectItem(at: last, animated: false)
        }
        let initial = IndexPath(item: 0, section: 0)
        content.selectItem(at: initial, animated: false, scrollPosition: .left)
        lastIP = initial
    }
    
    
    
    func applyUndoView(state ok: Bool){
        if let cell = content.cellForItem(at: IndexPath(item: 3, section: 0)) as? BottomPaletteButton{
            cell.enabled = ok
        }
        if let cel = content.cellForItem(at: IndexPath(item: 4, section: 0)) as? BottomPaletteButton{
            cel.enabled = ok
        }
    }
}




