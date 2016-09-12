//
//  TargetHouse.swift
//  Climbing
//
//  Created by Leo on 8/10/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class TargetHouse {
    
    let mainWidth = UIScreen.mainScreen().bounds.width
    let mainHeight = UIScreen.mainScreen().bounds.height
    
    static let shareInstance = TargetHouse()
    
    var currentTargets = [TargetModel]()
//    var currentPoint:Int = 0 {
//        didSet {
//        NSNotificationCenter.defaultCenter().postNotificationName("refresh:", object: nil)
//        }
//    }
    
    func convertPointToScale(point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x / mainWidth, y: point.y / mainHeight)
    }
    
    func convertScaleToPoint(point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * mainWidth, y: point.y * mainHeight)
    }

}
