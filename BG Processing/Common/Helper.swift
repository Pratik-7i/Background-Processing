//
//  Helper.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 03/04/2022.
//

import Foundation
import UserNotifications
import os.log
import UIKit
import AVKit

let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "BackgroundAppRefreshManager")

public typealias Dictionary = [String: Any]
let userDefaults = UserDefaults.standard
let AppDel = UIApplication.shared.delegate as! AppDelegate

class Helper
{
    static func checkBackgroundRefreshStatus()
    {
        switch UIApplication.shared.backgroundRefreshStatus
        {
        case .available:
            print("Background fetch is enabled")
        case .denied:
            print("Background fetch is explicitly disabled")
            // Redirect user to Settings page only once; Respect user's choice is important
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        case .restricted:
            // Should not redirect user to Settings since he / she cannot toggle the settings
            print("Background fetch is restricted, e.g. under parental control")
        default:
            print("Unknown")
        }
    }
    
    static func registerNotifications()
    {
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]

        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Error while requesting Notifications permission: \(error.localizedDescription)")
                return
            }
            if granted {
                print("User granted permission for Notifications.")
            } else {
                print("User denied permission for Notifications.")
            }
        }
    }
    
    static func showNotification(title: String, message: String)
    {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                logger.error("\(message, privacy: .public) error: \(error.localizedDescription, privacy: .public)")
            }
        }
    }
    
    static func cacheDirectoryPath() -> URL
    {
        let cachePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: cachePath)
    }

    static func getPath(fileName: String, directory: String? = nil) -> URL
    {
        var fileURL: URL
        if let directory = directory {
            fileURL = cacheDirectoryPath().appendingPathComponent(directory).appendingPathComponent(fileName)
        } else {
            fileURL = cacheDirectoryPath().appendingPathComponent(fileName)
        }
        return fileURL
    }

    static func fileExists(_ fileName: String, directory: String? = nil) -> Bool
    {
        let fileURL = Helper.getPath(fileName: fileName, directory: directory)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("Already downloaded: \(fileName)")
            return true
        }
        return false
    }
    
    static func removeFileFromCache(fileName: String, competion: (_ isRemoved: Bool) -> ())
    {
        let fileManager = FileManager.default
        let fileURL = Helper.cacheDirectoryPath().appendingPathComponent(VideosDirectory).appendingPathComponent(fileName)
        do {
            try fileManager.removeItem(atPath: fileURL.path)
            print("Deleted: \(fileName)")
            competion(true)
        } catch {
            print("Could not delete file: \(error)")
            competion(false)
        }
    }
    
    static func playVideo(name: String?, vc: UIViewController)
    {
        guard let videoName = name else { return }
        let videoPath = Helper.cacheDirectoryPath().appendingPathComponent(VideosDirectory).appendingPathComponent(videoName)
        let playerItem = AVPlayerItem(url: videoPath)
        let player = AVPlayer(playerItem: playerItem)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        player.play()
        vc.present(playerViewController, animated: true)
    }
    
    static func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void))
    {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbNailImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbNailImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    static func defultsBoolForKey( _ key : String) -> Bool {
       return UserDefaults.standard.bool(forKey: key)
    }

    static func saveDefultsBool(_ value: Bool, key: String) {
        let defults = UserDefaults.standard
        defults.set(value, forKey: key)
        defults.synchronize()
    }
    
    static func stringFromTimeInterval(_ interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
