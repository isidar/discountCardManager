//
//  File.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/8/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import Foundation
import UIKit

extension String{
    /// Checks if string contains only whitespace characters (spaces, tabs, line breaks)
    var containsOnlySpaces: Bool{
        get{
            let regEx = try? NSRegularExpression(pattern: "^\\s+$")
            let numberOfMatches = regEx!.numberOfMatches(in: self, range: NSRange(location: 0, length: self.count))
            
            return numberOfMatches > 0 || self.isEmpty
        }
    }
}

extension NSSet{
    var asString: String{
        get{
            var sequence = ""
            
            for item in self{
                sequence += String(describing: item) + ", "
            }
            sequence.removeLast(2)
            
            return sequence
        }
    }
}

struct Feature{
    static func showAlert(on vc: UIViewController, title: String = "Error", message: String = "Something goes wrong"){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    enum Direction {
        case left
        case right
    }
    
    static func swapBoundsSize(of image: UIImageView){
        let temp = image.bounds.size.width
        image.bounds.size.width = image.bounds.size.height
        image.bounds.size.height = temp
    }
    static func swapFrameSize(of image: UIImageView){
        let temp = image.frame.size.width
        image.frame.size.width = image.frame.size.height
        image.frame.size.height = temp
    }
}

