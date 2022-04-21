//
//  UIColor+Extension.swift
//  AQI
//
//  Created by Pratik on 28/12/21.
//

import Foundation
import UIKit

public extension UIColor
{
    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha:a)
    }
}

