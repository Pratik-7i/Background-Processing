//
//  Double+Extension.swift
//  AQI
//
//  Created by Pratik on 14/12/21.
//

import Foundation

extension Double
{
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func maxFraction(_ digits: Int) -> String
    {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = digits
        // Avoid not getting a zero on numbers lower than 1
        // Eg: .5, .67, etc...
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSNumber) ?? "n/a"
    }
}
