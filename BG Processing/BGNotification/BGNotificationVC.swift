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
    @IBOutlet weak var drinksTableView  : UITableView!
    @IBOutlet weak var noDataView       : UIView!
    
    var arrDrinks: [DrinkModel] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupControls()
        self.printLastBackgroundNotificationInfo()
        self.fetchData()
    }
    
    func setupControls() {
        self.title = "Drinks Menu"
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
        if let lastUpdatedDate = userDefaults.object(forKey: Key.lastUpdatedDateBgNotification) as? Date {
            self.lastUpdatedLabel.text = lastUpdatedDate.timeAgo()
        }
        
        if let data = userDefaults.data(forKey: Key.drinks) {
            do {
                if let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [NSDictionary] {
                    self.arrDrinks = array.map({DrinkModel.init($0)})
                }
            } catch let error as NSError {
                print("Failed to retrive drinks: \(error.localizedDescription)")
            }
        }
        self.drinksTableView.reloadData()
        self.noDataView.isHidden = !(self.arrDrinks.count == 0)
    }
}

extension BGNotificationVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDrinks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DrinkListCell = tableView.dequeueReusableCell(withIdentifier: "DrinkListCell", for: indexPath) as! DrinkListCell
        let drink = self.arrDrinks[indexPath.row]
        cell.load(drink)
        return cell
    }
}
