//
//  WalletViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 13/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire

class WalletViewController: UIViewController, PaymentDoneDelegate {

    //MARK:- Variable Declarations
    
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var addFundButton: UIButton!
    @IBOutlet var mView: UIView!
    var loginUserId = Int()
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Wallet"
        
        // make cell2.totalAmountButton Label dashed line
        let mViewBorder = CAShapeLayer()
        mViewBorder.strokeColor = UIColor.lightGray.cgColor
        mViewBorder.lineDashPattern = [2, 2]
        mViewBorder.frame = mView.bounds
        mViewBorder.fillColor = nil
        mViewBorder.path = UIBezierPath(rect: mView.bounds).cgPath
        mView.layer.addSublayer(mViewBorder)
        
        addFundButton.layer.cornerRadius = 0.1 *
            addFundButton.frame.size.height
        
        if let userId = UserDefaults.standard.value(forKey: Constant.LOGIN_USER_ID) as? Int{
            self.loginUserId = userId
            self.getCCRCashWalletBalanceDetailsAPICall(parameters_uId: "\(userId)", parameters_responseType: "2")
        }
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
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnAddFundButton(_ sender: Any) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddFundPopUpViewController") as! AddFundPopUpViewController
        popOverVC.mDelegate = self
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    //MARK:- Delegate Methods

    func refreshWalletBalance() {
        self.getCCRCashWalletBalanceDetailsAPICall(parameters_uId: "\(self.loginUserId)", parameters_responseType: "2")
    }
    
    //MARK:- API Call Methods
    
    func getCCRCashWalletBalanceDetailsAPICall(parameters_uId: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.GET_CCR_CASH_WALLET_BALANCE + "uId=\(parameters_uId)&responsetype=\(parameters_responseType)"
            
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
                                    let Object = dictionaryArray[0]
                                    if let balance = Object["balance"] as? Int{
                                        self.amountLabel.text = "₹ " + "\(Double(balance))"
                                    }
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
