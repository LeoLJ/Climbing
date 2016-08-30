//
//  FieldCollection.swift
//  Climbing
//
//  Created by Leo on 8/26/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class FieldCollection {
    static let shareInstance = FieldCollection()
    let userDefault = NSUserDefaults.standardUserDefaults()

    var currentField = [FieldModel]() {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("reload:", object: nil)
            let data = NSKeyedArchiver.archivedDataWithRootObject(FieldCollection.shareInstance.currentField)
            self.userDefault.setValue(data, forKey: "currentField")
            self.userDefault.synchronize()
        }
    }
}
