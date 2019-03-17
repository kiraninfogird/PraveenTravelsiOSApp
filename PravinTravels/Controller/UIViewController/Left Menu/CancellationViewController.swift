//
//  CancellationViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 13/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire

class CancellationViewController: UIViewController {

    //MARK:- Variable Declarations
    
    @IBOutlet var crnNumberTextField: UITextField!
    @IBOutlet var proceedButton: UIButton!
    var loginUserId = Int()
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cancellation"
        
        proceedButton.layer.cornerRadius = 0.1 *
            proceedButton.frame.size.height
        
        if let userId = UserDefaults.standard.value(forKey: Constant.LOGIN_USER_ID) as? Int{
            self.loginUserId = userId
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
    
    @IBAction func actionOnProceedButton(_ sender: Any) {
        let crnNumber = crnNumberTextField.text!
        
        if crnNumber.isEmpty{
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Fields should not be empty, Please enter valid CRN Number...")
        }else{
            bookingCancellationAPICall(parameters_uId: "\(loginUserId)", parameters_crnNo: crnNumber, parameters_remark: "", parameters_responseType: "2")
        }
    }
    
    // MARK:- API CALL Methods
    
    func bookingCancellationAPICall(parameters_uId: String, parameters_crnNo: String, parameters_remark: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.BOOKING_CANCELLATION + "uId=\(parameters_uId)&crnNo=\(parameters_crnNo)&remark=\(parameters_remark)&responsetype=\(parameters_responseType)"
            
            let escapedString = todosEndpoint.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            AppUtility.sharedInstance.showProgressIndicatorWith(message: "Processing...")
            
            Alamofire.request(escapedString!, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    
                    AppUtility.sharedInstance.hideProgressIndicatorWith()
                    
                    if let data = response.result.value{
                        if  (data as? [String : AnyObject]) != nil{
                            if let dictionaryArray = data as? Dictionary<String, AnyObject?> {
                                if dictionaryArray.count > 0 {
                                    var res_code = 0
                                    var res_msg = ""
                                        if let responseCode = dictionaryArray["responseCode"] as? Int{
                                            res_code = responseCode
                                        }
                                        if let responseMessage = dictionaryArray["responseMessage"] as? String{
                                            res_msg = responseMessage
                                        }
                                    if res_code == 1 {
                                        AppUtility.sharedInstance.showAlertWithoutIcon(title: "Success", subTitle: res_msg)
                                        self.crnNumberTextField.text = ""
                                    }else if res_code == 2{
                                        AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: res_msg)
                                        self.crnNumberTextField.text = ""
                                    }else{
                                        AppUtility.sharedInstance.showAlertWithoutIcon(title: "Failed", subTitle: res_msg)
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
