//
//  DrawingUserView.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/25.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


class DrawingUserView: UIView {

    
    let headline = { () -> UILabel in
        let lbl = UILabel()
        lbl.font = UIFont.regular(ofSize: 18)
        lbl.textColor = UIColor.textHeavy
        lbl.textAlignment = .center
        lbl.text = "标注"
        return lbl
    }()
    
    let arrow = { () -> UIImageView in
        let img = UIImageView()
        img.image = UIImage(named: "left_return")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    
    let line: UIView = {
        let string = UIView()
        string.backgroundColor = UIColor(rgb: 0xD8D8D8)
        return string
    }()
    
    
    lazy var newDo = DrawBtn()
        
    
    var delegate: UserDrawingBehaveProxy?
    
    
    
    lazy var contentDng: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tb.allowsSelection = false
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.rowHeight = 55
        tb.register(for: TopDrawListExistCel.self)
        return tb
    }()
    
    
    
    private
    var showChooseK: Int?
    

    
    init() {

        super.init(frame: .zero)
        backgroundColor = UIColor.white
        
        
        addSubs([headline, arrow, line,
                 newDo, contentDng ])
        
        
        
        headline.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(20)
            maker.size.equalTo(CGSize(width: 80 + 15, height: 25))
        }
        
        arrow.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 30, height: 30))
            maker.top.equalToSuperview().offset(17)
            maker.leading.equalToSuperview().offset(16)
        }
        
        line.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
            maker.top.equalToSuperview().offset(63)
        }
        
        contentDng.snp.makeConstraints { (m) in
            m.leading.trailing.equalToSuperview()
            m.top.equalTo(line.snp.bottom).offset(12)
            m.bottom.equalTo(newDo.snp.top).offset(-12)
        }
        
        newDo.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.height.equalTo(60)
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




extension DrawingUserView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let labelUrl = documentsURL.appendingPathComponent("label")
        if FileManager.default.fileExists(atPath: labelUrl.path){
            count += 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeue(for: TopDrawListExistCel.self, ip: indexPath)
        cel.delegate = self
        var selectIdx = false

        let item = indexPath.row
        if let idx = showChooseK{
            selectIdx = (idx == item)
        }
        
        if indexPath.row == 0{
            cel.example(ip: item, selected: selectIdx)
        }
        else{
            cel.config(ip: item, selected: selectIdx)
        }
        return cel
    }
}




extension DrawingUserView: DrawExistCelProxy{
    
    
    func cellDrawingBehave(option src: UserCelOption){
        switch src {
        case .change:
            showChooseK = nil
            delegate?.userDrawingBehave(option: .edit)
        case .hide:
            showChooseK = nil
            refresh()
            delegate?.userDrawingBehave(option: .hide)
        case .show(let idx):
            showChooseK = idx
            refresh()
            delegate?.userDrawingBehave(option: .show(idx))
        case .rm:
            showChooseK = nil
            delegate?.userDrawingBehave(option: .rm)
        }
    }
    
    
    
    
    func refresh(){
        
        var ok = true
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let labelUrl = documentsURL.appendingPathComponent("label")
        if FileManager.default.fileExists(atPath: labelUrl.path){
            ok = false
        }
   
        if ok{
            newDo.normal()
        }
        else{
            newDo.disabled()
        }
        contentDng.reloadData()
    }
    
}





extension DrawingUserView{
    func clear(){
        showChooseK = nil
    }
}
