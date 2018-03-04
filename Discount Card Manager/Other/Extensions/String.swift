//
//  String.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 12/8/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import Foundation

extension String {
    /// Checks if string contains only whitespace characters (spaces, tabs, line breaks)
    var containsOnlySpaces: Bool {
        get {
            let regEx = try? NSRegularExpression(pattern: "^\\s+$")
            let numberOfMatches = regEx!.numberOfMatches(in: self, range: NSRange(location: 0, length: self.count))
            
            return numberOfMatches > 0 || self.isEmpty
        }
    }
    
    
}
