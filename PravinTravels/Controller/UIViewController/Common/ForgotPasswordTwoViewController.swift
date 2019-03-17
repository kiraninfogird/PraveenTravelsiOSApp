//
//  ForgotPasswordTwoViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 13/12/18.
//  Copyright © 2018 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordTwoViewController: UIViewController {

    //MARK:- Variable Declarations
    
    @IBOutlet var mobileNumberLabel: UILabel!
    @IBOutlet var EnterVerificationCodeTF: UITextField!
    @IBOutlet var newPasswordTF: UITextField!
    @IBOutlet var confirmPasswordTF: UITextField!
    @IBOutlet var changePasswordButton: UIButton!
    
    //MARK:- ViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reset Password"
        newPasswordTF.setBottomBorderForgot2()
        confirmPasswordTF.setBottomBorderForgot2()
        EnterVerificationCodeTF.setBottomBorderForgot2()
//        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide navigation bar back button title
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.isNavigationBarHidden = false
        changePasswordButton.layer.cornerRadius = 0.2 *
            changePasswordButton.frame.size.height
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnChangePasswordButton(_ sender: Any) {
        self.view.endEditing(true)
        let verificationCode = EnterVerificationCodeTF.text!
        let newPassword = newPasswordTF.text!
        let confirmPassword = confirmPasswordTF.text!
        
        if verificationCode != ""{
            if newPassword != ""{
                let isPasswordValid = isValidPassword(newPassword)
                if isPasswordValid{
                    if confirmPassword != ""{
                        let isConfirmPasswordValid = isValidPassword(confirmPassword)
                        if isConfirmPasswordValid{
                             self.resetPasswordAPICall(parameters_password: newPassword, parameters_confirmPassword: confirmPassword, parameters_otp: verificationCode, parameters_responseType: "2")
                        }else{
                            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Enter confirm password is not valid, please enter again...")
                        }
                    }else{
                        AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please enter the confirm password...")
                    }
                }else{
                    AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Enter new password is not valid, please enter again...")
                }
            }else{
                AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please enter the new password...")
            }
        }else{
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Fields should not be empty, please fill all the fields...")
        }
    }
    
    @IBAction func actionOnDontReceiveCodeButton(_ sender: Any) {
        print("actionOnDontReceiveCodeButton...")
    }
    
    //MARK:-  Validation Methods
    
    // password validation
    func isValidPassword(_ PasswordString: String) -> Bool {
        var returnValue = true
        let mobileRegEx =  "[A-Za-z0-9.-_@#$!%&*]{5,15}$"  // "^[A-Z0-9a-z.-_]{5}$"
        do {
            let regex = try NSRegularExpression(pattern: mobileRegEx)
            let nsString = PasswordString as NSString
            let results = regex.matches(in: PasswordString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0
            {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    // OTP validation
    func isValidOTP(_ OTPString: String) -> Bool {
        var returnValue = true
        let mobileRegEx =  "[0-9]{6}$" // only 6 digit OTP
        do {
            let regex = try NSRegularExpression(pattern: mobileRegEx)
            let nsString = OTPString as NSString
            let results = regex.matches(in: OTPString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0
            {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    //MARK:- API Call
    
    func resetPasswordAPICall(parameters_password: String,parameters_confirmPassword: String,parameters_otp: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            let todosEndpoint: String = Constant.BASE_URL + Constant.RESET_PASSWORD + "password=\(parameters_password)&confirmPassword=\(parameters_confirmPassword)&otp=\(parameters_otp)&responsetype=\(parameters_responseType)"
            
            let escapedString = todosEndpoint.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            AppUtility.sharedInstance.showProgressIndicatorWith(message: "Processing...")
            
            Alamofire.request(escapedString!, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    AppUtility.sharedInstance.hideProgressIndicatorWith()
                    if let data = response.result.value{
                        if  (data as? [[String : AnyObject]]) != nil{
                            if let dictionaryArray = data as? Array<Dictionary<String, AnyObject?>> {
                                if dictionaryArray.count > 0 {
                                    var res_code = 0
                                    var res_msg = ""
                                    for i in 0..<dictionaryArray.count{
                                        let Object = dictionaryArray[i]
                                        if let responseCode = Object["responseCode"] as? Int{
                                            res_code = responseCode
                                        }
                                        if let responseMessage = Object["responseMessage"] as? Array<String>{
                                            res_msg = responseMessage[0]
                                        }
                                    }
                                    if res_code == 1 {
                                        AppUtility.sharedInstance.showAlertToastMesssageForSuccess(messageToUser: res_msg)
                                        for controller in self.navigationController!.viewControllers as Array {
                                            if controller.isKind(of: LoginViewController.self) {
                                                self.navigationController!.popToViewController(controller, animated: true)
                                                break
                                            }
                                        }
                                    }else{
                                        AppUtility.sharedInstance.showAlertToastMesssage(messageToUser: res_msg)
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

extension ForgotPasswordTwoViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordTwoViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func setBottomBorderForgot2() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = UITextBorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
