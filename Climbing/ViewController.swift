//
//  ViewController.swift
//  Climbing
//
//  Created by Leo on 8/10/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    var index: Int?
    var tField: UITextField!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.blackColor()
        super.viewDidLoad()
        //self.scoreLabel.text = String(TargetHouse.shareInstance.currentPoint)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.refresh), name: "refresh:", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.deleteTarget), name: "deleteTarget:", object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addTarget(sender: AnyObject) {
        
        let newTarget = TargetFactory().createTarget("\(TargetHouse.shareInstance.currentTargets.count)")
        newTarget.image.tag = Int(newTarget.id!)
        TargetHouse.shareInstance.currentTargets.append(newTarget)
        view.addSubview(newTarget.image)

    }
    
    @IBAction func saveAxis(sender: AnyObject) {
        
        let newRoute = Route(difficulty: nil, center: nil, rankList: [])
        let alert = UIAlertController(title: "Give a rank", message: "", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler:{ (UIAlertAction) in
            newRoute.difficulty = "Rank:\(self.tField.text!)"
            var currentCenter = [String]()
            for view: UIView in self.view.subviews {
                if (view is UIImageView) {
                    let center = NSStringFromCGPoint(view.center)
                    currentCenter.append(center)
                }
            }
            newRoute.center = currentCenter
            FieldCollection.shareInstance.currentField[self.index!].challangeRoute.append(newRoute)
            let ref = FIRDatabase.database().reference()
            let childRef = ref.child("Trainer").child("FieldName")
            let childRefWithKey = childRef.child(childRef.key).child(FieldCollection.shareInstance.currentField[self.index!].fieldName!)
            let value = ["difficulty": self.tField.text!]
            childRefWithKey.updateChildValues(value)
            self.deleteTarget()
        }))
        self.presentViewController(alert, animated: true, completion: {
            
        })

        
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        
        if parent == nil {
            NSNotificationCenter.defaultCenter().postNotificationName("reload:", object: nil)
            }
        }
    
    func configurationTextField(textField: UITextField!)
    {
        textField.placeholder = "Enter a rank"
        textField.keyboardType = .NumberPad
        tField = textField
    }
    
    func handleCancel(alertView: UIAlertAction!)
    {
        
    }
    
    func refresh(){
//        self.scoreLabel.text = String(TargetHouse.shareInstance.currentPoint)
    }
    
    func deleteTarget() {
        TargetHouse.shareInstance.currentTargets.removeAll()
        for view: UIView in self.view.subviews {
            if (view is UIImageView) {
                view.removeFromSuperview()
            }
        }
//        self.scoreLabel.text = "0"
//        TargetHouse.shareInstance.currentPoint = 0
    }
}

