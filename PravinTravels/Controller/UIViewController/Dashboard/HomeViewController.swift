//
//  HomeViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 02/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Book a Cab"
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
    
    //MARK:- Instance Methods
    
    func makeAPhoneCall()  {
        let url: NSURL = URL(string: "TEL://7620368331")! as NSURL//8888855220
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnLocalButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocalViewController") as! LocalViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionOnOutstationButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OutstationTwoViewController") as! OutstationTwoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionOnTransferButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransferViewController") as! TransferViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionOnOnewayDealButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OneWayDealsViewController") as! OneWayDealsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionOnRightBarPhoneButton(_ sender: Any) {
        makeAPhoneCall()
    }

}
