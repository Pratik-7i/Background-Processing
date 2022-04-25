//
//  BGProcessingManager.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 13/04/2022.
//

import Foundation
import BackgroundTasks
import Photos

private let backgroundTaskIdentifierBGProcessing = "com.pratik.BG-Processing.BGProcessing"

class BGProcessingManager
{
    static let shared = BGProcessingManager()
    private init() {}
}

extension BGProcessingManager
{
    // Register your identifier with the task.

    func registerBackgroundProcessingTask()
    {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifierBGProcessing, using: nil) { task in
             self.handleBackgroundProcessing(task: task as! BGProcessingTask)
        }
    }

    func handleBackgroundProcessing(task: BGProcessingTask)
    {
        // Schedule a new refresh task.
        self.scheduleBackgroundProcessing()
        
        Helper.showNotification(title: "Handle Background Processing", message: "Identifier: " + task.identifier)

        // Create a request that performs the main part of the background processing.
        self.getPhotosCount()
        task.setTaskCompleted(success: true)

        // Provide the background task with an expiration handler that cancels the request.
        // NOTE: There is a limit to how long your app has to perform its background work, and your work may need to be interrupted if system conditions change. Assign a handler to this property to cancel any ongoing tasks, perform any needed cleanup, and then call setTaskCompletedWithSuccess: to signal completion to the system and allow your app to be suspended.
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
    }
    
    func scheduleBackgroundProcessing()
    {
        let request = BGProcessingTaskRequest(identifier: backgroundTaskIdentifierBGProcessing)
        
        /* If this property is set to YES, the system will only launch your app to
           fulfill this request when the device has a network connection. If this is
           set to NO, your app may not have network access. */
        request.requiresNetworkConnectivity = false

        /* If this property is set to YES, the system will launch your app to fulfill
           this request only while the device is connected to external power. */
        request.requiresExternalPower = false

        // Fetch no earlier than 10 seconds from now.
        //request.earliestBeginDate = Date(timeIntervalSinceNow: 10)
        
        var message = ""
        do {
            try BGTaskScheduler.shared.submit(request)
            logger.log("Task request submitted to scheduler.")
            message = "Background Processing scheduled" // Keep break point here & execute following line in Terminal.
            // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.pratik.BG-Processing.BGProcessing"]
        }
        catch BGTaskScheduler.Error.notPermitted {
            message = "Background Processing - Not Permitted"
        }
        catch BGTaskScheduler.Error.tooManyPendingTaskRequests {
            message = "Background Processing - Too many pending task requests"
        }
        catch BGTaskScheduler.Error.unavailable {
            message = "Background Processing - Unavailable"
        }
        catch {
            message = "Could not schedule Background Processing: " + error.localizedDescription
        }

        Helper.showNotification(title: "Schedule Background Processing", message: message)
    }
}

private extension BGProcessingManager
{
    func getPhotosCount()
    {
        var estimatedCount = 0
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        collections.enumerateObjects { (collection, idx, stop) in
            estimatedCount += collection.estimatedAssetCount
        }
        
        print("Estimated count: \(estimatedCount)")
        userDefaults.set(estimatedCount, forKey: Key.photoCount)
        userDefaults.set(Date(), forKey: Key.lastUpdatedDatePhotoCount)
    }
}
