//
//  TargetModel.swift
//  Climbing
//
//  Created by Leo on 8/10/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class TargetModel: NSObject, UIGestureRecognizerDelegate {
    
    var image: UIImageView
    var imageName: String
    var id: UInt32?

    
    func tapBubbleOnce(sender: UITapGestureRecognizer?) {
        if image.backgroundColor == UIColor.whiteColor() {
        image.backgroundColor = UIColor.yellowColor()
        //    image.image = UIImage(named: "pika")
        //TargetHouse.shareInstance.currentPoint += 1
            NSNotificationCenter.defaultCenter().postNotificationName("tapBubbleOnce:", object: nil)
        }
    }
    
    func tapBubbleTwice(sender: UITapGestureRecognizer?) {
        if image.backgroundColor == UIColor.yellowColor() {
        image.backgroundColor = UIColor.whiteColor()
        //    image.image = UIImage(named: "pokeball")
        //TargetHouse.shareInstance.currentPoint -= 1
        }
    }
    
    func longPressBubble(sender: UILongPressGestureRecognizer?) {
        NSNotificationCenter.defaultCenter().postNotificationName("deleteTarget:", object: nil)
    }
    
    
    let mainView = UIApplication.sharedApplication().keyWindow?.superview
    
    func dragTarget(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.locationInView(mainView);
        image.center.x = point.x
        image.center.y = point.y
    }
    
    
    init(image: UIImageView, imageName: String, id: UInt32?){
        
        self.imageName = imageName
        self.image  = image
        self.image.image = UIImage(named: imageName)
        self.id = id
        
        super.init()
        
        image.userInteractionEnabled = true
        
        let tapOne = UITapGestureRecognizer(target: self, action: #selector(TargetModel.tapBubbleOnce(_:)))
        tapOne.numberOfTapsRequired = 1
        image.addGestureRecognizer(tapOne)
        
        let tapTwo = UITapGestureRecognizer(target: self, action: #selector(TargetModel.tapBubbleTwice(_:)))
        tapTwo.numberOfTapsRequired = 2
        image.addGestureRecognizer(tapTwo)
        
        
        let dragBall = UIPanGestureRecognizer(target: self, action: #selector(TargetModel.dragTarget(_:)))
        image.addGestureRecognizer(dragBall)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(TargetModel.longPressBubble(_:)))
        image.addGestureRecognizer(longPress)
        
        tapOne.delegate = self
        tapTwo.delegate = self
        dragBall.delegate = self
        
        
    }

}
