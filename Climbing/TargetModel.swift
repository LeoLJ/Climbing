//
//  TargetModel.swift
//  Climbing
//
//  Created by Leo on 8/10/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit
import AVFoundation

class TargetModel: NSObject, UIGestureRecognizerDelegate {
    
    var image: UIImageView
    var imageName: String
    var id: UInt32?
    let systemSoundID: SystemSoundID = 1016
    var modeDetection: Bool
    var position: TargetPosition?
    
    
    func tapBubbleOnce(sender: UITapGestureRecognizer?) {
        if position != nil{
            if image.backgroundColor == UIColor.whiteColor() {
                image.image = UIImage(named: "Smile")
                image.backgroundColor = UIColor.clearColor()
                image.layer.sublayers?.removeAll()
                AudioServicesPlaySystemSound (systemSoundID)
            }
            
            if position == .Left {
            NSNotificationCenter.defaultCenter().postNotificationName("tapBubbleFromLeftView:", object: nil)
            }else {
            NSNotificationCenter.defaultCenter().postNotificationName("tapBubbleFromRightView:", object: nil)
            }
            
        }else {
            if image.backgroundColor == UIColor.whiteColor() {
                image.image = UIImage(named: "Smile")
                image.backgroundColor = UIColor.clearColor()
                image.layer.sublayers?.removeAll()
                AudioServicesPlaySystemSound (systemSoundID)
                //    image.image = UIImage(named: "pika")
                //TargetHouse.shareInstance.currentPoint += 1
                NSNotificationCenter.defaultCenter().postNotificationName("tapBubbleOnce:", object: nil)
            }
        }
        
    }
    
    
    func tapBubbleTwice(sender: UITapGestureRecognizer?) {
        if image.image == UIImage(named: "smile") {
            image.backgroundColor = UIColor.whiteColor()
            //    image.image = UIImage(named: "pokeball")
            //TargetHouse.shareInstance.currentPoint -= 1
        }
    }
    
    func longPressBubble(sender: UILongPressGestureRecognizer?) {
        NSNotificationCenter.defaultCenter().postNotificationName("deleteTarget:", object: nil)
    }
    
    
    let mainView = UIApplication.sharedApplication().keyWindow?.superview
    let mainFrame = UIApplication.sharedApplication().keyWindow?.bounds
    
    func dragTarget(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.locationInView(mainView);
        if point.y < (mainFrame?.minY)! + 30 || point.x > (mainFrame?.maxX)! - 20 || point.x < (mainFrame?.minX)! + 35 {
            //                let newframe = CGRectMake(point.x, point.y, 60, 60)
            //                image.frame = newframe
        }else{
            image.center.x = point.x
            image.center.y = point.y
        }
    }
    
    
    init(image: UIImageView, imageName: String, id: UInt32?, modeDetection: Bool){
        
        self.imageName = imageName
        self.image  = image
        self.image.image = UIImage(named: imageName)
        self.id = id
        self.modeDetection = modeDetection
        
        super.init()
        
        image.userInteractionEnabled = true
        
        if modeDetection {
            
            let tapOne = UITapGestureRecognizer(target: self, action: #selector(TargetModel.tapBubbleOnce(_:)))
            tapOne.numberOfTapsRequired = 1
            image.addGestureRecognizer(tapOne)
            
            let tapTwo = UITapGestureRecognizer(target: self, action: #selector(TargetModel.tapBubbleTwice(_:)))
            tapTwo.numberOfTapsRequired = 2
            image.addGestureRecognizer(tapTwo)
            
            tapOne.delegate = self
            tapTwo.delegate = self
            
        }
        
        
        let dragBall = UIPanGestureRecognizer(target: self, action: #selector(TargetModel.dragTarget(_:)))
        image.addGestureRecognizer(dragBall)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(TargetModel.longPressBubble(_:)))
        image.addGestureRecognizer(longPress)
        
        dragBall.delegate = self
        
        
    }
    //sound setting
    func playSound(soundName: String)
    {
        let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType: "m4a")!)
        do{
            let audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }catch {
            print("Error getting the audio file")
        }
    }
    
}


enum TargetPosition {
    case Left
    case Right
}
