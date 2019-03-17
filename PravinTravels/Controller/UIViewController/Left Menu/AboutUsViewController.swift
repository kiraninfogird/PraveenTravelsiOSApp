//
//  AboutUsViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 12/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About Us"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        let menuButton = self.navigationItem.leftBarButtonItem
        
        if self.revealViewController() != nil {
            menuButton?.target = self.revealViewController()
            menuButton?.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }

}
