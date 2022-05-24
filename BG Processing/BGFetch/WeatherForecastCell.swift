//
//  WeatherForecastCell.swift
//  BG Processing
//
//  Created by Pratik on 19/05/22.
//

import UIKit

class WeatherForecastCell: UITableViewCell
{
    @IBOutlet var containerView  : UIView!
    @IBOutlet var dayLabel       : UILabel!
    @IBOutlet var conditionLabel : UILabel!
    @IBOutlet var minTempLabel   : UILabel!
    @IBOutlet var maxTempLabel   : UILabel!
    @IBOutlet var iconImageView  : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func load(_ forecast: WeatherForecast) {
        self.dayLabel.text = forecast.day.maxLength(3).uppercased()
        self.iconImageView.setImage(forecast.iconURL, animated: true)
        self.conditionLabel.text = forecast.condition
        self.minTempLabel.text = forecast.minTempCelcius.maxFraction(2) + "°"
        self.maxTempLabel.text = forecast.maxTempCelcius.maxFraction(2) + "°"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
