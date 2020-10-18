//
//  RightPanGesture.swift
//  musicSheet
//
//  Created by Jz D on 2020/5/17.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


struct Constaint {
    let maxAngle: Double
    let minSpeed: CGFloat
    let toleranceDistance:CGFloat
    
    static let `default` = Constaint(maxAngle: 20, minSpeed: 40, toleranceDistance: 30)
}


class RightPanGesture: UIPanGestureRecognizer {

      var curTickleStart: CGPoint?

      let constraint: Constaint
      
      
      init(target: AnyObject, action: Selector, constraint limits: Constaint = Constaint.default) {
        
          constraint = limits
          super.init(target: target, action: action)
      }

      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
             if let touch = touches.first {
                 curTickleStart = touch.location(in: view)
             }
       }
     
    
    
      override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
             if let start = curTickleStart, let touch = touches.first{
                    let ticklePoint = touch.location(in: view)
                    let moveAmt = ticklePoint.x - start.x
                    guard moveAmt > constraint.toleranceDistance else{
                        return
                    }
                    let tangent = tan(constraint.maxAngle * Double.pi / 180)
                    if abs(ticklePoint.y - start.y)/abs(moveAmt) > CGFloat(tangent){
                        state = .cancelled
                    }
                    if state == .possible{
                        state = .ended
                    }
              }
      }
      
      override func reset() {
        curTickleStart = nil
        if state == .possible {
           state = .failed
        }
      }
      
      override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
          reset()
      }
      
      override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
          reset()
      }

  
}

