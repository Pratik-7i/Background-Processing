
//
//  UIView+Extension.swift
//  AQI
//
//  Created by Pratik on 14/12/21.
//

import UIKit
import Foundation

extension UIView
{
    // Shadow
    @IBInspectable
    var shadow: Bool {
         get {
              return layer.shadowOpacity > 0.0
         }
         set {
            if newValue == true {
                let layer = self.layer
                layer.masksToBounds = false
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOffset = CGSize(width: 0, height: 0)
                layer.shadowRadius = 5
                layer.shadowOpacity = 0.2
              }
         }
    }
    
    @IBInspectable
    var shadowRadious: CGFloat {
         get {
            return layer.shadowRadius
         }
         set {
            let layer = self.layer
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = newValue
            layer.shadowOpacity = 0.2
         }
    }

    // Circle
    @IBInspectable 
    var circle: Bool {
         get {
              return layer.cornerRadius == self.bounds.height*0.5
         }
         set {
              if newValue == true {
                   self.cornerRadius = self.bounds.height*0.5
              }
         }
    }

    // Corner radius
    @IBInspectable 
    var cornerRadius: CGFloat {
         get {
              return self.layer.cornerRadius
         }
         set {
              self.layer.cornerRadius = newValue
         }
    }

    // Border width
    @IBInspectable
    public var borderWidth: CGFloat {
         set {
              layer.borderWidth = newValue
         }
         get {
              return layer.borderWidth
         }
    }

    // Border color
    @IBInspectable
    public var borderColor: UIColor? {
         set {
              layer.borderColor = newValue?.cgColor
         }
         get {
              if let borderColor = layer.borderColor {
                   return UIColor(cgColor: borderColor)
              }
              return nil
         }
    }
}



