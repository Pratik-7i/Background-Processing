//
//  BGFetchVC.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 03/04/2022.
//

import UIKit

class BGFetchVC: UIViewController
{
    @IBOutlet weak var lastUpdatedLabel   : UILabel!
    @IBOutlet weak var weatherInfoView    : UIView!
    @IBOutlet weak var regionLabel        : UILabel!
    @IBOutlet weak var iconImageView      : UIImageView!
    @IBOutlet weak var tempLabel          : UILabel!
    @IBOutlet weak var conditionLabel     : UILabel!
    @IBOutlet weak var windSpeedLabel     : UILabel!
    @IBOutlet weak var humidityLabel      : UILabel!
    @IBOutlet weak var rainChanceLabel    : UILabel!
    @IBOutlet weak var forecastTableView  : UITableView!
    @IBOutlet weak var noDataView         : UIView!

    var weatherModel : WeatherModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupControls()
        self.fetchData()
    }
    
    func setupControls() {
        self.title = "Weather"
        self.forecastTableView.registerCellNib(WeatherForecastCell.self)
    }
    
    func fetchData()
    {
        if let lastUpdatedDate = userDefaults.object(forKey: Key.lastUpdatedDateWeather) as? Date {
            self.lastUpdatedLabel.text = lastUpdatedDate.timeAgo()
        }
        
        if let data = userDefaults.data(forKey: Key.weatherInfo) {
            do {
                if let json = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSDictionary {
                    self.weatherModel = WeatherModel.init(json)
                    self.showCurrentWeatherInfo()
                    self.forecastTableView.reloadData()
                }
            } catch let error as NSError {
                print("Failed to retrive drinks: \(error.localizedDescription)")
            }
        }
        self.handleNoData()
    }
    
    func showCurrentWeatherInfo()
    {
        guard let weatherModel = self.weatherModel, let currentWeather = weatherModel.currentWeather else { return }
        
        self.regionLabel.text = weatherModel.region
        self.tempLabel.text = currentWeather.tempCelcius.maxFraction(2)
        self.iconImageView.setImage(currentWeather.iconURL, animated: true)
        self.conditionLabel.text = currentWeather.condition
        
        self.windSpeedLabel.text = currentWeather.windSpeedKM.maxFraction(0) + " km/h"
        self.rainChanceLabel.text = currentWeather.chancesOfRain
        self.humidityLabel.text = currentWeather.humidity
    }
    
    func handleNoData()
    {
        if self.weatherModel != nil {
            self.weatherInfoView.isHidden = false
            self.noDataView.isHidden = true
        } else {
            self.weatherInfoView.isHidden = true
            self.noDataView.isHidden = false
        }
    }
}

extension BGFetchVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weatherModel = self.weatherModel else { return 0 }
        return weatherModel.weatherForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: WeatherForecastCell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastCell", for: indexPath) as! WeatherForecastCell
        if let forecast = self.weatherModel?.weatherForecasts[indexPath.row] {
            cell.load(forecast)
        }
        return cell
    }
}
