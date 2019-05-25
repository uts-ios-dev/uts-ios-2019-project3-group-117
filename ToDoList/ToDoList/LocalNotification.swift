//
//  LocalNotification.swift
//  ToDoList
//
//

import UIKit

class LocalNotification: NSObject {
    
    static let shared = LocalNotification()
    /** 添加创建并添加本地通知 */
    func addNotification(name:String,start:Date) {
        // 初始化一个通知
        let localNoti = UILocalNotification()
        
        let fireDate = start.addingTimeInterval(-15*60)
        localNoti.fireDate = fireDate
        // 通知上显示的主题内容
        localNoti.alertBody = name
        // 收到通知时播放的声音，默认消息声音
        localNoti.soundName = UILocalNotificationDefaultSoundName
        //待机界面的滑动动作提示
        localNoti.alertAction = "open app"
        
        // 添加通知到系统队列中，系统会在指定的时间触发
        UIApplication.shared.scheduleLocalNotification(localNoti)
    }
    
}
