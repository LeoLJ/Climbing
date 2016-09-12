//
//  timeToPlayVC.swift
//  Climbing
//
//  Created by Leo on 8/27/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class timeToPlayVC: UIViewController {
    var fieldIndex: Int?
    var routeIndex: Int?
    var mode: String?
    var clickTime: Int = 1
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var tField: UITextField!
    var randomNumArr = [Int]()
    var indexArray = [Int]()
    var targetNum: Int?
    var currentCenter = [String]()
    let ref = FIRDatabase.database().reference()


    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        if mode == "Random-EX" {
            rankLabel.text = "Random-EX"
            displayAll()
        }else {
            rankLabel.text = "Rank:\(FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].difficulty!)"
            
            if FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].center == nil {
                getPathFromFirebase()
            }else {
                displayAll()
            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        self.view.layoutIfNeeded()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(timeToPlayVC.tapBubbleOnce), name: "tapBubbleOnce:", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "tapBubbleOnce:", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAll() {
            if mode == "Default" {
                for i in 0...FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].center!.count-1 {
                    creatTarget(i)
                }
            }else if mode == "Escalation"{
                creatTarget(0)
                
            }else if mode == "Random" {
                creatTarget(0)
            }else if mode == "Random-EX" {
                let newTarget = TargetFactory().createTarget("\(TargetHouse.shareInstance.currentTargets.count)", modeDection: true)
                newTarget.image.tag = Int(newTarget.id!)
                let ratioPoint = CGPoint(x: 0.2, y: 0.9)
                newTarget.image.center = TargetHouse.shareInstance.convertScaleToPoint(ratioPoint)
                TargetHouse.shareInstance.currentTargets.append(newTarget)
                view.addSubview(newTarget.image)
        }
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            TargetHouse.shareInstance.currentTargets.removeAll()
            //clickTime = 1
                }
    }
    
    func creatTarget(i:Int) {
        let newTarget = TargetFactory().createTarget("\(TargetHouse.shareInstance.currentTargets.count)", modeDection: true)
        newTarget.image.tag = Int(newTarget.id!)
        let ratioPoint = CGPointFromString(FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].center![i])
        newTarget.image.center = TargetHouse.shareInstance.convertScaleToPoint(ratioPoint)
        TargetHouse.shareInstance.currentTargets.append(newTarget)
        view.addSubview(newTarget.image)
    }
    
    func tapBubbleOnce() {
        switch mode {
        case "Escalation"?:
            if clickTime < FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].center!.count {
                if clickTime == 1 {
                    start()
                }
                creatTarget(clickTime)
                clickTime += 1
            }else if clickTime == FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].center!.count {
                stop()
                record()
            }
        case "Random"?:
            if clickTime < FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].center!.count  {
                if clickTime == 1 {
                    generateNumberFrom(FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].center!.count)
                    start()
                }
                let newTarget = TargetFactory().createTarget("\(clickTime)", modeDection: true)
                newTarget.image.tag = Int(newTarget.id!)
                //newTarget.image.center = CGPoint.randomPoint.random(0...Int(self.view.bounds.maxX), rangeY:0...Int(self.view.bounds.maxY))
                let i = randomNumArr[clickTime - 1]
                newTarget.image.center = CGPointFromString(FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].center![i])
                TargetHouse.shareInstance.currentTargets.append(newTarget)
                view.addSubview(newTarget.image)
                clickTime += 1
            }else if clickTime == FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].center!.count {
                stop()
                record()
            }
        case "Random-EX"?:
            if clickTime < targetNum  {
                if clickTime == 1 {
                    start()
                }
                let newTarget = TargetFactory().createTarget("\(clickTime)", modeDection: true)
                newTarget.image.tag = Int(newTarget.id!)
                let randomNumX:Double = Double(randomIntFromRange(1000000...9000000)) / Double(10000000)
                let randomNumY:Double = Double(randomIntFromRange(1000000...9000000)) / Double(10000000)
                let randomCGPoint = CGPoint(x: randomNumX, y: randomNumY)
                newTarget.image.center = TargetHouse.shareInstance.convertScaleToPoint(randomCGPoint)
                TargetHouse.shareInstance.currentTargets.append(newTarget)
                view.addSubview(newTarget.image)
                clickTime += 1
            }else if clickTime == targetNum {
                stop()
                //record()
            }
        case "Default"?:
            if clickTime < FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].center!.count  {
                if clickTime == 1 {
                    start()
                }
            }else if clickTime == FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].center!.count {
                stop()
                record()
            }
            clickTime += 1
        default: break
        }
    }
    
    func generateNumberFrom(count: Int) -> [Int] {
        
        indexArray.removeAll()
        for i in 1...count - 1 {
            indexArray.append(i)
        }
        randomNumArr.removeAll()
        for _ in 0...count - 2 {
            let arrayIndex = Int(arc4random_uniform(UInt32(indexArray.count)))
            let arrayNum = indexArray[arrayIndex]
            randomNumArr.append(arrayNum)
            indexArray.removeAtIndex(arrayIndex)
        }
        return randomNumArr
    }
    
    
    func randomIntFromRange(numRange:Range<Int>) ->Int{
        return Int(arc4random_uniform(UInt32((numRange.endIndex - numRange.startIndex))) + UInt32(numRange.startIndex))
    }
    
    
    // Get Path data form firebase
    func getPathFromFirebase() {
        ref.child("Trainer").child("Path").child(FieldCollection.shareInstance.currentField[fieldIndex!].fieldName!).child(FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].difficulty!).observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let name = childSnapshot.value! as? String
                self.currentCenter.append(name!)
            }
            FieldCollection.shareInstance.currentField[self.fieldIndex!].challangeRoute[self.routeIndex!].center = self.currentCenter
            if FieldCollection.shareInstance.currentField[self.fieldIndex!].challangeRoute[self.routeIndex!].center!.count != 0 {
                self.displayAll()
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    // Get Chart data form firebase
    func getChartFromFirebase() {
        FieldCollection.shareInstance.currentField[self.fieldIndex!].challangeRoute[self.routeIndex!].rankList.removeAll()
        ref.child("Trainer").child("Charts").child(FieldCollection.shareInstance.currentField[fieldIndex!].fieldName!).child(FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].difficulty!).observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                let players = RankList(name: nil, time: nil, mode: nil, listId: nil)
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let listID = childSnapshot.key
                players.name = childSnapshot.value!.objectForKey("Name") as? String
                players.mode = childSnapshot.value!.objectForKey("Mode") as? String
                players.time = (childSnapshot.value!.objectForKey("Time") as? String)!
                players.listId = listID
                FieldCollection.shareInstance.currentField[self.fieldIndex!].challangeRoute[self.routeIndex!].rankList.append(players)
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "charts" {
            let vc = segue.destinationViewController as! chartsVC
            vc.fieldIndex = self.fieldIndex
            vc.routeIndex =  self.routeIndex
            // Pass the selected object to the new view controller.
        }
    }
 

}

    //MARK Timer
