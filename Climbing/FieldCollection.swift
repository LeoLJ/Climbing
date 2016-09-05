//
//  FieldCollection.swift
//  Climbing
//
//  Created by Leo on 8/26/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON

class FieldCollection {
    static let shareInstance = FieldCollection()
    let userDefault = NSUserDefaults.standardUserDefaults()
    let ref = FIRDatabase.database().reference()
    var numbers: Int = 0
    var currentField = [FieldModel]() {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("reload:", object: nil)
        }
    }
    
    func updateToDefault() {
         let data = NSKeyedArchiver.archivedDataWithRootObject(FieldCollection.shareInstance.currentField)
         self.userDefault.setValue(data, forKey: "currentField")
         self.userDefault.synchronize()
    }
    
    func getAllFromFirebase() {
        
        ref.child("Trainer").child("Path").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value {
                //let json = JSON(data)
                //let Field = json["Trainer"]["Field"][1].string
                //let Route = json["Trainer"]["Route"][1][self.ref.key]["ID"].string
                print(data)
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }
    
    
}

