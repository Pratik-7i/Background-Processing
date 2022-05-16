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
                self.subscibeToTopic(name: FirebaseTopic.backgroundNotification)
            }
        }
    }
    
    // MARK: - Firebase topic subscribe and unsubscribe
    
    func subscibeToTopic(name: String)
    {
        Messaging.messaging().subscribe(toTopic: name) { error in
            if let error = error {
                print("Error while subscribing to topic: \(name) | Error: \(error.localizedDescription)")
            } else {
                print("Subscribed to topic: \(name)")
            }
        }
    }
    
    func unsubscibeFromTopic(name: String)
    {
        Messaging.messaging().unsubscribe(fromTopic: name) { error in
            if let error = error {
                print("Error while unsubscribing from topic: \(name) | Error: \(error.localizedDescription)")
            } else {
                print("Unsubscribed from topic: \(name)")
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
