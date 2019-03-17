//
//  HomeTableViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 13/02/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class HomeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK:- Variable Declarations
    
    @IBOutlet var mTableView: UITableView!
    
    //MARK:- ViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Book a Cab"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        mTableView.tableFooterView = UIView(frame: .zero)// Remove empty cell from tableview
        
        let menuButton = self.navigationItem.leftBarButtonItem
        
        if self.revealViewController() != nil {
            menuButton?.target = self.revealViewController()
            menuButton?.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    //MARK:- TableView DataSource and Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell")! as! HomeTableViewCell
//        cell.mView.layer.cornerRadius = 05
        
        if indexPath.row == 0 {
            cell.imageButton.setImage(UIImage(named: "outstation_ccr"), for: .normal)
            cell.nameLabel.text = "OUTSTATION"
        }else if indexPath.row == 1 {
            cell.imageButton.setImage(UIImage(named: "local_ccr"), for: .normal)
            cell.nameLabel.text = "LOCAL"
        }else if indexPath.row == 2 {
            cell.imageButton.setImage(UIImage(named: "transfer_ccr"), for: .normal)
            cell.nameLabel.text = "TRANSFER"
        }else{
            cell.imageButton.setImage(UIImage(named: "onewaydeals_ccr"), for: .normal)
            cell.nameLabel.text = "ONEWAY DEALS"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OutstationTwoViewController") as! OutstationTwoViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocalViewController") as! LocalViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransferViewController") as! TransferViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OneWayDealsViewController") as! OneWayDealsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
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
    
    @IBAction func actionOnRightBarButtonItem(_ sender: Any) {
        makeAPhoneCall()
    }
    

}
