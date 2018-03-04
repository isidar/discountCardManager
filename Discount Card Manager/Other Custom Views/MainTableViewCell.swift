//
//  MainTableViewCell.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/2/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    // MARK: - Outlets
    
    @IBOutlet weak var logoImageView: MyImageView!
    @IBOutlet weak var cardNameLabel: UILabel!

    // MARK: - View Cell's life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
