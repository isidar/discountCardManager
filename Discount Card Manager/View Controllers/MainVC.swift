//
//  MainVC.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/7/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // update that array to display items in a-z sections
    var listOfCards: [Card]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfCards = CardManager.fetchAllData()
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
            listOfCards = color == "All" ?
                CardManager.fetchAllData() :
                CardManager.fetchCardsBy(color: color)
            
            updateUI()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier{
            case "New Card":
                if let vc = segue.destination as? EditTableVC{
                    vc.navigationItem.title = "New Card"
                }
            case "Edit":
                if let vc = segue.destination as? EditTableVC{
                    if let cell = sender as? MainTableViewCell{
                        if let cardName = cell.cardNameLabel.text {
                            vc.navigationItem.title = cardName
                        }
                    }
                }
            case "Show Info":
                if let vc = segue.destination as? ShowInfoVC{
                    if let cell = sender as? MainTableViewCell{
                        if let cardName = cell.cardNameLabel.text{
                            vc.navigationItem.title = cardName
                        }
                    }
                }

            default: break
            }
        }
    }

}


extension MainVC{
    
    // MARK: - SearchBarDelegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listOfCards = searchText.isEmpty ?
            CardManager.fetchAllData() :
            CardManager.fetchCardsContaining(name: searchText, tags: searchText)
        
        updateUI()
    }
    
    
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
                
                if let image = CardManager.loadImageFromPath(card.logo ?? card.frontImage){
                    cardCell.logoImageView.contentMode = .scaleToFill
                    cardCell.logoImageView.image = image
                } else{
                    cardCell.logoImageView.contentMode = .scaleAspectFit
                    cardCell.logoImageView.image = cardCell.logoImageView.defaultImage
                    
                    // change all contentsOfFile: "questionMark.png" !!!!!! to
                    // ... = cardCell.logoImageView.defaultIamge
                }
                // ... = card.cardDescription
            }
            
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "Empty Card", for: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let cell = tableView.cellForRow(at: indexPath) as? MainTableViewCell, cell.cardNameLabel.text != nil{
            return true
        }
        return false
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let cell = tableView.cellForRow(at: indexPath) as? MainTableViewCell{
            if let cardName = cell.cardNameLabel.text{
                let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
                    self.performSegue(withIdentifier: "Edit", sender: cell)
                }
                editAction.backgroundColor = .blue
                
                let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
                    do{
                        try CardManager.delete(keyField: cardName)
                        self.listOfCards = CardManager.fetchAllData()
                        
                        if indexPath.row == 0{
                            self.updateUI()
                        } else{
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    } catch{
                        Feature.showAlert(on: self, message: "Cannot delete this card!")
                    }
                }
                deleteAction.backgroundColor = .red
                
                return [deleteAction, editAction]
            }
        }
        return nil
    }
}
