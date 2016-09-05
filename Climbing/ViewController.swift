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
    var i = 0
    let ref = FIRDatabase.database().reference()

    
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
            newRoute.difficulty = self.tField.text!
            // update Route to Firebase
            let childRouteRef = self.ref.child("Trainer").child("Route").child("\(FieldCollection.shareInstance.currentField[self.index!].fieldName!)").childByAutoId()
            
            let value = ["ID": self.tField.text!]
            childRouteRef.updateChildValues(value)
            var currentCenter = [String]()
            // update Path to Firebase
            let childPathRef = self.ref.child("Trainer").child("Path").child("\(FieldCollection.shareInstance.currentField[self.index!].fieldName!)").child(self.tField.text!)
            for view: UIView in self.view.subviews {
                if (view is UIImageView) {
                    let center = NSStringFromCGPoint(view.center)
                    currentCenter.append(center)
                    let value = ["\(self.i)":center]
                    childPathRef.updateChildValues(value)
                    self.i+=1
                }
            }
            newRoute.center = currentCenter
            FieldCollection.shareInstance.currentField[self.index!].challangeRoute.append(newRoute)
            //FieldCollection.shareInstance.updateToDefault()
            self.deleteTarget()
            self.i = 0
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
    }
}

