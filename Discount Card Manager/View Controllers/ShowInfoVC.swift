//
//  ShowInfoVC.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 11/14/17.
//  Copyright © 2017 Nazarii Melnyk. All rights reserved.
//

import UIKit

class ShowInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBOutlet weak var frontImageView: MyImageView!
    @IBOutlet weak var backImageView: MyImageView!
    @IBOutlet weak var barcodeImageView: MyImageView!
    
    private func loadData(){
        if let cardName = navigationItem.title{
            if let card = CardManager.fetchCard(cardName){
                //let defaultImage = UIImage(contentsOfFile: "questionMark.png")!
                //let defaultImage = UIImage(named: "questionMark.png")!
                
                let frontImage = CardManager.loadImageFromPath(card.frontImage) ?? frontImageView.defaultImage// ?? defaultImage
                let backImage = CardManager.loadImageFromPath(card.backImage) ?? backImageView.defaultImage// ?? defaultImage
                let barcodeImage = CardManager.loadImageFromPath(card.barcode) ?? barcodeImageView.defaultImage// ?? defaultImage
                
                if let image = frontImage, image.size.width > image.size.height{
                    rotate(images: frontImageView, direction: .left)
                }
                if let image = backImage, image.size.width > image.size.height{
                    rotate(images: backImageView, direction: .left)
                }
                if let image = barcodeImage, image.size.width > image.size.height{
                    rotate(images: barcodeImageView, direction: .left)
                }
                
                frontImageView.image = frontImage
                backImageView.image = backImage
                barcodeImageView.image = barcodeImage
                
                /*
                let myImageView:UIImageView = UIImageView()
                myImageView.transform = myImageView.transform.rotated(by: CGFloat((Double.pi / 2) * -1))
                myImageView.image = fileManager.loadImageFromPath(date: (cardArray?.created)!, count: i+1)
                myImageView.contentMode = UIViewContentMode.scaleAspectFit
                myImageView.frame = frame
                */
                
            }
        }
    }
    
    /// Rotates images in left or right direction
    private func rotate(images: UIImageView... , direction: Features.Direction){
        switch direction{
        case .left:
            for imageView in images{
                imageView.transform = imageView.transform.rotated(by: CGFloat((Double.pi / 2) * -1))
            }
        case .right:
            for imageView in images{
                imageView.transform = imageView.transform.rotated(by: CGFloat((Double.pi / 2) * 1))
            }
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier{
            case "Edit":
                if let vc = segue.destination as? EditTableVC{
                    if let cardName = self.navigationItem.title {
                        vc.navigationItem.title = cardName
                    }
                }
            default: break
            }
        }
    }
    

}
