//
//  FieldModel.swift
//  Climbing
//
//  Created by Leo on 8/26/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class FieldModel: NSObject  {
    var fieldName: String?
    var challangeRoute:[Route] = []
    
    init (fieldName: String?, challangeRoute: [Route]) {
        self.fieldName = fieldName
        self.challangeRoute = challangeRoute
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let fieldName = aDecoder.decodeObjectForKey("fieldName") as! String?
        let challangeRoute = aDecoder.decodeObjectForKey("challangeRoute") as! [Route]
        self.init(fieldName: fieldName, challangeRoute: challangeRoute)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(fieldName, forKey: "fieldName")
        aCoder.encodeObject(challangeRoute, forKey: "challangeRoute")
    }

}


class Route: NSObject {
    var difficulty: String?
    var center: [String]?
    var rankList: [RankList] = []
    
    init (difficulty: String? ,center: [String]?, rankList:[RankList]) {
        self.difficulty = difficulty
        self.center = center
        self.rankList = rankList
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let difficulty = aDecoder.decodeObjectForKey("difficulty") as! String?
        let center = aDecoder.decodeObjectForKey("center") as! [String]?
        let rankList = aDecoder.decodeObjectForKey("rankList") as! [RankList]
        self.init(difficulty: difficulty, center: center, rankList:rankList)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(difficulty, forKey: "difficulty")
        aCoder.encodeObject(center, forKey: "center")
        aCoder.encodeObject(rankList, forKey: "rankList")
    }
}

class RankList: NSObject {
    var name: String?
    var time: String?
    var mode: String?
    
    init (name: String?, time: String?, mode: String?) {
        self.name = name
        self.time = time
        self.mode = mode
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey("name") as! String?
        let time = aDecoder.decodeObjectForKey("time") as! String?
        let mode = aDecoder.decodeObjectForKey("mode") as! String?
        self.init(name: name, time: time, mode: mode)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(time, forKey: "time")
        aCoder.encodeObject(mode, forKey: "mode")
    }
    
}