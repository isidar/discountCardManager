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
                /*
                super.viewDidLoad()
                
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: UIScreen.main.bounds.height - 100))
                
                configurePageControl()
                
                scrollView.delegate = self
                
                self.view.addSubview(scrollView)
                for  i in stride(from: 0, to: imagelist, by: 1) {
                    var frame = CGRect.zero
                    frame.origin.x = self.scrollView.frame.size.width * CGFloat(i)
                    frame.origin.y = 0
                    frame.size = self.scrollView.frame.size
                    self.scrollView.isPagingEnabled = true
                    
                    
                    let myImageView:UIImageView = UIImageView()
                    myImageView.transform = myImageView.transform.rotated(by: CGFloat((Double.pi / 2) * -1))
                    myImageView.image = fileManager.loadImageFromPath(date: (cardArray?.created)!, count: i+1)
                    myImageView.contentMode = UIViewContentMode.scaleAspectFit
                    myImageView.frame = frame
                    
                    scrollView.addSubview(myImageView)
                */
                
                // Front Image init
                if let frontImage = CardManager.loadImageFromPath(card.frontImage){
                    if frontImage.size.width > frontImage.size.height{
                        rotate(images: frontImageView, direction: .left)
                        frontImageView.frame = (frontImageView.superview?.frame)!
//                        Feature.swapBoundsSize(of: frontImageView)
//                        Feature.swapFrameSize(of: frontImageView)
                    }
                    frontImageView.contentMode = .scaleToFill
                    frontImageView.image = frontImage
                } else{
                    frontImageView.contentMode = .scaleAspectFit
                    frontImageView.image = frontImageView.defaultImage
                }
                
                // Back Image init
                if let backImage = CardManager.loadImageFromPath(card.backImage){
                    if backImage.size.width > backImage.size.height{
                        rotate(images: backImageView, direction: .left)
                        Feature.swapBoundsSize(of: backImageView)
                    }
                    backImageView.contentMode = .scaleToFill
                    backImageView.image = backImage
                } else{
                    backImageView.contentMode = .scaleAspectFit
                    backImageView.image = backImageView.defaultImage
                }
                
                // Barcode Image init
                if let barcodeImage = CardManager.loadImageFromPath(card.barcode){
                    if barcodeImage.size.width > barcodeImage.size.height{
                        rotate(images: barcodeImageView, direction: .left)
                        Feature.swapBoundsSize(of: barcodeImageView)
                    }
                    barcodeImageView.contentMode = .scaleToFill
                    barcodeImageView.image = barcodeImage
                } else{
                    barcodeImageView.contentMode = .scaleAspectFit
                    barcodeImageView.image = barcodeImageView.defaultImage
                }
            }
        }
    }
    
    /// Rotates images in left or right direction
    private func rotate(images: UIImageView... , direction: Feature.Direction){
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
