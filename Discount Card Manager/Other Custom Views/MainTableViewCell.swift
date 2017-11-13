//
//  MainTableViewCell.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/2/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    
    @IBAction func showDescription(_ sender: UIButton) {
        
    }
    
}
