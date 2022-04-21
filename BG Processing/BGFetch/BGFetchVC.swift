//
//  BGFetchVC.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 03/04/2022.
//

import UIKit

class BGFetchVC: UIViewController
{
    @IBOutlet weak var lastUpdatedLabel : UILabel!
    @IBOutlet weak var ratesTableView   : UITableView!
    @IBOutlet weak var noDataView       : UIView!

    var dicRates: NSDictionary?
    var arrCurrency: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupControls()
        self.fetchData()
    }
    
    func setupControls() {
        self.title = "Currency Rates against 1 USD"
    }
    
    func fetchData()
    {
        if let dicRates = userDefaults.object(forKey: Key.currencyRates) as? NSDictionary, let arrCurrency = dicRates.allKeys as? [String] {
            self.dicRates = dicRates
            self.arrCurrency = arrCurrency
        }
        
        if let lastUpdatedDate = userDefaults.object(forKey: Key.lastUpdatedDateRates) as? Date {
            self.lastUpdatedLabel.text = lastUpdatedDate.timeAgo()
        }
        
        self.ratesTableView.reloadData()
        self.noDataView.isHidden = !(self.arrCurrency.count == 0)
    }
}

extension BGFetchVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCurrency.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyRateCell = tableView.dequeueReusableCell(withIdentifier: "CurrencyRateCell", for: indexPath) as! CurrencyRateCell
        if let dicRates = self.dicRates {
            cell.load(currency: self.arrCurrency[indexPath.row], datasource: dicRates)
        }
        return cell
    }
}
