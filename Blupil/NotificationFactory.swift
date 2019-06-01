//
//  NotificationFactory.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 8/1/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationFactory {
    func createReminderContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Don't miss the blue pill!"
        content.body = "Have you taken your PrEP today?"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier =  "PillReminder"
        
        return content
    }
}
