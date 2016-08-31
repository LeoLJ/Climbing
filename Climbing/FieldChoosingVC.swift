//
//  FieldChoosingVC.swift
//  Climbing
//
//  Created by Leo on 8/26/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON


class FieldChoosingVC: UIViewController {

    @IBOutlet weak var fieldTableView: UITableView!
    let userDefault = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFireBase()
        self.navigationController?.navigationBarHidden = true
        
        self.fieldTableView.dataSource = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FieldChoosingVC.reload), name: "reload:", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FieldChoosingVC.closeView), name: "closeView:", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addField(sender: AnyObject) {
        if view.superview!.viewWithTag(0001) == nil {
            let addView = NSBundle.mainBundle().loadNibNamed("AddFieldView", owner: nil, options: nil)[0] as! AddFieldView
            addView.center =  CGPoint(x: self.view.center.x, y: self.view.center.y)
            addView.transform = CGAffineTransformMakeScale(0, 0)
            UIView.animateWithDuration(0.3, animations: {
                addView.transform = CGAffineTransformIdentity
            })
            addView.tag = 0001
            
            addView.layer.masksToBounds = false;
            addView.layer.shadowOffset = CGSizeMake(3, 3);
            addView.layer.shadowRadius = 10;
            addView.layer.shadowOpacity = 0.5;
            self.view.superview?.addSubview(addView)
        }
    }
    
    func reload() {
        self.fieldTableView.reloadData()
    }
    
    func closeView() {
        self.view.superview?.viewWithTag(0001)?.removeFromSuperview()
    }
    
    func getDataFromFireBase() {
        let trainerRef = FIRDatabase.database().reference().child("Trainer")
        trainerRef.observeEventType(.Value, withBlock: { snapshot in
            let json = JSON(snapshot.value!)
            //for i in 0...snapshot.childrenCount {
         let fieldName = json["new field"]
            print(fieldName)
            //}
            
    
            print(json)
            // need to convert JSON to models
            }, withCancelBlock: { error in
                print(error.description)
        })
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
        }
    }
}