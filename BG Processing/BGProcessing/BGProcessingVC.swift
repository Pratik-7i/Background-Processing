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
        if let photoCount = userDefaults.object(forKey: Key.photoCount) as? Int {
            self.photoCountLabel.text = photoCount.description
        }
        
        if let lastUpdatedDate = userDefaults.object(forKey: Key.lastUpdatedDatePhotoCount) as? Date {
            self.lastUpdatedLabel.text = lastUpdatedDate.timeAgo()
        }
    }
}
