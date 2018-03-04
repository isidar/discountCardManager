//
//  ExtensionShowInfoViewController.swift
//  Discount Card Manager
//
//  Created by Nazarii Melnyk on 3/4/18.
//  Copyright © 2018 Nazarii Melnyk. All rights reserved.
//

import UIKit

extension ShowInfoViewController {
    // MARK: - ScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / (scrollView.contentSize.width / 3))
    }
    
}
