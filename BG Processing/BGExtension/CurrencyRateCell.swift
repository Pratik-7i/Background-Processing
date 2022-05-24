//
//  CurrencyRateCell.swift
//  BG Processing
//
//  Created by Pratik on 05/04/22.
//

import UIKit

class CurrencyRateCell: UITableViewCell
{
    @IBOutlet var currencyLabel : UILabel!
    @IBOutlet var rateLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func load(currency: String, datasource: NSDictionary)
    {
        self.currencyLabel.text = currency
        guard let rate = datasource[currency] as? Double else { return }
        self.rateLabel.text = rate.roundToDecimal(2).description
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
