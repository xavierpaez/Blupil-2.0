//
//  AppDelegate.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 2/7/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import UIKit
import CoreData
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseCore
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var launchedShortcutItem: UIApplicationShortcutItem?
    let center = UNUserNotificationCenter.current()
    let notificationDelegate = NotificationDelegate()
    
    enum ShortcutIdentifier: String {
        case First
        
        // MARK: - Initializers
        
        init?(fullType: String) {
            guard let last = fullType.components(separatedBy: ".").last else { return nil }
            
            self.init(rawValue: last)
        }
        
        // MARK: - Properties
        
        var type: String {
            return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
        }
        
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController = sb.instantiateViewController(withIdentifier: "Onboarding")
      
        
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "onboardingComplete"){
            initialViewController = sb.instantiateViewController(withIdentifier: "Mainapp")
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        //Deeplinking/
        
        UINavigationBar.appearance().barTintColor = UIColor(colorWithHexValue: 0x2BA4FF)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    
        setUpLocalNotifications()
        setUpRemoteNotifications(application)
        
        var shouldPerformAdditionalDelegateHandling = true

        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            launchedShortcutItem = shortcutItem
            
            shouldPerformAdditionalDelegateHandling = false
        }
        
        // Install initial versions of our two extra dynamic shortcuts.
        if let shortcutItems = application.shortcutItems, shortcutItems.isEmpty {
            // Construct the items.
            let shortcut = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.First.type, localizedTitle: "DailyPrEP", localizedSubtitle: "I took my pill!", icon: UIApplicationShortcutIcon(type: .task), userInfo: [
                :]
            )
            
            // Update the application providing the initial 'dynamic' shortcut items.
            application.shortcutItems = [shortcut]
        }
        
        return shouldPerformAdditionalDelegateHandling
    }
    
    
    
    func setUpLocalNotifications(){
        center.delegate = notificationDelegate
        let options: UNAuthorizationOptions = [.alert, .sound, .badge];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze",title: "Snooze", options: [])
        let category = UNNotificationCategory(identifier: "PillReminder",
                                              actions: [snoozeAction],
                                              intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    
    func setUpRemoteNotifications(_ application: UIApplication){
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
                Messaging.messaging().disconnect()
        
        
    }

    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        guard let shortcut = launchedShortcutItem else { return }
        handleShortcutItem(shortcutItem: shortcut)
        launchedShortcutItem = nil
        
//        connectToFCM()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DailyPrEP")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
        switch (shortCutType){
        case ShortcutIdentifier.First.type:
            handled = true
            break
        default:
            break
        }
        
        let alertController = UIAlertController(title: "DaylyPrEP", message: "PrEP Taken", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        window!.rootViewController?.present(alertController, animated: true, completion: nil)
        
        return handled
        
    }
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
         print("Firebase registration token: \(fcmToken)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handledShortCutItem = handleShortcutItem(shortcutItem: shortcutItem)
        
        completionHandler(handledShortCutItem)
    }
    
    // MARK: Deeplinks
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }


    // MARK: Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                
            }
        }
        return false
    }
}

let appdelegate = UIApplication.shared.delegate as! AppDelegate
let context = appdelegate.persistentContainer.viewContext



