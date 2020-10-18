//
//  BaseBrush.swift
//  musicSheet
//
//  Created by  on 2020/8/11.
//  Copyright © 2020 . All rights reserved.
//

import CoreGraphics

import UIKit

protocol PaintBrush {

    func drawInContext(context: CGContext)
    
}

enum BrushType {
    case pencil
    case eraser
}

class Brush: PaintBrush {
    
    var beginPoint: MyPoint!
    
    var endPoint: MyPoint!
    
    var lastPoint: MyPoint?

    var strokeWidth: CGFloat!
    
    var strokeColor: UIColor!
    
    var type: BrushType!
    
    
    var end: CGPoint{
        CGPoint(x: endPoint.x, y: endPoint.y)
    }
    
    init(type: BrushType) {
        self.type = type
        switch self.type {
        case .pencil, .none:
            strokePencil()
        case .eraser:
            strokeEraser()
        }
    }

    func drawInContext(context: CGContext) {
        switch self.type {
        case .pencil, .none:
            context.setBlendMode(.color);
        case .eraser:
            context.setBlendMode(.clear);
        }
        
        let start: CGPoint
        if let lastPoint = self.lastPoint {
            start = CGPoint(x: lastPoint.x, y: lastPoint.y)
        } else {
            start = CGPoint(x: beginPoint.x, y: beginPoint.y)
        }
        let end = CGPoint(x: endPoint.x, y: endPoint.y)
        context.move(to: start)
        context.addLine(to: end)
    }
    
    
    
    func draw(in context: CGContext, dots pairs: [CGPoint]){
        guard pairs.count > 1 else {
            return
        }
        switch self.type {
        case .pencil, .none:
            context.setBlendMode(.color);
        case .eraser:
            context.setBlendMode(.clear);
        }
        var i = 0
        var start = pairs[0]
        context.move(to: start)
        i = 1
        while i < pairs.count {
            
            start = pairs[i]
            context.addLine(to: start)
            i += 1
        }
        
        
        
    }
    
    
    func draw(in context: CGContext, pairs dots: [MyPoint]){
        draw(in: context, dots: dots.map({ CGPoint(x: $0.x, y: $0.y) }))
    }
}




extension Brush{
    func strokePencil(){
        strokeWidth = 3
        strokeColor = UIColor(rgb: 0xFF2D55)
    }
    
    
    func strokeEraser(){
        strokeWidth = 15
        strokeColor = UIColor.clear
    }
}
