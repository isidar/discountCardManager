//
//  MainVC.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/7/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // update that array to display items in a-z sections
    var listOfCards: [Card]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    private func updateUI(){
        // reload data from Data Core
        CardManager.loadAllDataTo(&listOfCards)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    // MARK: - TableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfCards?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cards = listOfCards{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Card", for: indexPath)
            
            // Load the cell with data from DB
            let card = cards[indexPath.row]
            
            if let cardCell = cell as? MainTableViewCell{
                cardCell.cardNameLabel.text = card.cardName
                cardCell.logoImageView.image = CardManager.loadImageFromPath(card.logo ?? card.frontImage) ??
                    UIImage(contentsOfFile: "questionMark.png")
                // ... = card.cardDescription
            }
            
            return cell
        } else{
            return tableView.dequeueReusableCell(withIdentifier: "Empty Card", for: indexPath)
        }
        
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier{
            case "New Card":
                if let vc = segue.destination as? DetailTableVC{
                    vc.navigationItem.title = "New Card"
                }
            case "Show Info":
                if let vc = segue.destination as? DetailTableVC{
                    let cell = sender as? MainTableViewCell
                    
                    vc.navigationItem.title = cell?.cardNameLabel.text
                }
            default: break
            }
        }
    }

}
