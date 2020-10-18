//
//  PainterAction.swift
//  musicSheet
//
//  Created by  on 2020/8/11.
//  Copyright © 2020 . All rights reserved.
//

import UIKit



enum PainterActionType {
    case line
    case text
    case eraser
    case move
    case content
}

//typealias MyPoint = CGPoint

struct MyPoint: Codable {
    
    var x: CGFloat
    
    var y: CGFloat
    
    enum CodingKeys: String, CodingKey {
        case x
        case y
    }
    
}

extension MyPoint {
    
    func toCGPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        let tx = Int(x * 10000)
        let ty = Int(y * 10000)
        
        try container.encode(tx, forKey: .x)
        try container.encode(ty, forKey: .y)
        
    }
    
}

extension CGPoint {
    func toMyPoint() -> MyPoint {
        return MyPoint(x: x, y: y)
    }
    
    
    static let offset: CGFloat = 3
    
    func controlOne(end: CGPoint) -> CGPoint{
        return CGPoint(x: (x * 3 + end.x)/4 - CGPoint.offset, y: (y * 3 + end.y)/4 - CGPoint.offset)
    }
    
    func controlTwo(end: CGPoint) -> CGPoint{
        return CGPoint(x: (x + end.x * 3)/4 + CGPoint.offset, y: (y + end.y * 3)/4 + CGPoint.offset)
    }
}


struct PaintItem: Codable {
    
    var id: Int
    
    var action: Int
    
    var pointList: [MyPoint]?
    
    private
    var originText: String?
    
    var text: String?
    
    var pos: MyPoint?
    
    init(id k: Int, action num: Int, pointList points: [MyPoint]?, text t: String?, pos p: MyPoint?){
        id = k
        action = num
        pointList = points
        
        text = t
        pos = p
 
    }
    
}

