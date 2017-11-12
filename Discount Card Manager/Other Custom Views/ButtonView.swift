//
//  ButtonView.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/6/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonStyle: UIButton {
    
    @IBInspectable
    var borderColor: UIColor? {
        get{
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set{
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    
    func flashAnimation(){
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.05
        flash.fromValue = 1
        flash.toValue = 0.7
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        
        layer.add(flash, forKey: nil)
    }
}

