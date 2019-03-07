//
//  AlarmViewController.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 3/15/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import UIKit
import UserNotifications



class AlarmViewController: UIViewController {

   
    @IBOutlet weak var alarmPicker: UIDatePicker!
    let center = UNUserNotificationCenter.current()
    let userDefaults = UserDefaults.standard
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(alarmPicker.date, forKey: "reminder")
        print(alarmPicker.date)
        userDefaults.synchronize()
        setNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let date = userDefaults.object(forKey: "reminder"){
            alarmPicker.date = date as! Date
        }
        alarmPicker.setValue(UIColor.gray, forKey: "textColor")
        
    }
    
   private func setNotifications( ){
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget to swallow!"
        content.body = "Have you taken your PrEP today?"
        content.sound = UNNotificationSound.default()
        content.badge = 1
        content.categoryIdentifier =  "PillReminder"
    
        let date = alarmPicker.date
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let identifier = "DailyPrEPLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        
    }
    
 

    
}
