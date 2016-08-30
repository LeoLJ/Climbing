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
    
    var currentField = [FieldModel]() {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("reload:", object: nil)
        }
    }
}