extension timeToPlayVC {
    
    func updateTime() {        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        self.timeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    func start() {
        if !timer.valid {
            let aSelector : Selector = #selector(timeToPlayVC.updateTime)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
    
    func stop() {
        timer.invalidate()
    }
}
    //MARK show alert and also record score
extension timeToPlayVC {
    
    func record() {
        let alert = UIAlertController(title: "\(timeLabel.text!)", message: "Your Current Time", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{ _ in
            self.navigationController?.popViewControllerAnimated(true)
            }))
        
        alert.addAction(UIAlertAction(title: "Try Again", style: .Default, handler:{ _ in
            self.timeLabel.text = "00:00:00"
            self.clickTime = 1
            TargetHouse.shareInstance.currentTargets.removeAll()
            for view: UIView in self.view.subviews {
                if (view is UIImageView) {
                    view.removeFromSuperview()
                }
            }
            self.displayAll()
        }))
        
        alert.addAction(UIAlertAction(title: "Record", style: .Default, handler:{ _ in
            let nameAlert = UIAlertController(title: "Give A Name", message: "", preferredStyle: .Alert)
            nameAlert.addTextFieldWithConfigurationHandler(self.configurationTextField)
            nameAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
            nameAlert.addAction(UIAlertAction(title: "Done", style: .Default, handler:{ (UIAlertAction) in
                
                let ref = FIRDatabase.database().reference()
                let childRef = ref.child("Trainer").child("Charts").child("\(FieldCollection.shareInstance.currentField[self.fieldIndex!].fieldName!)").child("\(FieldCollection.shareInstance.currentField[self.fieldIndex!].challangeRoute[self.routeIndex!].difficulty!)").childByAutoId()
                let value = ["Name" : self.tField.text!, "Time" : self.timeLabel.text!, "Mode" : self.mode!]
                childRef.updateChildValues(value)
                self.getChartFromFirebase()
                self.performSegueWithIdentifier("charts", sender: nil)
            }))
            self.presentViewController(nameAlert, animated: true, completion: {
            })
        }))

        self.presentViewController(alert, animated: true, completion: {
        })
    }
    
    func configurationTextField(textField: UITextField!)
    {
        textField.placeholder = "Enter a name"
        tField = textField
    }
 
}

extension CGPoint {
    
    /*private functions that help alleviate the ambiguity of the modulo bias
     and nested typecasting as well as recycle similar functionality
     for either Int or Range type parameter inputs 
     https://github.com/princetrunks/Random-CGPoint-Extension */
    
    private func randomInt(num:Int) ->Int{
        return Int(arc4random_uniform(UInt32(num)))
    }
    
    private func randomIntFromRange(numRange:Range<Int>) ->Int{
        return Int(arc4random_uniform(UInt32((numRange.endIndex - numRange.startIndex) + numRange.startIndex)))
    }
    
    //private variable for the default range
    private var defaultRange : Int{
        get{return 1000}
    }
    
    //(a) public variable that creates a default random CGPoint
    static var randomPoint = CGPoint.zero.random()
    
    
    //(b) default random point creation
    func random()->CGPoint { return CGPoint(x:randomInt(defaultRange),y:randomInt(defaultRange))}
    
    //(c) using an Int parameter for both the random x and y range
    func random(range:Int)->CGPoint {
        return CGPoint(x:randomInt(range),y:randomInt(range))
    }
    
    //(d) allows for the specification of the x and y random range
    func random(rangeX:Int, rangeY:Int)->CGPoint {
        return CGPoint(x:randomInt(rangeX),y:randomInt(rangeY))
    }
    
    //(e) allows the same functionality as (c) but with a Range<Int> type parameter
    func random(range:Range<Int>)->CGPoint {
        return CGPoint(x:randomIntFromRange(range), y:randomIntFromRange(range))
    }
    
    //(f) allows the same functionality as (d) but with a Range<Int> type parameter
    func random(rangeX:Range<Int>, rangeY:Range<Int> )->CGPoint {
        return CGPoint(x:randomIntFromRange(rangeX), y:randomIntFromRange(rangeY))
    }
    
}
