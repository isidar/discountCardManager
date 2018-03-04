//
//  ExtensionEditTableViewController.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 3/4/18.
//  Copyright © 2018 Nazarii Melnyk. All rights reserved.
//

import UIKit

extension EditTableViewController {
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
        
        if let buttonID = lastTappedButtonID {
            switch buttonID {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tagsTextView.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    
    // MARK: - TextView Delegate methods
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
