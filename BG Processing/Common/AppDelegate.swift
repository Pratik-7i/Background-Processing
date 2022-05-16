//
//  AppDelegate.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 03/04/2022.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        UIApplication.shared.applicationIconBadgeNumber = 0

        // Check background refresh status
        Helper.checkBackgroundRefreshStatus()
        
        /*-------------------
            POC Task 1 & 2
          -------------------*/
        
        /* For a task, provide the BGTaskScheduler object with a
           launch handler – a small block of code that runs the
           task – and a unique identifier. Register all of the tasks
           before the end of the app launch */
        
        BGFetchManager.shared.registerAppRefreshTask()
        BGProcessingManager.shared.registerBackgroundProcessingTask()
        
        /*-------------------
               POC Task 3
          -------------------*/
        
        /* Configure Firebase Mesaaging for Push Notification -
            Background Push Notification in our case. */
        
        FCMHelper.shared.configureFCM()
        FCMHelper.shared.registerForRemoteNotifications()
        
        /*-------------------
               POC Task 4
          -------------------*/
        
        /* Ask user for notifications permission - a local notification
            will be presented to user once all the requested downloads
            will be completed. */
        
        Helper.registerNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        //
        if let lastUpdatedDate = userDefaults.object(forKey: Key.lastUpdatedDateBgNotification) as? Date {
            print("Last silent notification at: \(lastUpdatedDate.readable(format: "hh:mm"))")
        }
        if let value = userDefaults.object(forKey: "notificationTestKey") as? String {
            print("Notification value: \(value)")
        }
        if let userInfo = userDefaults.object(forKey: "dictUserInfo") as? Dictionary {
            print("User info: \(userInfo)")
        }
        //
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // When the app goes into the background, we need to schedule the background task
        
        logger.info("App did enter background")
        BGTaskScheduler.shared.cancelAllTaskRequests()
        
        BGFetchManager.shared.scheduleAppRefresh()
        BGProcessingManager.shared.scheduleBackgroundProcessing()
    }
    
    // MARK: - Background Notification

    /* Tells the app that a remote notification arrived that indicates there is data to be fetched. */
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        // Perform background operation
        
        if let value = userInfo["some-key"] as? String {
            print(value) // output: "some-value"
            userDefaults.set(value, forKey: "notificationTestKey")
        }
        
        userDefaults.set(userInfo, forKey: "dictUserInfo")
        userDefaults.set(Date(), forKey: Key.lastUpdatedDateBgNotification)
        
        // Inform the system after the background operation is completed.
        completionHandler(.newData)
    }

    
    // MARK: - Background Download Transfer

    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {
        DownloadManager.shared.backgroundTransferCompletionHandler = completionHandler
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
    }
}
