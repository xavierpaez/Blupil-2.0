//
//  NotificationDelegate.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 8/1/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    
    
    var window: UIWindow?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let notificationFactory = NotificationFactory()
        let calendar = Calendar.current
        // Determine the user action
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            let repository = RecordRepository(context: context)
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
            components.hour = 00
            components.minute = 00
            components.second = 00
            let  date = calendar.date(from: components)
            _ = repository.upsert(date: date!, isTaken: true)
            repository.saveChanges()
        case "Snooze":
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10,
                                                            repeats: false)
            let identifier = "Snooze"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: notificationFactory.createReminderContent(), trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
                if error != nil {
                    print("Something went wrong")
                }
            })
            print("Snooze")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
    

}
