//
//  DrinkListCell.swift
//  BG Processing
//
//  Created by Pratik on 18/05/22.
//

import UIKit

class DrinkListCell: UITableViewCell
{
    @IBOutlet var drinkImageView : UIImageView!
    @IBOutlet var drinkNameLabel : UILabel!
    @IBOutlet var glassTypeLabel : UILabel!
    @IBOutlet var categoryLabel  : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func load(_ drink: DrinkModel) {
        self.drinkNameLabel.text = drink.name
        self.drinkImageView.setImage(drink.thumbURL, animated: true)
        self.glassTypeLabel.text = drink.glassType
        self.categoryLabel.text = drink.category
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
