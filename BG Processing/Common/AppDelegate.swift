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
        // Check background refresh status
        Helper.checkBackgroundRefreshStatus()
        
        // Ask user for notifications permission
        Helper.registerNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        /* (POC Task 1 & 2) For a task, provide the BGTaskScheduler object with a
           launch handler – a small block of code that runs the
           task – and a unique identifier. Register all of the tasks
           before the end of the app launch */
        BGFetchManager.shared.registerAppRefreshTask()
        //BGProcessingManager.shared.registerBackgroundProcessingTask()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        logger.info("App did enter background")
        BGTaskScheduler.shared.cancelAllTaskRequests()
        
        BGFetchManager.shared.scheduleAppRefresh()
        //BGProcessingManager.shared.scheduleBackgroundProcessing()
    }
    
    // MARK: - Background Download Transfer

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void)
    {
        DownloadManager.shared.backgroundTransferCompletionHandler = completionHandler
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
    }
}
