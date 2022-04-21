
//
//  String+Extension.swift
//  AQI
//
//  Created by Pratik on 14/12/21.
//

import Foundation
import UIKit

extension String
{
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
}
