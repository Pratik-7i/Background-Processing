//
//  DownloadManager.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 04/07/2022.
//

import UIKit
import UserNotifications

public typealias DownloadCompletionBlock     = (_ error : Error?) -> Void
public typealias DownloadProgressBlock       = (_ progress : CGFloat) -> Void
public typealias BGTransferCompletionHandler = () -> ()

class DownloadManager: NSObject
{
    var session: URLSession?
    var backgroundTransferCompletionHandler: BGTransferCompletionHandler? = nil
    
    var ongoingDownloads: [String : DownloadObject] = [:]
    public static let shared = DownloadManager()

    private override init()
    {
        super.init()
        
        let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "com.pratik.backgroundDownloads")
        
        /* This makes sure you get an event on your app session launch
            (in AppDelegate). Your app might be killed by system even if
            your upload/download is going on. */
        backgroundConfiguration.sessionSendsLaunchEvents = true
        
        /* This controles whether you are allowed to continue your
            upload/download over cellular access. */
        backgroundConfiguration.allowsCellularAccess = true
        
        /* This tells the system to wait for connectivity and then
            resume uploading/downloading. If the network goes away,
            it will restart from 0. */
        backgroundConfiguration.waitsForConnectivity = true
        
        self.session = URLSession(configuration: backgroundConfiguration,
                                  delegate: self,
                                  delegateQueue: nil)
    }
    
    // MARK: - Download file
    
    public func downloadFile(_ download: DownloadObject)
    {
        if let _ = self.ongoingDownloads[download.fileURL] {
            print("Already in progress...")
            download.isDownloading = true
            return
        }
        
        guard let session = self.session else { return }
        let downloadTask = session.downloadTask(with: URL.init(string: download.fileURL)!)
        self.ongoingDownloads[download.fileURL] = download
        downloadTask.resume()
        download.isDownloading = true
    }
    
    public func isDownloadInProgress(forUniqueKey key:String?) -> (isInProcess: Bool, downloadObject: DownloadObject?)
    {
        guard let key = key else { return (false, nil) }
        for (uniqueKey, download) in self.ongoingDownloads {
            if key == uniqueKey {
                return (true, download)
            }
        }
        return (false, nil)
    }
    
    public func isDownloadInProgress(forKey key:String?) -> Bool {
        let downloadStatus = self.isDownloadInProgress(forUniqueKey: key)
        return downloadStatus.isInProcess
    }
    
    public func assignBlocksForOngoingDownload(withUniqueKey key:String?,
                                              setProgress progressBlock:DownloadProgressBlock?,
                                              setCompletion completionBlock:@escaping DownloadCompletionBlock)
    {
        let downloadStatus = self.isDownloadInProgress(forUniqueKey: key)
        let presence = downloadStatus.isInProcess
        if presence {
            if let download = downloadStatus.downloadObject {
                download.progressBlock = progressBlock
                download.completionBlock = completionBlock
            }
        }
    }
    
    // MARK: - File utility
    
    private func moveFile(fromUrl url:URL,
                          toDirectory directory:String?,
                          withName name:String) -> (success: Bool, error: Error?, url: URL?)
    {
        var newUrl:URL
        if let directory = directory {
            let directoryCreationResult = self.createDirectoryIfNotExists(withName: directory)
            guard directoryCreationResult.success == true else {
                return (false, directoryCreationResult.error, nil)
            }
            newUrl = Helper.cacheDirectoryPath().appendingPathComponent(directory).appendingPathComponent(name)
        } else {
            newUrl = Helper.cacheDirectoryPath().appendingPathComponent(name)
        }
        do {
            try FileManager.default.moveItem(at: url, to: newUrl)
            return (true, nil, newUrl)
        } catch {
            return (false, error, nil)
        }
    }
    
    private func createDirectoryIfNotExists(withName name:String) -> (success: Bool, error: Error?)
    {
        let directoryUrl = Helper.cacheDirectoryPath().appendingPathComponent(name)
        if FileManager.default.fileExists(atPath: directoryUrl.path) {
            return (true, nil)
        }
        do {
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
            return (true, nil)
        } catch  {
            return (false, error)
        }
    }
    
    // MARK: - Local notification

    func presentNotification()
    {
        let content = UNMutableNotificationContent()
        content.title = "Downloads have been completed!"
        content.body = "Click here to open"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "male_voice.aiff"))
        
        let request = UNNotificationRequest(identifier: "AllDownloadCompletedNotification", content: content, trigger: nil)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("Error while showing local notification: \(error?.localizedDescription ?? "Unknown")")
            }
        })
    }
}

