//
//  BGExtensionVC.swift
//  BG Processing
//
//  Created by Pratik on 24/05/22.
//

import UIKit

class BGExtensionVC: UIViewController
{
    @IBOutlet weak var lastUpdatedLabel : UILabel!
    @IBOutlet weak var ratesTableView   : UITableView!
    @IBOutlet weak var noDataView       : UIView!
    
    var dicRates: NSDictionary?
    var arrCurrency: [String] = []
    
    /*--------------------------------------------------------------*/
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var isTaskStarted: Bool = false
    /*--------------------------------------------------------------*/

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupControls()
        self.fetchData()
        self.inititateBackgroundTask()
    }
    
    func setupControls() {
        self.title = "USD Exchange Rates"
    }
    
    // MARK: - Manage Background Task
    
    func inititateBackgroundTask()
    {
        self.registerBackgroundTask()
        print("The task ID: \(self.backgroundTask)")
        
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self,
                                     selector: #selector(checkBackgroundTimeRemaining), userInfo: nil, repeats: true)
    }
    
    @objc func checkBackgroundTimeRemaining()
    {
        let backgroundTimeLeft = UIApplication.shared.backgroundTimeRemaining

        if UIApplication.shared.applicationState == .background {
            print("Background time remaining = \(backgroundTimeLeft.roundToDecimal(2)) seconds")
        }
        
        if self.isTaskStarted { return }
        
        // For Testing purpose, we are delaying our Network request.
        if backgroundTimeLeft <= 10 {
            self.isTaskStarted = true
            self.startNetworkRequest { success in
                print("Success: \(success)")
                self.endBackgroundTask()
            }
        }
    }
    
    /* Tell system that you need more time to complete whatever it is
        that you’re doing in case the app moves to the background. */
    
    func registerBackgroundTask()
    {
        self.backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "Get Exchange Rates") {
            print("--------------------------------")
            print("System is about to kill our task")
            print("--------------------------------")
            // End the task if time expires.
            self.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }
    
    func endBackgroundTask()
    {
        if self.backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
        }
        self.backgroundTask = .invalid
    }
}

extension BGExtensionVC
{
    func startNetworkRequest(completion: @escaping (Bool) -> Void)
    {
        // Fetch the data from server
        guard let url = URL(string: API.getExchangeRates) else {
            completion(false)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data from server: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard response != nil else {
                print("No response found from the server")
                completion(false)
                return
            }
            guard let data = data else {
                print("No data found from the server")
                completion(false)
                return
            }

            self.storeData(data)
            completion(true)
        }
        task.resume()
    }
    
    func storeData(_ data: Data?)
    {
        guard let data = data else { return }
        
        print("-----------------------------------------------------------------------------")
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { return }
            print(json)
            guard let dicRates = json["rates"] as? NSDictionary else { return }
            userDefaults.set(dicRates, forKey: Key.currencyRates)
            userDefaults.set(Date(), forKey: Key.lastUpdatedDateRates)
            self.fetchData()
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        print("-----------------------------------------------------------------------------")
    }
    
    func fetchData()
    {
        if let dicRates = userDefaults.object(forKey: Key.currencyRates) as? NSDictionary,
           let arrCurrency = dicRates.allKeys as? [String] {
            self.dicRates = dicRates
            self.arrCurrency = arrCurrency
        }
        
        DispatchQueue.main.async {
            self.ratesTableView.reloadData()
            self.noDataView.isHidden = !(self.arrCurrency.count == 0)
        }
        
        if let lastUpdatedDate = userDefaults.object(forKey: Key.lastUpdatedDateRates) as? Date {
            DispatchQueue.main.async {
                self.lastUpdatedLabel.text = lastUpdatedDate.timeAgo()
            }
        }
    }
}

extension BGExtensionVC: UITableViewDataSource, UITableViewDelegate
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
