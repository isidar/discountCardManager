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
    static func add(name: String, frontImage: UIImage?, backImage: UIImage?, barcodeNumber: String?, barcodeImage: UIImage?, color: String?, tags: String?, logo: UIImage?, description: String?){
        let context = AppDelegate.viewContext
        let card = Card(context: context)
        
        card.cardName = name
        card.frontImage = addURLFor(frontImage)
        card.backImage = addURLFor(backImage)
        card.barcodeNumber = barcodeNumber
        card.barcodeImage = addURLFor(barcodeImage)
        card.colorFilter = color
        card.tags = tags
        card.logo = addURLFor(logo)
        card.cardDescription = description
        
        save(context: card.managedObjectContext)
    }
    
    /// Edits particular item in DB
    static func edit(keyField: String, name: String, frontImage: UIImage?, backImage: UIImage?, barcodeNumber: String?, barcodeImage: UIImage?, color: String?, tags: String?, logo: UIImage?, description: String?) throws {
        
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        request.predicate = NSPredicate(format: "cardName = %@", keyField)
        
        do {
            let cards = try context.fetch(request)
            if cards.isEmpty { return }
            
            let card = cards[0]
            
            card.cardName = name
            card.frontImage = addURLFor(frontImage)
            card.backImage = addURLFor(backImage)
            card.barcodeNumber = barcodeNumber
            card.barcodeImage = addURLFor(barcodeImage)
            card.colorFilter = color
            card.tags = tags
            card.logo = addURLFor(logo)
            card.cardDescription = description
            
            save(context: card.managedObjectContext)
        } catch {
            throw error
        }
    }
    
    /// Deletes particular item in DB
    static func delete(keyField: String) throws {
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        request.predicate = NSPredicate(format: "cardName = %@", keyField)
        
        do {
            let cards = try context.fetch(request)
            
            if !cards.isEmpty {
                context.delete(cards[0])
                save(context: context)
            }
        } catch {
            throw error
        }
    }
    
    /// Deletes particular item in DB
    static func deleteAll() throws {
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        do {
            let cards = try context.fetch(request)
            
            for card in cards {
                context.delete(card)
            }
            
            save(context: context)
        } catch {
            throw error
        }
    }
    
    // MARK: - Fetch methods
    
    ///
    static func fetchAllData() -> [Card]?{
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "cardName", ascending: true)]
        
        return try? context.fetch(request)
    }
    
    ///
    static func fetchCard(_ card: String) -> Card?{
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        request.predicate = NSPredicate(format: "cardName = %@", card)
        
        if let cards = try? context.fetch(request), !cards.isEmpty {
            return cards[0]
        }
        return nil
    }
    
    ///
    static func fetchCardsContaining(name: String, tags: String) -> [Card]?{
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        request.predicate = NSPredicate(format: "(cardName contains[c] %@) || (tags contains[c] %@)", name, tags)
        request.sortDescriptors = [NSSortDescriptor(key: "cardName", ascending: true)]
        
        if let cards = try? context.fetch(request), !cards.isEmpty {
            return cards
        }
        return nil
    }
    
    /// Retrieves all cards with certain color
    static func fetchCardsBy(color: String) -> [Card]?{
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "cardName", ascending: true)]
        request.predicate = NSPredicate(format: "colorFilter = %@", color)
        
        if let cards = try? context.fetch(request), !cards.isEmpty {
            return cards
        }
        return nil
    }
    
    /// Adds URL for given image
    static private func addURLFor (_ image: UIImage! )  -> String? {
        if image == nil {
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
        
        do {
            try UIImageJPEGRepresentation(image, 1.0)?.write(to: imageURL, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
        
        return uniqueName
    }
    
    /// Loads image from given path
    static func loadImageFromPath(_ path: String!) -> UIImage? {
        if path == nil {return nil}
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imageURL = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent(path))
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            
            return UIImage(data: imageData)
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    /// Checks if given name already exist in certain context
    static func isNameAlreadyExist(name: String, in context: NSManagedObjectContext) -> Bool?{
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        request.predicate = NSPredicate(format: "cardName = %@", name)
        if let result = try? context.fetch(request){
            return !result.isEmpty
        }
        
        return nil
    }
    
    /// need to be tested - Generates barcode image from given number as String
    static func generateBarcode(from code: String) -> UIImage? {
        let data = code.data(using: .ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        
        let ciImage = (filter?.outputImage)!
        let uiImage = UIImage(ciImage: ciImage)
        
        return uiImage
    }
    
    /*
    /// need to be tested
    static private func createSetOfTag(from tags: UITextView?, context: NSManagedObjectContext?) -> NSSet? {
        if let textViewText = tags?.text {
            var tagsSet = Set<Tag>()
            
            let rightString = textViewText.replacingOccurrences(of: "[\\W\\s]+", with: ",", options: .regularExpression)
            let textArray = rightString.split(separator: ",")
            let arrayOfUniqueTags = Array(Set(textArray))
            
            for tagText in arrayOfUniqueTags {
                let tagInDB = Tag(context: context!)
                
                tagInDB.name = String(tagText)
                tagsSet.insert(tagInDB)
            }
            
            return tagsSet as NSSet
        } else {
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
