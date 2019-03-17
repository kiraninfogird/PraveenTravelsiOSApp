//
//  ForgotPasswordOneViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 13/12/18.
//  Copyright © 2018 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordOneViewController: UIViewController {
    
    //MARK:- Variable Declarations
    
    @IBOutlet var emailMobileTF: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    //MARK:- ViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reset Password"
        emailMobileTF.setBottomBorderForgot()
//        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide navigation bar back button title
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.isNavigationBarHidden = false
        submitButton.layer.cornerRadius = 0.2 *
            submitButton.frame.size.height
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnSubmitButton(_ sender: Any) {
        self.view.endEditing(true)
        let mEmailMobile = emailMobileTF.text!
        
        if mEmailMobile.isEmpty{
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Field should not be empty, Please enter email or mobile number...")
        }else{
            self.forgotPasswordAPICall(parameters_emailmobile: mEmailMobile, parameters_responseType: "2")
        }
    }
    
    // MARK:- API CALL
    
    func forgotPasswordAPICall(parameters_emailmobile: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.FORGOT_PASSWORD + "email=\(parameters_emailmobile)&responsetype=\(parameters_responseType)"
            
            let escapedString = todosEndpoint.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            AppUtility.sharedInstance.showProgressIndicatorWith(message: "Processing...")
            
            Alamofire.request(escapedString!, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    AppUtility.sharedInstance.hideProgressIndicatorWith()
                    //{"responseMessage":"This Email Or Mobile Does Not Exist","responseCode":0}
                    if let data = response.result.value{
                        if  (data as? [String : AnyObject]) != nil{
                            if let dictionaryArray = data as? Dictionary<String, AnyObject?>{
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
                                        self.view.endEditing(true)
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordTwoViewController") as! ForgotPasswordTwoViewController
                                        self.navigationController?.pushViewController(vc, animated: true)
                                        self.emailMobileTF.text = ""
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

extension ForgotPasswordOneViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordOneViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func setBottomBorderForgot() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = UITextBorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
