//
//  MyBookingViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 13/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire

class MyBookingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- Variable Declarations
    
    var bookingItems = [[String : AnyObject]]()
    var loginUserId = Int()
    @IBOutlet var mTableView: UITableView!
    @IBOutlet var noBookingAvaLabel: UILabel!
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Booking"
        if let userId = UserDefaults.standard.value(forKey: Constant.LOGIN_USER_ID) as? Int{
            self.loginUserId = userId
            self.myBookingDetailsAPICall(parameters_uId: "\(self.loginUserId)", parameters_responseType: "2")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        // Remove empty cell from tableview
        mTableView.tableFooterView = UIView(frame: .zero)
        
        let menuButton = self.navigationItem.leftBarButtonItem
        
        if self.revealViewController() != nil {
            menuButton?.target = self.revealViewController()
            menuButton?.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    //MARK:- TableView DataSource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingTableViewCell")! as! MyBookingTableViewCell
//        cell.layer.cornerRadius = 10
//        cell.contentView.layer.cornerRadius = 10
        
        let dict : NSDictionary = bookingItems[indexPath.row] as NSDictionary
        
        if let refNo = dict["refNo"] as? String{
            cell.crnNoLabel.text = refNo
        }else{
            cell.crnNoLabel.text = "NA"
        }
        if let tDate = dict["tDate"] as? String{
            cell.travelDate.text = tDate
        }else{
            cell.travelDate.text = "NA"
        }
//        if let pickupTime = dict["pickupTime"] as? String{
//            cell.mPickupTimeLabel.text = pickupTime
//        }else{
//            cell.mPickupTimeLabel.text = "NA"
//        }
        if let ctname = dict["ctname"] as? String{
            cell.pickupCityLabel.text = ctname
        }else{
            cell.pickupCityLabel.text = "NA"
        }
        if let vehicleName = dict["vehicleName"] as? String{
            cell.vehicleNameLabel.text = vehicleName
        }else{
            cell.vehicleNameLabel.text = "NA"
        }
        if let tariffName = dict["tariffName"] as? String{
            if let tariffSubName = dict["tariffSubName"] as? String{
                cell.topLabel.text = tariffName + " (" + tariffSubName + ")"
            }
        }else{
            cell.topLabel.text = "NA"
        }
        if let status = dict["status"] as? Int{
            if status == 0{
                cell.statusLabel.text = "Pending"
                cell.statusLabel.textColor = UIColor.brown
                cell.sideColorLabel.backgroundColor = UIColor.brown
            }else if status == 1{
                cell.statusLabel.text = "Confirmed"
                cell.statusLabel.textColor = Colors.toastMessageLightGrayThemeColor
                cell.sideColorLabel.backgroundColor = Colors.toastMessageLightGrayThemeColor
            }else if status == 2{
                cell.statusLabel.text = "Cancelled"
                cell.statusLabel.textColor = UIColor.red
                cell.sideColorLabel.backgroundColor = UIColor.red
            }else if status == 3{
                cell.statusLabel.text = "Duty Closed"
                cell.statusLabel.textColor = UIColor.purple
                cell.sideColorLabel.backgroundColor = UIColor.purple
            }else if status == 4{
                cell.statusLabel.text = "Completed"
                cell.statusLabel.textColor = UIColor.blue
                cell.sideColorLabel.backgroundColor = UIColor.blue
            }else if status == 9{
                cell.statusLabel.text = "Other"
                cell.statusLabel.textColor = UIColor.blue
                cell.sideColorLabel.backgroundColor = UIColor.blue
            }else{
                cell.statusLabel.text = "NA"
                cell.sideColorLabel.backgroundColor = UIColor.clear
            }
        }
        
        // make cell2.dashLabel Label dashed line
        let mViewBorder2 = CAShapeLayer()
        mViewBorder2.strokeColor = UIColor.magenta.cgColor
        mViewBorder2.lineDashPattern = [2, 2]
        mViewBorder2.frame = cell.statusLabel.bounds
        mViewBorder2.fillColor = nil
        mViewBorder2.path = UIBezierPath(rect: cell.statusLabel.bounds).cgPath
        cell.statusLabel.layer.addSublayer(mViewBorder2)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    // MARK:- API CALL
    
    func myBookingDetailsAPICall(parameters_uId: String, parameters_responseType: String)  {
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.MY_BOOKING + "uId=\(parameters_uId)&responsetype=\(parameters_responseType)"
            
            let escapedString = todosEndpoint.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            AppUtility.sharedInstance.showProgressIndicatorWith(message: "Processing...")
            
            Alamofire.request(escapedString!, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    
                    AppUtility.sharedInstance.hideProgressIndicatorWith()
                    if let data = response.result.value{
                        if  let result = (data as? [String : AnyObject])?["result"]{
                            if let dictionaryArray = result as? Array<Dictionary<String, AnyObject?>> {
                                if dictionaryArray.count > 0 {
                                    self.bookingItems =  dictionaryArray as [[String : AnyObject]]
                                    self.noBookingAvaLabel.isHidden = true
                                    self.mTableView.isHidden = false
                                    self.mTableView.reloadData()
                                }else{
                                    self.mTableView.isHidden = true
                                    self.noBookingAvaLabel.isHidden = false
                                    self.bookingItems.removeAll()
                                    self.mTableView.reloadData()
                                }
                            }
                        }
                    }
                    else {
                        let error = (response.result.value  as? [[String : AnyObject]])
                        print(error as Any)
                    }
            }
        }else{
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Internet not available", subTitle: "Please try after sometime...")
        }
    }

}
