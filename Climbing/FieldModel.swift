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
    
//    required convenience init(coder aDecoder: NSCoder) {
//        let fieldName = aDecoder.decodeObjectForKey("fieldName") as! String?
//        let challangeRoute = aDecoder.decodeObjectForKey("challangeRoute") as! [Route]
//        self.init(fieldName: fieldName, challangeRoute: challangeRoute)
//        
//    }
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(fieldName, forKey: "fieldName")
//        aCoder.encodeObject(challangeRoute, forKey: "challangeRoute")
//    }

}


class Route: NSObject {
    var difficulty: String?
    var center: [CGPoint]?
    var rankList: [RankList] = []
    
    init (difficulty: String? ,center: [CGPoint]?, rankList:[RankList]) {
        self.difficulty = difficulty
        self.center = center
        self.rankList = rankList
    }
    
//    required convenience init(coder aDecoder: NSCoder) {
//        let difficulty = aDecoder.decodeObjectForKey("difficulty") as! String?
//        let center = aDecoder.decodeObjectForKey("center") as! [CGPoint]?
//        let rankList = aDecoder.decodeObjectForKey("rankList") as! [RankList]
//        self.init(difficulty: difficulty, center: center, rankList:rankList)
//        
//    }
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(difficulty, forKey: "difficulty")
//        aCoder.encodeObject(center, forKey: "center")
//    }
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
    
//    required convenience init(coder aDecoder: NSCoder) {
//        let fieldName = aDecoder.decodeObjectForKey("fieldName") as! String?
//        let challangeRoute = aDecoder.decodeObjectForKey("challangeRoute") as! [Route]
//        self.init(fieldName: fieldName, challangeRoute: challangeRoute)
//        
//    }
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(fieldName, forKey: "fieldName")
//        aCoder.encodeObject(challangeRoute, forKey: "challangeRoute")
//    }
    
}