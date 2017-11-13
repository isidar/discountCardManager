//
//  CardManager.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/7/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit
import CoreData

class CardManager: NSObject {
    static let colorFilters = ["None", "Red", "Green", "Blue", "Yellow", "Black"]
    
    /// Adds new item in DB
    static func add(name: UITextField?, frontImage: UIImageView?, backImage: UIImageView?, barcodeImage: UIImageView?, color: UIPickerView?, tags: UITextView?, logo: UIImageView?, description: UITextView?){
        let context = AppDelegate.viewContext
        let card = Card(context: context)
        
        card.cardName = name?.text
        card.frontImage = addURLFor(frontImage?.image)
        card.backImage = addURLFor(backImage?.image)
        card.barcode = addURLFor(barcodeImage?.image)
        let colorIndex = (color?.selectedRow(inComponent: 0))!
        let colorName = colorFilters[colorIndex]
        card.colorFilter = colorName
        card.tags = tags?.text
        card.logo = addURLFor(logo?.image)
        card.cardDescription = description?.text
        
        save(context: card.managedObjectContext)
    }
    
    /// Edits particular item in DB
    static func edit(keyField: String, name: UITextField?, frontImage: UIImageView?, backImage: UIImageView?, barcodeImage: UIImageView?, color: UIPickerView?, tags: UITextView?, logo: UIImageView?, description: UITextView?) throws{
        
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        request.predicate = NSPredicate(format: "cardName = %@", keyField)
        
        do{
            let cards = try context.fetch(request)
            let card = cards[0]
            
            card.cardName = name?.text
            card.frontImage = addURLFor(frontImage?.image)
            card.backImage = addURLFor(backImage?.image)
            card.barcode = addURLFor(barcodeImage?.image)
            let colorIndex = (color?.selectedRow(inComponent: 0))!
            let colorName = colorFilters[colorIndex]
            card.colorFilter = colorName
            card.tags = tags?.text
            card.logo = addURLFor(logo?.image)
            card.cardDescription = description?.text
            
            save(context: card.managedObjectContext)
        } catch{
            throw error
        }
    }
    
    /// need to be tested - Deletes particular item in DB
    static func delete(keyField: String){


    }
    
    static func loadAllDataTo(_ cards: inout [Card]?){
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "cardName", ascending: true)]
        
        cards = try? context.fetch(request)
    }
    
    static func fetchCard(_ card: String) -> Card?{
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        request.predicate = NSPredicate(format: "cardName = %@", card)
        
        if let cards = try? context.fetch(request), !cards.isEmpty{
            return cards[0]
        }
        return nil
    }
    
    static func fetchCardsBy(color: String) -> [Card]?{
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        request.predicate = NSPredicate(format: "colorFilter = %@", color)
        
        if let cards = try? context.fetch(request), !cards.isEmpty{
            return cards
        }
        return nil
    }
    
    /// need to be tested
    static private func addURLFor (_ image: UIImage! )  -> String? {
        if image == nil || image == UIImage(contentsOfFile: "questionMark.png"){
            return nil
        }
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let uniqueName = UUID().uuidString + ".png"
        // Change extension if you want to save as JPG/PNG/etc.
        let imageURL = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent(uniqueName))
        
        // probably is not required (just for testing)
        let imageString = String(describing: imageURL)
        print (uniqueName == imageString)
        // * * * *
        
        do{
            try UIImageJPEGRepresentation(image, 1.0)?.write(to: imageURL, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
        
        return uniqueName
    }
    
    /// need to be tested
    static func loadImageFromPath(_ path: String?) -> UIImage? {
        if path == nil {return nil}
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imageURL = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent(path!))
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            
            return UIImage(data: imageData)
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    static func isNameAlreadyExist(name: String, in context: NSManagedObjectContext) -> Bool?{
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        request.predicate = NSPredicate(format: "cardName = %@", name)
        if let result = try? context.fetch(request){
            return !result.isEmpty
        }
        
        return nil
    }
    
    /// need to be tested
    static func generateBarcode(from code: String) -> UIImage? {
        let data = code.data(using: .ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        
        return UIImage(ciImage: (filter?.outputImage)!)
    }
    
    /*
    /// need to be tested
    static private func createSetOfTag(from tags: UITextView?, context: NSManagedObjectContext?) -> NSSet? {
        if let textViewText = tags?.text {
            var tagsSet = Set<Tag>()
            
            let rightString = textViewText.replacingOccurrences(of: "[\\W\\s]+", with: ",", options: .regularExpression)
            let textArray = rightString.split(separator: ",")
            let arrayOfUniqueTags = Array(Set(textArray))
            
            for tagText in arrayOfUniqueTags{
                let tagInDB = Tag(context: context!)
                
                tagInDB.name = String(tagText)
                tagsSet.insert(tagInDB)
            }
            
            return tagsSet as NSSet
        } else{
            return nil
        }
    }
 */
    
    /// Saves a passed context (just context.save)
    static private func save(context: NSManagedObjectContext?){
        do {
            try context?.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}
