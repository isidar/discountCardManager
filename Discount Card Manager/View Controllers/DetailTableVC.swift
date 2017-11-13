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
    
    var selectedRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Outlets

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
        let title = navigationItem.title!
        let name = nameTextField.text ?? ""
        
        if name.containsOnlySpaces {
            Features.showAlert(on: self, message: "Fill the \"Card Name\" field!")
            return
        }
        
        switch title{
        case "New Card":
            if CardManager.isNameAlreadyExist(name: name, in: AppDelegate.viewContext)!{
                Features.showAlert(on: self, message: "This name already exist!")
                return
            }
            CardManager.add(
                name: nameTextField, frontImage: frontImageView, backImage: backImageView, barcodeImage: barcodeImageView, color: colorPickerView, tags: tagsTextView, logo: logoImageView, description: descriptionTextView
            )
        default:
            if name != title && CardManager.isNameAlreadyExist(name: name, in: AppDelegate.viewContext)!{
                Features.showAlert(on: self, message: "This name already exist!")
                return
            }
            do{
                try CardManager.edit(keyField: title, name: nameTextField, frontImage: frontImageView, backImage: backImageView, barcodeImage: barcodeImageView, color: colorPickerView, tags: tagsTextView, logo: logoImageView, description: descriptionTextView)
            } catch{
                Features.showAlert(on: self, message: "Cannot edit card!")
            }
            
            break
        }
        
        // remove current VC
        if let nav = self.navigationController {
            var stack = nav.viewControllers
            
            updateAllUIOf(viewControllers: stack)
            stack.removeLast()
            nav.setViewControllers(stack, animated: true)
        }
    }
    
    private func loadDataIfNeeded(){
        if let title = navigationItem.title, title != "New Card"{
            if let card = CardManager.fetchCard(title){
                let defaultImage = UIImage(contentsOfFile: "questionMark.png")
                // let defaultImage = UIImage(named: "questionMark.png")
                
                nameTextField.text = card.cardName
                frontImageView.image = CardManager.loadImageFromPath(card.frontImage) ?? defaultImage
                backImageView.image = CardManager.loadImageFromPath(card.backImage) ?? defaultImage
                barcodeImageView.image = CardManager.loadImageFromPath(card.barcode) ?? defaultImage
                
                if let pickedColorIndex = CardManager.colorFilters.index(of: card.colorFilter!){
                    colorPickerView.selectRow(pickedColorIndex, inComponent: 0, animated: true)
                }
                tagsTextView.text = card.tags
                logoImageView.image = CardManager.loadImageFromPath(card.logo) ?? defaultImage
                descriptionTextView.text = card.cardDescription
            }
        }
    }
    
    private func updateAllUIOf(viewControllers: [UIViewController]){
        for vc in viewControllers{
            vc.viewDidLoad()
        }
    }
}

extension DetailTableVC{
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
}
