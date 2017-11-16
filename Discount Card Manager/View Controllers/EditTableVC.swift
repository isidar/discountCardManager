//
//  EditTableVC.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/7/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit
import Foundation

class EditTableVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
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
    @IBOutlet weak var barcodeTextField: BarcodeTextField!
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
        
        let barcodeNumber = wasGeneratedBarcode || !wasChoosenBarcodeImage ?
            barcodeNumberInTextField : nil
        let barcodeImage = barcodeImageView.image == barcodeImageView.defaultImage ?
            nil :
            barcodeImageView.image
        
        let logoImage = logoImageView.image == logoImageView.defaultImage ?
            nil :
            logoImageView.image
        let colorIndex = (colorPickerView?.selectedRow(inComponent: 0))!
        let colorName = CardManager.colorFilters[colorIndex]
        
        if name.containsOnlySpaces {
            Feature.showAlert(on: self, message: "Fill the \"Card Name\" field!")
            return
        }
        
        switch title{
        case "New Card":
            if CardManager.isNameAlreadyExist(name: name, in: AppDelegate.viewContext)!{
                Feature.showAlert(on: self, message: "This name already exist!")
                return
            }
            CardManager.add(
                name: name, frontImage: frontImage, backImage: backImage, barcodeNumber: barcodeNumber, barcodeImage: barcodeImage, color: colorName, tags: tagsTextView.text, logo: logoImage, description: descriptionTextView.text
            )
        default:
            if name != title && CardManager.isNameAlreadyExist(name: name, in: AppDelegate.viewContext)!{
                Feature.showAlert(on: self, message: "This name already exist!")
                return
            }
            do{
                try CardManager.edit(keyField: title, name: name, frontImage: frontImage, backImage: backImage, barcodeNumber: barcodeNumber, barcodeImage: barcodeImage, color: colorName, tags: tagsTextView.text, logo: logoImage, description: descriptionTextView.text)
            } catch{
                Feature.showAlert(on: self, message: "Cannot edit card!")
            }
            
            break
        }
        
        removeLastView()
    }
    
    
    var lastTappedButtonID: String?
    
    @IBAction func chooseImage(_ sender: ButtonStyle) {
        sender.flashAnimation()
        
        if let buttonID = sender.accessibilityIdentifier{
            lastTappedButtonID = buttonID
            pickImage()
        }
    }
    
    @IBAction func clearImage(_ sender: ButtonStyle) {
        sender.flashAnimation()
        
        if let buttonID = sender.accessibilityIdentifier{
            switch buttonID{
            case "Clear Front Image":
                frontImageView.contentMode = .scaleAspectFit
                frontImageView.image = frontImageView.defaultImage
            case "Clear Back Image":
                backImageView.contentMode = .scaleAspectFit
                backImageView.image = backImageView.defaultImage
            case "Clear Barcode Image":
                barcodeImageView.contentMode = .scaleAspectFit
                barcodeImageView.image = barcodeImageView.defaultImage
                barcodeTextField.text = nil
                barcodeNumberInTextField = nil
                
                wasGeneratedBarcode = false
                wasChoosenBarcodeImage = false
            case "Clear Logo Image":
                logoImageView.contentMode = .scaleAspectFit
                logoImageView.image = logoImageView.defaultImage
            default: break
            }
        }
    }
    
    var barcodeNumberInTextField: String?
    var wasGeneratedBarcode: Bool = false
    var wasChoosenBarcodeImage: Bool = false
    
    @IBAction func generateBarcode(_ sender: ButtonStyle) {
        sender.flashAnimation()
        
        if let number = barcodeTextField.text{
            if !number.containsOnlySpaces{
                // check if all characters are numbers !!
                if let image = CardManager.generateBarcode(from: number){
                    barcodeImageView.image = image
                    
                    wasGeneratedBarcode = true
                    wasChoosenBarcodeImage = false
                    
                    barcodeNumberInTextField = number
                }
            } else{
                Feature.showAlert(on: self, message: "Enter barcode number!")
            }
        }
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
                if let number = card.barcodeNumber{
                    barcodeImageView.contentMode = .scaleToFill
                    barcodeImageView.image = CardManager.generateBarcode(from: number)
                    barcodeTextField.text = number
                    barcodeNumberInTextField = number
                } else if let barcodeImage = CardManager.loadImageFromPath(card.barcodeImage){
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
    
    private func pickImage(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else{
                Feature.showAlert(on: self, message: "Camera is not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
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
    
    // MARK: - ImagePicker Delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if let buttonID = lastTappedButtonID{
            switch buttonID{
            case "Choose Front Image":
                frontImageView.contentMode = .scaleToFill
                frontImageView.image = image
            case "Choose Back Image":
                backImageView.contentMode = .scaleToFill
                backImageView.image = image
            case "Choose Barcode Image":
                barcodeImageView.contentMode = .scaleToFill
                barcodeImageView.image = image
                
                wasGeneratedBarcode = false
                wasChoosenBarcodeImage = true
            case "Choose Logo Image":
                logoImageView.contentMode = .scaleToFill
                logoImageView.image = image
            default: break
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TextField Delegate methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - TextField Delegate methods
    
    
}
