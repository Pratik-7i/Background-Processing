//
//  BGProcessingVC.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 21/04/22.
//

import UIKit
import Photos

class BGProcessingVC: UIViewController
{
    @IBOutlet weak var lastUpdatedLabel : UILabel!
    @IBOutlet weak var photoCountLabel  : UILabel!
    @IBOutlet weak var videoCountLabel  : UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupControls()
        self.askForPermission()
        self.fetchData()
    }
    
    func setupControls() {
        self.title = "Photos"
    }
    
    func askForPermission()
    {
        let permission = PHPhotoLibrary.authorizationStatus()
        if permission == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    print("Usr granted permission for Photo Library.")
                } else {
                    print("Photo library permission denied")
                }
            })
        }
    }
    
    func fetchData()
    {
        if let lastUpdatedDate = userDefaults.object(forKey: Key.lastUpdatedDatePhotoCount) as? Date {
            self.lastUpdatedLabel.text = lastUpdatedDate.timeAgo()
        }
        
        if let photosCount = userDefaults.object(forKey: Key.photosCount) as? Int {
            self.photoCountLabel.text = photosCount.description
        }
        
        if let videoCount = userDefaults.object(forKey: Key.videoCount) as? Int {
            self.videoCountLabel.text = videoCount.description
        }
    }
}
