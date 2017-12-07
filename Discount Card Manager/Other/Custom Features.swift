//
//  File.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/8/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import Foundation
import UIKit

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
}

