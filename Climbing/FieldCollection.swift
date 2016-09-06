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
//    let userDefault = NSUserDefaults.standardUserDefaults()
    let ref = FIRDatabase.database().reference()
    var numbers: Int = 0
    var currentField = [FieldModel]() {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("reload:", object: nil)
        }
    }
    
//    func updateToDefault() {
//         let data = NSKeyedArchiver.archivedDataWithRootObject(FieldCollection.shareInstance.currentField)
//         self.userDefault.setValue(data, forKey: "currentField")
//         self.userDefault.synchronize()
//    }
    
    func getFieldFromFirebase() {
        ref.child("Trainer").child("Field").observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let name = childSnapshot.value!.objectForKey("FieldName") as? String
                let newField = FieldModel(fieldName: nil, challangeRoute: [])
                newField.fieldName = name
                FieldCollection.shareInstance.currentField.append(newField)
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    func getNewFieldFromFirebase() {
        FieldCollection.shareInstance.currentField.removeAll()
        ref.child("Trainer").child("Field").observeEventType(.ChildAdded, withBlock: { snapshot in
            
                //let childSnapshot = snapshot.childSnapshotForPath(snapshot.key)
                let name = snapshot.value!.objectForKey("FieldName") as? String
                let newField = FieldModel(fieldName: nil, challangeRoute: [])
                newField.fieldName = name
                FieldCollection.shareInstance.currentField.append(newField)
                print(name)
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    
}

