//
//  TargetFactory.swift
//  Climbing
//
//  Created by Leo on 8/10/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class TargetFactory {
    
    let mainWidth = UIScreen.mainScreen().bounds.width
    let mainHeight = UIScreen.mainScreen().bounds.height
    let target = UIImageView(frame: CGRect(x: 120, y: 60, width: 40, height: 40))
    let id = arc4random()
    var timer: NSTimer?
    
    
    func createTarget(imageName: String, modeDection: Bool) -> TargetModel {
        
        target.backgroundColor = UIColor.whiteColor()
        //target.image = UIImage(named: "pokeball")

        target.layer.cornerRadius = 20
        
        let textLayer = CATextLayer()
        textLayer.frame = target.bounds
        
        let string = "\(imageName)"
        textLayer.string = string
        
        textLayer.foregroundColor = UIColor.blackColor().CGColor
        textLayer.wrapped = true
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.fontSize = 32
        textLayer.contentsScale = UIScreen.mainScreen().scale
        target.layer.addSublayer(textLayer)
        
        return TargetModel(image: target, imageName: imageName, id: id, modeDetection: modeDection)
    }
    
    func createFlyTarget(imageName: String) -> TargetModel {
        
        target.backgroundColor = UIColor.whiteColor()
        //target.image = UIImage(named: "pokeball")
        
        target.layer.cornerRadius = 20
        
        let textLayer = CATextLayer()
        textLayer.frame = target.bounds
        
        let string = "\(imageName)"
        textLayer.string = string
        
        textLayer.foregroundColor = UIColor.blackColor().CGColor
        textLayer.wrapped = true
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.fontSize = 32
        textLayer.contentsScale = UIScreen.mainScreen().scale
        target.layer.addSublayer(textLayer)
        
        return TargetModel(image: target, imageName: imageName, id: id, modeDetection: true)
        
    }
    
    
//    func checkTarget() {
//        
//        target.backgroundColor = UIColor.redColor()
//        
//    }

}

