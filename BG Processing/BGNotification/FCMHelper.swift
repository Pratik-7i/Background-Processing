//
//  FCMHelper.swift
//  BG Processing
//
//  Created by Pratik on 16/05/22.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseMessaging

class FCMHelper : NSObject
{
    static let shared = FCMHelper()
    
    func configureFCM()
    {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    func registerForRemoteNotifications()
    {
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: authOptions) { granted, error in
                if granted {
                    print("Push Notification access accepted.")
                    self.getNotificationSettings()
                } else {
                    print("Push Notification access denied.")
                }
            }
    }
    
    /* This is important as the user can, at any time, go into the
        Settings app and change their notification permissions. */
    
    func getNotificationSettings()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                self.subscibe(to: FirebaseTopic.backgroundNotification)
            }
        }
    }
    
    // MARK: - Firebase topic subscribe and unsubscribe
    
    func subscibe(to topic: String)
    {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {
                print("Error while subscribing to topic: \(topic) | Error: \(error.localizedDescription)")
            } else {
                print("Subscribed to topic: \(topic)")
            }
        }
    }
    
    func unsubscibe(from topic: String)
    {
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in
            if let error = error {
                print("Error while unsubscribing from topic: \(topic) | Error: \(error.localizedDescription)")
            } else {
                print("Unsubscribed from topic: \(topic)")
            }
        }
    }
}

extension FCMHelper: MessagingDelegate
{
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?)
    {
        // This callback is fired at each app startup and whenever a new token is generated.
        if let fcmToken = fcmToken {
            print("Firebase registration token: \(fcmToken)")
        }
    }
}

extension FCMHelper
{
    private func process(_ notification: UNNotification)
    {
        let userInfo = notification.request.content.userInfo
        
        if let newsTitle = userInfo["newsTitle"] as? String,
           let newsBody = userInfo["newsBody"] as? String
        {
            
        }
    }
}
