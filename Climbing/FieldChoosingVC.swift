//
//  FieldChoosingVC.swift
//  Climbing
//
//  Created by Leo on 8/26/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit
import FirebaseDatabase
class FieldChoosingVC: UIViewController {
    var tField: UITextField!

    @IBOutlet weak var fieldTableView: UITableView!
    let userDefault = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        FieldCollection.shareInstance.getAllFromFirebase()
        if self.userDefault.valueForKey("currentField") != nil {
            let data = self.userDefault.valueForKey("currentField") as! NSData
            FieldCollection.shareInstance.currentField = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [FieldModel]
        }
        self.navigationController?.navigationBarHidden = true
        
        self.fieldTableView.dataSource = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FieldChoosingVC.reload), name: "reload:", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addField(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Give it a name", message: "", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler:{ (UIAlertAction) in
            let newField = FieldModel(fieldName: nil, challangeRoute: [])
            newField.fieldName = self.tField.text!
            FieldCollection.shareInstance.currentField.append(newField)
            FieldCollection.shareInstance.updateToDefault()

            let ref = FIRDatabase.database().reference()
            let childRef = ref.child("Trainer").child("Field")
            let value = ["\(FieldCollection.shareInstance.numbers)":self.tField.text!]
            childRef.updateChildValues(value)
            FieldCollection.shareInstance.numbers += 1

        }))
        self.presentViewController(alert, animated: true, completion: {
            
        })
    }
    
    func configurationTextField(textField: UITextField!)
    {
        textField.placeholder = "Give it a name"
        tField = textField
    }
    
    func reload() {
        self.fieldTableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "checkField" {
        let vc = segue.destinationViewController as! CheckFieldVC
            vc.index = self.fieldTableView.indexPathForSelectedRow?.row
        // Pass the selected object to the new view controller.
        }
    }
    

}

extension FieldChoosingVC: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fieldCell",forIndexPath: indexPath)
        cell.textLabel?.text = FieldCollection.shareInstance.currentField[indexPath.row].fieldName
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FieldCollection.shareInstance.currentField.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            FieldCollection.shareInstance.currentField.removeAtIndex(indexPath.row)
            FieldCollection.shareInstance.updateToDefault()
            reload()
        }
    }
}