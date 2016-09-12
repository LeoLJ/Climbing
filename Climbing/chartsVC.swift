//
//  chartsVC.swift
//  Climbing
//
//  Created by Leo on 8/29/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class chartsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chartsTableView: UITableView!
    var fieldIndex: Int?
    var routeIndex: Int?
    var mode: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.chartsTableView.dataSource = self
        self.chartsTableView.allowsSelection = false
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        sortArray()
        self.chartsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sortArray() {
        FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].rankList.sortInPlace({ $0.time! < $1.time })
        //.compare($1.time!) == .OrderedAscending })
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            if mode == "Charts" {
                
            }else{
                if let navigationController = self.navigationController {
                    var viewControllers = navigationController.viewControllers
                    let viewControllersCount = viewControllers.count
                    if (viewControllersCount > 2) {
                        viewControllers.removeAtIndex(viewControllersCount - 2)
                        navigationController.setViewControllers(viewControllers, animated:false)
                    }
                }
            }
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chartsCell",forIndexPath: indexPath) as! MyCustomCell
        cell.leftLabel.text = FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].rankList[indexPath.row].name
        cell.midLabel.text = FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].rankList[indexPath.row].time
        cell.rightLabel.text = FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].rankList[indexPath.row].mode
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].rankList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let ref = FIRDatabase.database().reference()
            let childRef = ref.child("Trainer").child("Charts").child(FieldCollection.shareInstance.currentField[fieldIndex!].fieldName!).child(FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].difficulty!).child(FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].rankList[indexPath.row].listId!)
            childRef.removeValue()
            FieldCollection.shareInstance.currentField[fieldIndex!].challangeRoute[routeIndex!].rankList.removeAtIndex(indexPath.row)
            //FieldCollection.shareInstance.updateToDefault()
            self.chartsTableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class MyCustomCell: UITableViewCell {
   
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!    
    @IBOutlet weak var rightLabel: UILabel!
}
