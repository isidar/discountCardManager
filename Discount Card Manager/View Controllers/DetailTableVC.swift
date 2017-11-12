//
//  EditTableVC.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/7/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit
import Foundation

class DetailTableVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Outlets
    
    // probably is not needed
    @IBOutlet weak var navigationBar: UINavigationItem!
    // * * * *
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var barcodeTextField: UITextField!
    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var colorPickerView: UIPickerView!
    @IBOutlet weak var tagsTextView: UITextView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        let regEx = NSRegularExpression(pattern: "^\s+$")
        let numberOfMatches = regEx.numberOfMatches(in: nameTextField.text)
        
        if numberOfMatches > 0 || nameTextField.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .Alert)
            // alert.addAction(UIAlertAction(title: "Click", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        switch navigationItem.title! {
        case "New Card":
            CardManager.add(
                name: nameTextField, frontImage: frontImageView, backImage: backImageView, barcodeImage: barcodeImageView, tags: tagsTextView, logo: logoImageView, description: descriptionTextView
            )
        default:
            //CardManager.edit(name: <#T##UITextField?#>, frontImage: <#T##UIImageView?#>, backImage: <#T##UIImageView?#>, barcodeImage: <#T##UIImageView?#>, tags: <#T##UITextView?#>, logo: <#T##UIImageView?#>, description: <#T##UITextView?#>)
            break
        }
        
        // need to close current VC
    }
    
    
    
    // MARK: - PickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CardManager.colorFilters[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CardManager.colorFilters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        CardManager.currentColor = CardManager.colorFilters[row]
    }
    
    
    // MARK: - TableView Data Source
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    /*
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     }
     */
}
