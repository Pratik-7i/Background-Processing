//
//  UIImageView+Extension.swift
//  BG Processing
//
//  Created by Pratik on 18/05/22.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView
{
    public func setImage(_ url: String?, placeholder: UIImage? = nil, animated: Bool = false)
    {
        self.kf.setImage(with: URL.init(string: url ?? ""),
                         placeholder: placeholder,
                         options: animated ? [.transition(.fade(1))] : nil)
    }
}
