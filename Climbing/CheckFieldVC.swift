//
//  CheckFieldVC.swift
//  Climbing
//
//  Created by Leo on 8/26/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class CheckFieldVC: UIViewController {
    var index: Int?
    var tField: UITextField!
    var targetNum: Int?


    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fieldImage: UIImageView!
    
    @IBOutlet weak var difficultyTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.difficultyTableView.delegate = self
        self.difficultyTableView.dataSource = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CheckFieldVC.reload), name: "reload:", object: nil)

        // Transparent NavigationBar
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        self.titleLabel.text = FieldCollection.shareInstance.currentField[index!].fieldName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func addDifficulty(sender: AnyObject) {
        
    }
    
    func reload() {
        self.difficultyTableView.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "creatNewRoute" {
            let vc = segue.destinationViewController as! ViewController
            vc.index = self.index
            // Pass the selected object to the new view controller.
        }else if segue.identifier == "letsPlay" {
            let vc = segue.destinationViewController as! timeToPlayVC
            vc.fieldIndex = self.index
            vc.routeIndex =  self.difficultyTableView.indexPathForSelectedRow?.row
            vc.mode = sender as? String
            vc.targetNum = self.targetNum
            // Pass the selected object to the new view controller.
        }
        
    }
 

}

extension CheckFieldVC: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("difficultyCell",forIndexPath: indexPath)
        //if FieldCollection.shareInstance.currentField[index!].challangeRoute != nil {
        cell.textLabel?.text = "Rank:\(FieldCollection.shareInstance.currentField[index!].challangeRoute[indexPath.row].difficulty!)"
        //}
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  if FieldCollection.shareInstance.currentField[index!].challangeRoute != nil {
        return FieldCollection.shareInstance.currentField[index!].challangeRoute.count
      //  }
      //  return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            FieldCollection.shareInstance.currentField[index!].challangeRoute.removeAtIndex(indexPath.row)
            FieldCollection.shareInstance.updateToDefault()
            self.difficultyTableView.reloadData()
        }
    }
}

extension CheckFieldVC: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertController(title: "Choose training mode", message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Default", style: .Default, handler:{ _ in
            self.performSegueWithIdentifier("letsPlay", sender: "Default")
        }))
        alert.addAction(UIAlertAction(title: "Escalation", style: .Default, handler:{ _ in
            self.performSegueWithIdentifier("letsPlay", sender: "Escalation")
        }))

        alert.addAction(UIAlertAction(title: "Random", style: .Default, handler:{ _ in
            self.performSegueWithIdentifier("letsPlay", sender: "Random")
        }))
        alert.addAction(UIAlertAction(title: "Random-EX", style: .Default, handler:{ _ in
            let nameAlert = UIAlertController(title: "Give A Number", message: "", preferredStyle: .Alert)
            nameAlert.addTextFieldWithConfigurationHandler(self.configurationTextField)
            nameAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
            nameAlert.addAction(UIAlertAction(title: "Done", style: .Default, handler:{ (UIAlertAction) in
                self.targetNum = Int(self.tField.text!)
                self.performSegueWithIdentifier("letsPlay", sender: "Random-EX")
            }))
            self.presentViewController(nameAlert, animated: true, completion: {
            })
        }))
        self.presentViewController(alert, animated: true, completion: {
        })
    }
    func configurationTextField(textField: UITextField!)
    {        
        textField.placeholder = "Enter a number"
        textField.keyboardType = .NumberPad
        tField = textField
    }

}


