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
        
        CardManager.loadAllDataTo(&listOfCards)
        updateUI()
    }

    private func updateUI(){
        // show data from listOfCards
        tableViewOutlet.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    @IBAction func filterCards(_ sender: ButtonStyle) {
        if let color = sender.titleLabel?.text{
            switch color{
            case "All": CardManager.loadAllDataTo(&listOfCards)
            default: listOfCards = CardManager.fetchCardsBy(color: color)
            }
            
            updateUI()
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


extension MainVC{
    
    // MARK: - TableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = listOfCards?.count{
            return count == 0 ? 1 : count
        }
        //Features.showAlert(on: self, message: "Cannot load data!")
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 60
 
        if let cards = listOfCards, !cards.isEmpty {
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
        }
        return tableView.dequeueReusableCell(withIdentifier: "Empty Card", for: indexPath)
    }
}
