//
//  BGNotificationVC.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 03/04/2022.
//

import UIKit

class BGNotificationVC: UIViewController
{
    @IBOutlet weak var lastUpdatedLabel : UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupControls()
        self.printLastBackgroundNotificationInfo()
        self.fetchData()
    }
    
    func setupControls() {
        self.title = "Currency Rates against 1 USD"
    }
    
    func printLastBackgroundNotificationInfo()
    {
        if let lastNotificationDate = userDefaults.object(forKey: Key.lastArrivedDateBgNotification) as? Date {
            print("Last background notification on: \(lastNotificationDate.readable(format: "hh:mm"))")
        }
        if let userInfo = userDefaults.object(forKey: Key.lastBgNotificationUserInfo) as? Dictionary {
            print("User info: \(userInfo)")
        }
        if let lastUpdatedDate = userDefaults.object(forKey: Key.lastUpdatedDateBgNotification) as? Date {
            print("Last data updated by background notification on: \(lastUpdatedDate.readable(format: "hh:mm"))")
        }
    }
    
    func fetchData()
    {
        if let data = UserDefaults.standard.object(forKey: Key.drinks) as? Data {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [NSDictionary] {
                print("\(array.description)")
                print("Count: \(array.count)")
            }
        }
        if let lastUpdatedDate = userDefaults.object(forKey: Key.lastUpdatedDateBgNotification) as? Date {
            self.lastUpdatedLabel.text = lastUpdatedDate.timeAgo()
        }
    }
}
