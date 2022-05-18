//
//  TaskModel.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 03/04/2022.
//

import Foundation

final class DrinkModel
{
    var name      : String = ""
    var thumbURL  : String = ""
    var glassType : String = ""
    var category  : String = ""

    init(_ json: Any?)
    {
        guard let data = json as? NSDictionary else { return }
        
        self.name = data["strDrink"] as? String ?? ""
        self.thumbURL = data["strDrinkThumb"] as? String ?? ""
        self.glassType = data["strGlass"] as? String ?? ""
        self.category = data["strCategory"] as? String ?? ""
    }
}
