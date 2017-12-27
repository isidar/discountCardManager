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
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        listOfCards = CardManager.fetchAllData()
        updateUI()
    }

    private func updateUI(){
        tableView.setEditing(false, animated: true)
        updateButtonsToMatchTableState()
        
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    @IBAction func filterCards(_ sender: ButtonStyle) {
        if let color = sender.titleLabel?.text {
            listOfCards = color == "All" ?
                CardManager.fetchAllData() :
                CardManager.fetchCardsBy(color: color)
            
            updateUI()
        }
    }
    
    @IBAction func clickEdit(_ sender: UIBarButtonItem) {
        if listOfCards?.isEmpty == false {
            tableView.setEditing(true, animated: true)
            updateButtonsToMatchTableState()
        }
    }
    @IBAction func clickCancel(_ sender: UIBarButtonItem) {
        tableView.setEditing(false, animated: true)
        updateButtonsToMatchTableState()
    }
    @IBAction func clickDelete(_ sender: UIBarButtonItem) {
        let selectedRows = tableView.indexPathsForSelectedRows
        performDeletion(selectedRows: selectedRows)
    }
    
    func updateButtonsToMatchTableState() {
        if tableView.isEditing {
            navigationItem.leftBarButtonItem = cancelButton
            deleteButton.title = "Delete All"
            navigationItem.rightBarButtonItem = deleteButton
        } else {
            navigationItem.leftBarButtonItem = editButton
            navigationItem.rightBarButtonItem = addButton
        }
    }
    
    func performDeletion(selectedRows: [IndexPath]?) {
        var message = "Are you really want to delete "
        message += (selectedRows == nil) ?
            ("all cards?") :
            (String(selectedRows!.count) + "card(s)?")
        
        let actionSheet = UIAlertController(
            title: "Confirm deletion",
            message: message,
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(title: "OK", style: .destructive, handler: {(action: UIAlertAction) in
            if let selectedRows = selectedRows {
                for selectedRow in selectedRows {
                    let cardName = self.listOfCards![selectedRow.row].cardName!
                    try? CardManager.delete(keyField: cardName)
                }
                
                self.listOfCards = CardManager.fetchAllData()
                
                if let listOfCards = self.listOfCards {
                    if listOfCards.isEmpty {
                        self.updateUI()
                    } else {
                        self.tableView.deleteRows(at: selectedRows, with: .automatic)
                    }
                }
                
                self.deleteButton.title = "Delete All"
            } else {
                try? CardManager.deleteAll()
                self.listOfCards = CardManager.fetchAllData()
                self.updateUI()
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "New Card":
                if let vc = segue.destination as? EditTableVC {
                    vc.navigationItem.title = "New Card"
                }
            case "Edit":
                if let vc = segue.destination as? EditTableVC {
                    if let cell = sender as? MainTableViewCell {
                        if let cardName = cell.cardNameLabel.text {
                            vc.navigationItem.title = cardName
                        }
                    }
                }
            case "Show Info":
                if let vc = segue.destination as? ShowInfoVC {
                    if let cell = sender as? MainTableViewCell {
                        if let cardName = cell.cardNameLabel.text {
                            vc.navigationItem.title = cardName
                        }
                    }
                }

            default: break
            }
        }
    }

}


extension MainVC {
    // MARK: - SearchBar Delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listOfCards = searchText.isEmpty ?
            CardManager.fetchAllData() :
            CardManager.fetchCardsContaining(name: searchText, tags: searchText)
        
        updateUI()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    // MARK: - TableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = listOfCards?.count {
            return count == 0 ? 1 : count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 60
 
        if let cards = listOfCards, !cards.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Card", for: indexPath)
            
            // Load the cell with data from DB
            let card = cards[indexPath.row]
            
            if let cardCell = cell as? MainTableViewCell {
                cardCell.cardNameLabel.text = card.cardName
                
                if let image = CardManager.loadImageFromPath(card.logo ?? card.frontImage){
                    cardCell.logoImageView.contentMode = .scaleToFill
                    cardCell.logoImageView.image = image
                } else {
                    cardCell.logoImageView.contentMode = .scaleAspectFit
                    cardCell.logoImageView.image = cardCell.logoImageView.defaultImage
                }
            }
            
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "Empty Card", for: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let cell = tableView.cellForRow(at: indexPath) as? MainTableViewCell, cell.cardNameLabel.text != nil {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let cell = tableView.cellForRow(at: indexPath) as? MainTableViewCell {
            if let cardName = cell.cardNameLabel.text {
                let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
                    self.performSegue(withIdentifier: "Edit", sender: cell)
                }
                editAction.backgroundColor = .blue
                
                let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
                    do {
                        try CardManager.delete(keyField: cardName)
                        self.listOfCards = CardManager.fetchAllData()
                        
                        if let listOfCards = self.listOfCards {
                            if listOfCards.isEmpty {
                                self.updateUI()
                            } else {
                                tableView.deleteRows(at: [indexPath], with: .automatic)
                            }
                        }
                    } catch {
                        Feature.showAlert(on: self, message: "Cannot delete this card!")
                    }
                }
                deleteAction.backgroundColor = .red
                
                return [deleteAction, editAction]
            }
        }
        return nil
    }
    
    // MARK: - TableView Delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            if tableView.cellForRow(at: indexPath)?.reuseIdentifier != "Empty Card" {
                performSegue(withIdentifier: "Show Info", sender: tableView.cellForRow(at: indexPath))
            }
        } else {
            if let selectedRows = tableView.indexPathsForSelectedRows {
                deleteButton.title = "Delete(\(selectedRows.count))"
            }
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            deleteButton.title = "Delete(\(selectedRows.count))"
        } else {
            deleteButton.title = "Delete All"
        }
    }
    
}
