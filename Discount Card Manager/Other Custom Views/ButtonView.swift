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
    
    func flashAnimation(duration: Double = 0.05, fromValue: Double = 1, toValue: Double = 0.7, autoreverses: Bool = true,  repeatCount: Float = 1){
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = duration
        flash.fromValue = fromValue
        flash.toValue = toValue
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = autoreverses
        flash.repeatCount = repeatCount
        
        layer.add(flash, forKey: nil)
    }
}

