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
       
        BGFetchManager.shared.testAPI()
        
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
}

extension AppDelegate
{
    // MARK: - Background Notification

    /* Tells the app that a remote notification arrived that indicates there is data to be fetched. */
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        BGNotificationManager.shared.processBackgroundNotification(userInfo: userInfo, completionHandler: completionHandler)
    }
}

extension AppDelegate
{
    // MARK: - Background Download Transfer

    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {
        DownloadManager.shared.backgroundTransferCompletionHandler = completionHandler
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
    }
}
