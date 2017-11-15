//
//  EditTableVC.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/7/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit
import Foundation

class EditTableVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
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
    @IBOutlet weak var frontImageView: MyImageView!
    @IBOutlet weak var backImageView: MyImageView!
    @IBOutlet weak var barcodeTextField: MyImageView!
    @IBOutlet weak var barcodeImageView: MyImageView!
    @IBOutlet weak var colorPickerView: UIPickerView!
    @IBOutlet weak var tagsTextView: UITextView!
    @IBOutlet weak var logoImageView: MyImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        let title = navigationItem.title!
        let name = nameTextField.text ?? ""
        let frontImage = frontImageView.image == frontImageView.defaultImage ?
            nil :
            frontImageView.image
        let backImage = backImageView.image == backImageView.defaultImage ?
            nil :
            backImageView.image
        let barcodeImage = barcodeImageView.image == barcodeImageView.defaultImage ?
            nil :
            barcodeImageView.image
        let logoImage = logoImageView.image == logoImageView.defaultImage ?
            nil :
            logoImageView.image
        let colorIndex = (colorPickerView?.selectedRow(inComponent: 0))!
        let colorName = CardManager.colorFilters[colorIndex]
        
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
                name: name, frontImage: frontImage, backImage: backImage, barcodeImage: barcodeImage, color: colorName, tags: tagsTextView.text, logo: logoImage, description: descriptionTextView.text
            )
        default:
            if name != title && CardManager.isNameAlreadyExist(name: name, in: AppDelegate.viewContext)!{
                Features.showAlert(on: self, message: "This name already exist!")
                return
            }
            do{
                try CardManager.edit(keyField: title, name: name, frontImage: frontImage, backImage: backImage, barcodeImage: barcodeImage, color: colorName, tags: tagsTextView.text, logo: logoImage, description: descriptionTextView.text)
            } catch{
                Features.showAlert(on: self, message: "Cannot edit card!")
            }
            
            break
        }
        
        removeLastView()
    }
    
    private func loadDataIfNeeded(){
        if let cardName = navigationItem.title, cardName != "New Card"{
            if let card = CardManager.fetchCard(cardName){
                nameTextField.text = card.cardName
                
                // Front Image init
                if let frontImage = CardManager.loadImageFromPath(card.frontImage){
                    frontImageView.contentMode = .scaleToFill
                    frontImageView.image = frontImage
                } else {
                    frontImageView.contentMode = .scaleAspectFit
                    frontImageView.image = frontImageView.defaultImage
                }
                
                // Back Image init
                if let backImage = CardManager.loadImageFromPath(card.backImage){
                    backImageView.contentMode = .scaleToFill
                    backImageView.image = backImage
                } else {
                    backImageView.contentMode = .scaleAspectFit
                    backImageView.image = backImageView.defaultImage
                }
                
                // Barcode Image init
                if let barcodeImage = CardManager.loadImageFromPath(card.barcode){
                    barcodeImageView.contentMode = .scaleToFill
                    barcodeImageView.image = barcodeImage
                } else {
                    barcodeImageView.contentMode = .scaleAspectFit
                    barcodeImageView.image = barcodeImageView.defaultImage
                }
                
                if let pickedColorIndex = CardManager.colorFilters.index(of: card.colorFilter!){
                    colorPickerView.selectRow(pickedColorIndex, inComponent: 0, animated: true)
                }
                
                tagsTextView.text = card.tags
                
                // Logo Image init
                if let logoImage = CardManager.loadImageFromPath(card.logo){
                    logoImageView.contentMode = .scaleToFill
                    logoImageView.image = logoImage
                } else {
                    logoImageView.contentMode = .scaleAspectFit
                    logoImageView.image = logoImageView.defaultImage
                }
                
                descriptionTextView.text = card.cardDescription
            }
        }
    }
    
    private func removeLastView(){
        if let nav = self.navigationController {
            var stack = nav.viewControllers
            
            updateAllUIOf(viewControllers: stack)
            stack.removeLast()
            nav.setViewControllers(stack, animated: true)
        }
    }
    
    private func updateAllUIOf(viewControllers: [UIViewController]){
        for vc in viewControllers{
            vc.viewDidLoad()
        }
    }
}

extension EditTableVC{
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
