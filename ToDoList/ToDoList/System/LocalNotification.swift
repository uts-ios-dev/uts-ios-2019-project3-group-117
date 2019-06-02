//
//  LocalNotification.swift
//  ToDoList
//
//

import UIKit

class LocalNotification: NSObject {
    
    static let shared = LocalNotification()
    /** Create and add the local notification */
    func addNotification(name:String,start:Date) {
        // initialize the local notification.
        let localNoti = UILocalNotification()
        
        let fireDate = start.addingTimeInterval(-15*60)
        localNoti.fireDate = fireDate
        // main content of the notification.
        localNoti.alertBody = name
        // the notification sound being played.
        localNoti.soundName = UILocalNotificationDefaultSoundName
        //slide animation on the screen.
        localNoti.alertAction = "open app"
        
        // add notification to the system and will be triggered at specific time.
        UIApplication.shared.scheduleLocalNotification(localNoti)
    }
    
}
