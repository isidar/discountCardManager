//
//  ShowInfoVC.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/14/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit

class ShowInfoViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var frontImageView: MyImageView!
    @IBOutlet weak var backImageView: MyImageView!
    @IBOutlet weak var barcodeImageView: MyImageView!
    
    // MARK: - View Controller's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Other functions
    
    /// Loads UIImages with appropriate images
    private func loadData() {
        if let cardName = navigationItem.title {
            if let card = CardManager.fetchCard(cardName) {
                
                // Front Image init
                if let frontImage = CardManager.loadImageFromPath(card.frontImage){
                    frontImageView.contentMode = .scaleToFill
                    frontImageView.image = frontImage.size.width > frontImage.size.height ?
                        rotate(image: frontImage) :
                    frontImage
                } else {
                    frontImageView.contentMode = .scaleAspectFit
                    frontImageView.image = frontImageView.defaultImage
                }
                
                // Back Image init
                if let backImage = CardManager.loadImageFromPath(card.backImage){
                    backImageView.contentMode = .scaleToFill
                    backImageView.image = backImage.size.width > backImage.size.height ?
                        rotate(image: backImage) :
                    backImage
                } else {
                    backImageView.contentMode = .scaleAspectFit
                    backImageView.image = backImageView.defaultImage
                }
                
                // Barcode Image init
                var barcodeImage: UIImage? = nil
                
                if let number = card.barcodeNumber {
                    barcodeImage = CardManager.generateBarcode(from: number)
                } else if let image = card.barcodeImage {
                    barcodeImage = CardManager.loadImageFromPath(image)
                }
                
                if barcodeImage != nil {
                    barcodeImageView.contentMode = .scaleToFill
                    barcodeImageView.image = barcodeImage!.size.width > barcodeImage!.size.height ?
                        rotate(image: barcodeImage) :
                    barcodeImage
                } else {
                    barcodeImageView.contentMode = .scaleAspectFit
                    barcodeImageView.image = barcodeImageView.defaultImage
                }
            }
        }
    }
    
    /// Rotates UIImageView in left or right direction
    private func rotate(images: UIImageView... , direction: Feature.Direction) {
        switch direction {
        case .left:
            for imageView in images {
                imageView.transform = imageView.transform.rotated(by: CGFloat((Double.pi / 2) * -1))
            }
        case .right:
            for imageView in images {
                imageView.transform = imageView.transform.rotated(by: CGFloat((Double.pi / 2) * 1))
            }
        }
    }
    
    /// Rotates UIImage in right direction
    func rotate(image: UIImage?) -> UIImage? {
        if let originalImage = image {
            let rotateSize = CGSize(width: originalImage.size.height, height: originalImage.size.width)
            UIGraphicsBeginImageContextWithOptions(rotateSize, true, 2.0)
            
            if let context = UIGraphicsGetCurrentContext() {
                context.rotate(by: 90.0 * CGFloat(Double.pi) / 180.0)
                context.translateBy(x: 0, y: -originalImage.size.height)
                originalImage.draw(in: CGRect.init(x: 0, y: 0, width: originalImage.size.width, height: originalImage.size.height))
                
                let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return rotatedImage!
            }
        }
        return nil
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Edit":
                if let vc = segue.destination as? EditTableViewController {
                    if let cardName = self.navigationItem.title {
                        vc.navigationItem.title = cardName
                    }
                }
            default: break
            }
        }
    }
    

}

