//
//  BGNotificationManager.swift
//  BG Processing
//
//  Created by Pratik on 17/05/22.
//

import Foundation
import UIKit

class BGNotificationManager
{
    static let shared = BGNotificationManager()
    private init() {}
}

extension BGNotificationManager
{
    func processBackgroundNotification(userInfo: [AnyHashable : Any],
                                       completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        // Store value to check whether we got background notification or not and when.
        userDefaults.set(Date(), forKey: Key.lastArrivedDateBgNotification)
        userDefaults.set(userInfo, forKey: Key.lastBgNotificationUserInfo)
        
        // Fetch the data from server
        guard let url = URL(string: API.getTodaysMenu) else {
            completionHandler(.failed)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching menu from server! \(error.localizedDescription)")
                completionHandler(.failed)
                return
            }
            guard response != nil else {
                print("No response found fetching menu from the server")
                completionHandler(.noData)
                return
            }
            guard let data = data else {
                print("No data found fetching menu from the server")
                completionHandler(.noData)
                return
            }

            self.updateMenu(withData: data)
            // Inform the system after the background operation is completed.
            completionHandler(.newData)
        }

        task.resume()
    }
    
    func updateMenu(withData data: Data)
    {
        print("-----------------------------------------------------------------------------")
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { return }
            guard let arrDrinks = json["drinks"] as? [NSDictionary] else { return }
            do {
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: arrDrinks, requiringSecureCoding: false)
                userDefaults.set(encodedData, forKey: Key.drinks)
                userDefaults.set(Date(), forKey: Key.lastUpdatedDateBgNotification)
                userDefaults.synchronize()
            } catch let error as NSError {
                print("Failed to store: \(error.localizedDescription)")
            }
        } catch let error as NSError {
            print("Failed to parse: \(error.localizedDescription)")
        }
        print("-----------------------------------------------------------------------------")
    }
}

