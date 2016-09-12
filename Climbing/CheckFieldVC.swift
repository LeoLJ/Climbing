//
//  CheckFieldVC.swift
//  Climbing
//
//  Created by Leo on 8/26/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CheckFieldVC: UIViewController {
    var index: Int?
    var tField: UITextField!
    var targetNum: Int?
    let ref = FIRDatabase.database().reference()


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
        getRouteFromFirebase()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addDifficulty(sender: AnyObject) {
        
    }
    
    func reload() {
        getRouteFromFirebase()
       // self.difficultyTableView.reloadData()
    }
    
    @IBAction func goRandomEX(sender: AnyObject) {
            let nameAlert = UIAlertController(title: "Give A Number", message: "", preferredStyle: .Alert)
            nameAlert.addTextFieldWithConfigurationHandler(self.configurationTextField)
            nameAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
            nameAlert.addAction(UIAlertAction(title: "Done", style: .Default, handler:{ (UIAlertAction) in
                self.targetNum = Int(self.tField.text!)
                self.performSegueWithIdentifier("letsPlay", sender: "Random-EX")
            }))
            self.presentViewController(nameAlert, animated: true, completion: {
            })
    }
    // Get Route data form firebase
    func getRouteFromFirebase() {
            FieldCollection.shareInstance.currentField[self.index!].challangeRoute.removeAll()
            ref.child("Trainer").child("Route").child(FieldCollection.shareInstance.currentField[index!].fieldName!).observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let routeID = childSnapshot.key
                let name = childSnapshot.value!.objectForKey("ID") as? String
                let newRoute = Route(difficulty: nil, center: nil, rankList: [], routeId: nil)
                newRoute.difficulty = name
                newRoute.routeId = routeID
                FieldCollection.shareInstance.currentField[self.index!].challangeRoute.append(newRoute)
                self.difficultyTableView.reloadData()
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    func getChartFromFirebase() {
        FieldCollection.shareInstance.currentField[self.index!].challangeRoute[(self.difficultyTableView.indexPathForSelectedRow?.row)!].rankList.removeAll()
        ref.child("Trainer").child("Charts").child(FieldCollection.shareInstance.currentField[self.index!].fieldName!).child(FieldCollection.shareInstance.currentField[self.index!].challangeRoute[(self.difficultyTableView.indexPathForSelectedRow?.row)!].difficulty!).observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                let players = RankList(name: nil, time: nil, mode: nil, listId: nil)
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let listID = childSnapshot.key
                players.name = childSnapshot.value!.objectForKey("Name") as? String
                players.mode = childSnapshot.value!.objectForKey("Mode") as? String
                players.time = (childSnapshot.value!.objectForKey("Time") as? String)!
                players.listId = listID
                FieldCollection.shareInstance.currentField[self.index!].challangeRoute[(self.difficultyTableView.indexPathForSelectedRow?.row)!].rankList.append(players)
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "creatNewRoute" {
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.topViewController as! ViewController
            vc.index = self.index
        }else if segue.identifier == "letsPlay" {
            let vc = segue.destinationViewController as! timeToPlayVC
            vc.fieldIndex = self.index
            vc.routeIndex =  self.difficultyTableView.indexPathForSelectedRow?.row
            vc.mode = sender as? String
            vc.targetNum = self.targetNum
            // Pass the selected object to the new view controller.
        }else if segue.identifier == "GoCharts" {
            let vc = segue.destinationViewController as! chartsVC
            vc.fieldIndex = self.index
            vc.mode = sender as? String
            vc.routeIndex =  self.difficultyTableView.indexPathForSelectedRow?.row
            getChartFromFirebase()
        }
        
    }
 

}

extension CheckFieldVC: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("difficultyCell",forIndexPath: indexPath)
        //if FieldCollection.shareInstance.currentField[index!].challangeRoute != nil {
        cell.textLabel?.text = "\(FieldCollection.shareInstance.currentField[index!].challangeRoute[indexPath.row].difficulty!)"
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
            let ref = FIRDatabase.database().reference()
            let routeRef = ref.child("Trainer").child("Route").child(FieldCollection.shareInstance.currentField[index!].fieldName!).child(FieldCollection.shareInstance.currentField[index!].challangeRoute[indexPath.row].routeId!)
            let pathRef = ref.child("Trainer").child("Path").child(FieldCollection.shareInstance.currentField[index!].fieldName!).child(FieldCollection.shareInstance.currentField[index!].challangeRoute[indexPath.row].difficulty!)
            pathRef.removeValue()
            routeRef.removeValue()
            FieldCollection.shareInstance.currentField[index!].challangeRoute.removeAtIndex(indexPath.row)
//            FieldCollection.shareInstance.updateToDefault()
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
        
        alert.addAction(UIAlertAction(title: "Charts", style: .Default, handler:{ _ in
            self.performSegueWithIdentifier("GoCharts", sender: "Charts")
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


