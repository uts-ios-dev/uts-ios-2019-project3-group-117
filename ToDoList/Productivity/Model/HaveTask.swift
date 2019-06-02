//
//  HaveTask.swift
//  ToDoList
//
//

import UIKit
import CoreData

class HaveTaskModel{
    var name:String!
    var remark:String?
    var startDate:Date!
    var endDate:Date!
    var type:String!
    
    init(object:NSManagedObject) {
        self.name = (object.value(forKey: "name") as! String)
        self.remark = object.value(forKey: "remark") as? String
        self.startDate = (object.value(forKey: "startDate") as! Date)
        self.endDate = (object.value(forKey: "endDate") as! Date)
        self.type = (object.value(forKey: "type") as! String)
    }
}
