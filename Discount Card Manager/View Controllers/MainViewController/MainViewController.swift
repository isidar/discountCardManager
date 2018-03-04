//
//  MainVC.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/7/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    // MARK: - Model
    
    var listOfCards: [Card]?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    // MARK: - View Controller's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        listOfCards = CardManager.fetchAllData()
        updateUI()
    }
    
    // MARK: - Actions
    
    @IBAction func filterCards(_ sender: MyButton) {
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
    
    // MARK: - Other functions
    
    /// Updates UI of ViewController
    func updateUI() {
        tableView.setEditing(false, animated: true)
        updateButtonsToMatchTableState()
        
        tableView.reloadData()
    }
    
    /// Changes bar buttons depending on editing mode of TableView
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
    
    /// Deletes cells through editing mode
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
        
        actionSheet.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action: UIAlertAction) in
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
                if let vc = segue.destination as? EditTableViewController {
                    vc.navigationItem.title = "New Card"
                }
            case "Edit":
                if let vc = segue.destination as? EditTableViewController {
                    if let cell = sender as? MainTableViewCell {
                        if let cardName = cell.cardNameLabel.text {
                            vc.navigationItem.title = cardName
                        }
                    }
                }
            case "Show Info":
                if let vc = segue.destination as? ShowInfoViewController {
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


