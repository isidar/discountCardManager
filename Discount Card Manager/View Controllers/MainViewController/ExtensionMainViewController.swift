//
//  ExtensionMainViewController.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 3/4/18.
//  Copyright © 2018 Nazarii Melnyk. All rights reserved.
//

import UIKit

extension MainViewController {
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
        //Features.showAlert(on: self, message: "Cannot load data!")
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
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Detail", sender: tableView.cellForRow(at: indexPath))
    }
    
}
