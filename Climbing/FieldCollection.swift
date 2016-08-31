//
//  FieldCollection.swift
//  Climbing
//
//  Created by Leo on 8/26/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FieldCollection {
    static let shareInstance = FieldCollection()
    let userDefault = NSUserDefaults.standardUserDefaults()

    var currentField = [FieldModel]() {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("reload:", object: nil)
//            let data = NSKeyedArchiver.archivedDataWithRootObject(FieldCollection.shareInstance.currentField)
//            self.userDefault.setValue(data, forKey: "currentField")
//            self.userDefault.synchronize()
            updateToFireBase()
        }
    }
    
    func updateToFireBase(){
        let ref = FIRDatabase.database().reference()
        for fieldmodel in FieldCollection.shareInstance.currentField {
            let childRef = ref.child("Trainer").child("\(fieldmodel.fieldName!)")
            if fieldmodel.challangeRoute.count > 0 {
               for (index, route) in fieldmodel.challangeRoute.enumerate() {
                let routeRef = childRef.child("Route\(index + 1)")
                    if route.rankList.count > 0 {
                        var rankArray = [Dictionary<String, String>]()
                        for rank in route.rankList {
                            let rankDict = ["name" : rank.name!,
                                            "time" : rank.time!,
                                            "mode" : rank.mode!]
                            rankArray.append(rankDict)
                        }
                        let value = ["difficulty" : "\(route.difficulty!)",
                                     "center" : route.center!,
                                     "rankList" : rankArray]
                        routeRef.setValue(value)
                    }else{
                        for route in fieldmodel.challangeRoute {
                            if route.rankList.count > 0 {
                                let value = ["difficulty" : "\(route.difficulty!)",
                                             "center" : route.center!]
                                routeRef.setValue(value)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
