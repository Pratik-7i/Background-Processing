//
//  BGFetchManager.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 03/04/2022.
//

import Foundation
import BackgroundTasks

private let backgroundTaskIdentifierBgFetch = "com.pratik.backgrounds.BGFetch"

class BGFetchManager
{
    static let shared = BGFetchManager()
    private init() {}
}

extension BGFetchManager
{
    func testAPI()
    {
        let request = performRequest { success in
            
        }
    }
    
    // Register your identifier with the task.
    
    func registerAppRefreshTask()
    {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifierBgFetch, using: nil) { task in
             self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }

    func handleAppRefresh(task: BGAppRefreshTask)
    {
        // Schedule a new refresh task.
        self.scheduleAppRefresh()
        
        Helper.showNotification(title: "Handle App Refresh", message: "Identifier: " + task.identifier)

        // Create a request that performs the main part of the background task.
        let request = performRequest { success in
            // Inform the system that the background task is complete when the request completes.
            if success {
                task.setTaskCompleted(success: true)
            } else {
                task.setTaskCompleted(success: false)
            }
        }
        
        // Provide the background task with an expiration handler that cancels the request.
        // NOTE: There is a limit to how long your app has to perform its background work, and your work may need to be interrupted if system conditions change. Assign a handler to this property to cancel any ongoing tasks, perform any needed cleanup, and then call setTaskCompletedWithSuccess: to signal completion to the system and allow your app to be suspended.
        task.expirationHandler = {
            request.cancel()
            task.setTaskCompleted(success: false)
        }
    }
    
    func scheduleAppRefresh()
    {
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifierBgFetch)
        
        // Fetch no earlier than 10 seconds from now.
        // request.earliestBeginDate = Date(timeIntervalSinceNow: 10)
        
        var message = ""
        do {
            try BGTaskScheduler.shared.submit(request)
            logger.log("Task request submitted to scheduler.")
            message = "App Refresh scheduled" // Keep break point here & execute following line in Terminal.
            // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.pratik.backgrounds.BGFetch"]
        }
        catch BGTaskScheduler.Error.notPermitted {
            message = "App Refresh - Not Permitted"
        }
        catch BGTaskScheduler.Error.tooManyPendingTaskRequests {
            message = "App Refresh - Too many pending task requests"
        }
        catch BGTaskScheduler.Error.unavailable {
            message = "App Refresh - Unavailable"
        }
        catch {
            message = "Could not schedule App Refresh: " + error.localizedDescription
        }

        Helper.showNotification(title: "Schedule App Refresh", message: message)
    }
}

private extension BGFetchManager
{
    func performRequest(completion: @escaping (Bool) -> Void) -> URLSessionTask
    {
        logger.debug("Starting background network request.")

        let url = URL(string: API.getWeatherForecast)!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            logger.debug("Finished background network request.")
            
            if let error = error {
                logger.error("Request Error: \(error.localizedDescription, privacy: .public)")
                completion(false)
                return
            }
            guard response != nil else {
                logger.error("No response found from the server.")
                completion(false)
                return
            }
            guard let data = data else {
                logger.error("No data found from the server.")
                completion(false)
                return
            }
            // Store the data and mark as success
            self.storeData(data)
            completion(true)
        }
        
        task.resume()
        return task
    }
    
    func storeData(_ data: Data)
    {
        print("-----------------------------------------------------------------------------")
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { return }
            print(json)
            
            //
            let weatherModel = WeatherModel.init(json)
            if let currentWeather = weatherModel.currentWeather {
                print("Summary: \(currentWeather.condition)")
            }
            print("Count:\(weatherModel.weatherForecasts.count)")
            
            //
            
            guard let dicRates = json["rates"] as? NSDictionary else { return }
            userDefaults.set(dicRates, forKey: Key.currencyRates)
            userDefaults.set(Date(), forKey: Key.lastUpdatedDateRates)
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        print("-----------------------------------------------------------------------------")
    }
}
