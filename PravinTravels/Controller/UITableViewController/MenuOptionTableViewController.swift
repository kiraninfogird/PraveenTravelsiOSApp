//
//  MenuOptionTableViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 02/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class MenuOptionTableViewController: UITableViewController {

    //MARK:- Variable Declarations
    
    var login_user_email = "pravintravels@gmail.com"
    var isFromTableView = Bool()
    @IBOutlet var mTableView: UITableView!
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        mTableView.tableFooterView = UIView(frame: .zero)// Remove empty cell from tableview
        if let email = UserDefaults.standard.value(forKey: Constant.LOGIN_USER_EMAIL) as? String{
            login_user_email = email
            if isFromTableView{
                self.setUserEmail()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerProfileTableViewCell")! as! DrawerProfileTableViewCell
            cell.mProfilePhotoImageView.layer.cornerRadius = cell.mProfilePhotoImageView.frame.size.width / 2
            cell.mProfilePhotoImageView.clipsToBounds = true
            cell.mProfilePhotoImageView.layer.borderWidth = 3.0
            cell.mProfilePhotoImageView.layer.borderColor = UIColor.white.cgColor
            cell.mUserEmailLabel.text = self.login_user_email
            self.isFromTableView = true
            return cell
            
        }else if indexPath.row == 1{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "celltwo")!
            return cell1
            
        }else if indexPath.row == 2{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cellthree")!
            return cell2
            
        }else if indexPath.row == 3{
            let cell33 = tableView.dequeueReusableCell(withIdentifier: "cellfour")!
            return cell33
            
        }else if indexPath.row == 4{
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "cellfive")!
            return cell3
            
        }else if indexPath.row == 5{
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "cellsix")!
            return cell4
            
        }else if indexPath.row == 6{
            let cell5 = tableView.dequeueReusableCell(withIdentifier: "cellseven")!
            return cell5
            
        }else if indexPath.row == 7{
            let cell6 = tableView.dequeueReusableCell(withIdentifier: "celleight")!
            return cell6
            
        }else if indexPath.row == 8{
            let cell7 = tableView.dequeueReusableCell(withIdentifier: "cellnine")!
            return cell7
            
        }else {
            let cell8 = tableView.dequeueReusableCell(withIdentifier: "cellten")!
            return cell8
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 121
        }else{
            return 44
        }
    }
    
    func setUserEmail()  {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = mTableView.cellForRow(at: indexPath) as! DrawerProfileTableViewCell
        cell.mUserEmailLabel.text = self.login_user_email
    }

}
