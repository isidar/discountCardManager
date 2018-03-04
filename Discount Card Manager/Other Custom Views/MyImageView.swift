//
//  MyImage.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/13/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit

@IBDesignable
class MyImageView: UIImageView {
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var defaultImage: UIImage? = nil

    
}
