//
//  BGProcessingVC.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 21/04/22.
//

import UIKit

class BGProcessingVC: UIViewController
{
    @IBOutlet weak var lastUpdatedLabel : UILabel!
    @IBOutlet weak var photoCountLabel  : UILabel!
    @IBOutlet weak var videoCountLabel  : UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupControls()
        self.fetchData()
    }
    
    func setupControls() {
        self.title = "Photos"
    }
    
    func fetchData()
    {
        if let photosCount = userDefaults.object(forKey: Key.photosCount) as? Int {
            self.photoCountLabel.text = photosCount.description
        }
        
        if let videoCount = userDefaults.object(forKey: Key.videoCount) as? Int {
            self.videoCountLabel.text = videoCount.description
        }
        
        if let lastUpdatedDate = userDefaults.object(forKey: Key.lastUpdatedDatePhotoCount) as? Date {
            self.lastUpdatedLabel.text = lastUpdatedDate.timeAgo()
        }
    }
}
