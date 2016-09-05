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
        
        let newField = FieldModel(fieldName: nil, challangeRoute: [])
        
        ref.child("Trainer").child("Field").observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let name = childSnapshot.value! as! String
                newField.fieldName = name
                FieldCollection.shareInstance.currentField.append(newField)
                print(name)
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }
    
    
}

