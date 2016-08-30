//
//  addFieldView.swift
//  Climbing
//
//  Created by Leo on 8/26/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class AddFieldView: UIView {
    

    @IBOutlet weak var textField: UITextField!
    var newField = FieldModel(fieldName: nil, challangeRoute: [])
    override func layoutSubviews() {
        textField.layer.masksToBounds = false;
        textField.layer.shadowOffset = CGSizeMake(3, 3);
        textField.layer.shadowRadius = 5;
        textField.layer.shadowOpacity = 0.5;
    }
   
    @IBAction func clean(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("closeView:", object: nil)
    }

    @IBAction func done(sender: AnyObject) {
        newField.fieldName = self.textField.text!
        
        FieldCollection.shareInstance.currentField.append(newField)
        NSNotificationCenter.defaultCenter().postNotificationName("closeView:", object: nil)
        
    }

}