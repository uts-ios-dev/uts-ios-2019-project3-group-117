//
//  TaskDataService.swift
//  ToDoList
//
//

import UIKit
import CoreData

class TaskDataService{
    static let shared = TaskDataService()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var context = appDelegate.persistentContainer.viewContext
    
    func getAllWishTask()->[NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WishTask")
        
        do {
            let result = try context.fetch(request)
            
            return result as! [NSManagedObject]
        } catch {
            
            print("Failed")
            return []
        }
    }
    
    func addWishTask(name:String){
        let entity = NSEntityDescription.entity(forEntityName: "WishTask", in: context)
        let task = NSManagedObject(entity: entity!, insertInto: context)
        task.setValue(name, forKey: "name")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func addHaveTask(name:String,remark:String?,start:Date,end:Date,type:String){
        
        let tasks = getHaveTasks()
        
        guard tasks.filter({ (object) -> Bool in
            return object.name == name && object.startDate == start &&
                object.endDate == end
        }).isEmpty else{
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "HaveTask", in: context)
        let task = NSManagedObject(entity: entity!, insertInto: context)
        task.setValue(name, forKey: "name")
        task.setValue(remark, forKey: "remark")
        task.setValue(start, forKey: "startDate")
        task.setValue(end, forKey: "endDate")
        task.setValue(type, forKey: "type")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getHaveTasks()->[HaveTaskModel]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HaveTask")
        
        do {
            let result = try context.fetch(request)
            
            return (result as! [NSManagedObject]).compactMap{HaveTaskModel(object: $0)}
        } catch {
            
            print("Failed")
            return []
        }
    }
    
    func modifyTask(taskModel:HaveTaskModel,name:String,type:String,remark:String)->HaveTaskModel{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HaveTask")
        
        do {
            let result = try context.fetch(request)
            
            if let task = ((result as! [NSManagedObject]).filter { (object) -> Bool in
                return (object.value(forKey: "name") as! String) == taskModel.name && (object.value(forKey: "startDate") as! Date) == taskModel.startDate &&
                (object.value(forKey: "endDate") as! Date) == taskModel.endDate
            }).first{
                task.setValue(name, forKey: "name")
                task.setValue(type, forKey: "type")
                task.setValue(remark, forKey: "remark")
                try! context.save()
                return HaveTaskModel(object: task)
            }
        } catch {
            
        }
        return taskModel
    }
    
    func deleteHaveTask(taskModel:HaveTaskModel){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HaveTask")
        
        do {
            let result = try context.fetch(request)
            
            if let task = ((result as! [NSManagedObject]).filter { (object) -> Bool in
                return (object.value(forKey: "name") as! String) == taskModel.name && (object.value(forKey: "startDate") as! Date) == taskModel.startDate &&
                    (object.value(forKey: "endDate") as! Date) == taskModel.endDate
            }).first{
                context.delete(task)
            }
        } catch {
            
            print("Failed")
        }
    }
    
    func deleteWishTask(object:NSManagedObject){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WishTask")
        
        do {
            let result = try context.fetch(request)
            
            if let task = ((result as! [NSManagedObject]).filter { (o) -> Bool in
                return (object.value(forKey: "name") as! String) == (o.value(forKey:"name") as! String)
            }).first{
                context.delete(task)
            }
        } catch {
            
            print("Failed")
        }
    }
}
