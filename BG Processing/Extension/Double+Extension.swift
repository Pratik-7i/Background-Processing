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
}
