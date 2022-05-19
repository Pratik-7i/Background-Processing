
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
    
    func maxLength(_ length: Int) -> String
    {
        var str = self
        let nsString = str as NSString
        if nsString.length > length {
            str = nsString.substring(with: NSRange(location: 0, length: length))
        }
        return str
    }
}