extension DownloadManager : URLSessionDelegate, URLSessionDownloadDelegate 
{
    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didFinishDownloadingTo location: URL)
    {
        let key = (downloadTask.originalRequest?.url?.absoluteString)!
        guard let download = self.ongoingDownloads[key], let response = downloadTask.response else { return }
        download.isDownloading = false

        let statusCode = (response as! HTTPURLResponse).statusCode
        guard statusCode < 400 else {
            let error = NSError(domain:"HttpError", code:statusCode, userInfo:[NSLocalizedDescriptionKey:HTTPURLResponse.localizedString(forStatusCode:statusCode)])
            OperationQueue.main.addOperation({
                print("File download failed: \(download.fileName ?? "") | Error: \(error.localizedDescription)")
                guard let completionBlock = download.completionBlock else { return }
                completionBlock(error)
            })
            return
        }
        
        let fileName = download.fileName ?? downloadTask.response?.suggestedFilename ?? (downloadTask.originalRequest?.url?.lastPathComponent)!
        let directoryName = download.directoryName
        let fileMovingResult = self.moveFile(fromUrl: location, toDirectory: directoryName, withName: fileName)
        
        OperationQueue.main.addOperation({
            guard let completionBlock = download.completionBlock else { return }
            if fileMovingResult.success {
                print("File downloaded: \(fileName)")
                download.isDownloaded = true
                download.progress = 0
                completionBlock(nil)
            } else {
                print("File download failed: \(download.fileName ?? "") | Error: \(String(describing: fileMovingResult.error?.localizedDescription))")
                completionBlock(fileMovingResult.error)
            }
        })
        self.ongoingDownloads.removeValue(forKey:key)
    }
    
    public func urlSession(_ session: URLSession,
                             downloadTask: URLSessionDownloadTask,
                             didWriteData bytesWritten: Int64,
                             totalBytesWritten: Int64,
                             totalBytesExpectedToWrite: Int64) 
    {
        guard let download = self.ongoingDownloads[(downloadTask.originalRequest?.url?.absoluteString)!],
              let progressBlock = download.progressBlock else { return }
        
        let progress: CGFloat = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        print("Progress: \(Float(progress))")
        OperationQueue.main.addOperation({
            download.progress = progress
            progressBlock(progress)
        })
    }
    
    public func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           didCompleteWithError error: Error?)
    {
        if let error = error {
            let downloadTask = task as! URLSessionDownloadTask
            let key = (downloadTask.originalRequest?.url?.absoluteString)!
            if let download = self.ongoingDownloads[key] {
                download.isDownloading = false
                OperationQueue.main.addOperation({
                    print("File download failed: \(download.fileName ?? "") | Error: \(error.localizedDescription)")
                    guard let completionBlock = download.completionBlock else { return }
                    completionBlock(error)
                })
            }
            self.ongoingDownloads.removeValue(forKey:key)
        }
    }
    
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) 
    {
        session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            
            // Check if all download tasks have been finished.
            print("Download count: \(downloadTasks.count)")
            if downloadTasks.count == 0 {}
            
            // Copy locally the completion handler.
            if let completionHandler = self.backgroundTransferCompletionHandler {
                
                OperationQueue.main.addOperation({
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler()
                    // Show a local notification when all downloads are over.
                    self.presentNotification()
                })
                // Make nil the backgroundTransferCompletionHandler.
                self.backgroundTransferCompletionHandler = nil;
            }
        }
    }
}
