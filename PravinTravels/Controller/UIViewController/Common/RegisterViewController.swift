//
//  RegisterViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 13/12/18.
//  Copyright © 2018 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    //MARK:- Variable Declarations
    
    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var lastNameTF: UITextField!
    @IBOutlet var emailIdTF: UITextField!
    @IBOutlet var mobileTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var confirmPassowrd: UITextField!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var mAlreadyAMemberButton: UIButton!
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var mobile = ""
    var password = ""
    var confirmPassword = ""
    
    // Verification View
    @IBOutlet var mVerificationView: UIView!
    @IBOutlet var mEnterVerificationCodeTextField: UITextField!
    
    //MARK:- ViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"
        firstNameTF.setBottomBorderRegister()
        lastNameTF.setBottomBorderRegister()
        emailIdTF.setBottomBorderRegister()
        mobileTF.setBottomBorderRegister()
        passwordTF.setBottomBorderRegister()
        confirmPassowrd.setBottomBorderRegister()
//        mEnterVerificationCodeTextField.setBottomBorder()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.isNavigationBarHidden = false
        self.mVerificationView.isHidden = true
        self.mVerificationView.layer.cornerRadius = 05
        registerButton.layer.cornerRadius = 0.2 *
            registerButton.frame.size.height
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnRegisterButton(_ sender: Any) {
        self.view.endEditing(true)
        firstName = firstNameTF.text!
        lastName = lastNameTF.text!
        email = emailIdTF.text!
        mobile = mobileTF.text!
        password = passwordTF.text!
        confirmPassword = confirmPassowrd.text!
        
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || mobile.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Fields should not be empty, Please fill all the fields...")
        }else{
            let isFirstNameValid = isValidName(firstName)
            if isFirstNameValid{
                let isLastNameValid = isValidName(lastName)
                if isLastNameValid{
                    let isEmailAddressValid = isValidEmailAddress(email)
                    if isEmailAddressValid{
                        let isMobileValid = isValidPhoneNumber(mobile)
                        if isMobileValid{
                            let isPasswordValid = isValidPassword(password)
                            if isPasswordValid{
                                let isConfirmPasswordValid = isValidPassword(confirmPassword)
                                if isConfirmPasswordValid{
                                    self.registerAPICall(parameters_firstName: firstName, parameters_lastName: lastName, parameters_email: email, parameters_mobile: mobile, parameters_password: password, parameters_confirmPassword: confirmPassword, parameters_otp: "", parameters_responseType: "2")
                                }else{
                                    AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Enter confirm password is not valid, please enter again...")
                                }
                            }else{
                                AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Enter password is not valid, please enter again...")
                            }
                        }else{
                            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Enter mobile number is not valid, please enter again...")
                        }
                    }else{
                        AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Enter email is not valid, please enter again...")
                    }
                }else{
                    AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Enter last name is not valid, please enter again...")
                }
            }else{
                AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Enter first name is not valid, please enter again...")
            }
        }
    }
    
    @IBAction func actionOnAlreadyMemberButton(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionOnCancelButton(_ sender: Any) {
        self.mVerificationView.isHidden = true
        self.registerButton.isUserInteractionEnabled = true
        self.mAlreadyAMemberButton.isUserInteractionEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
        self.enableAllTextFields()
    }
    
    @IBAction func actionOnViewSubmitButton(_ sender: Any) {
        let verificatin_code = mEnterVerificationCodeTextField.text!
        if verificatin_code.isEmpty{
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please enter the OTP...")
        }else{
            self.signUpAfterVerifyOTPAPICall(parameters_firstName: firstName, parameters_lastName: lastName, parameters_email: email, parameters_mobile: mobile, parameters_password: password, parameters_confirmPassword: confirmPassword, parameters_otp: verificatin_code, parameters_responseType: "2")
        }
    }
    
    //MARK:- Instance Methods
    
    func clearAllTextFields()  {
        self.firstNameTF.text = ""
        self.lastNameTF.text = ""
        self.emailIdTF.text = ""
        self.mobileTF.text = ""
        self.passwordTF.text = ""
        self.confirmPassowrd.text = ""
    }
    
    func disableAllTextFields()  {
        self.firstNameTF.isEnabled = false
        self.lastNameTF.isEnabled = false
        self.emailIdTF.isEnabled = false
        self.mobileTF.isEnabled = false
        self.passwordTF.isEnabled = false
        self.confirmPassowrd.isEnabled = false
    }
    
    func enableAllTextFields()  {
        self.firstNameTF.isEnabled = true
        self.lastNameTF.isEnabled = true
        self.emailIdTF.isEnabled = true
        self.mobileTF.isEnabled = true
        self.passwordTF.isEnabled = true
        self.confirmPassowrd.isEnabled = true
    }
    
    // MARK:- Validataion Methods
    
    // Name validation
    func isValidName(_ nameString: String) -> Bool {
        var returnValue = true
        let mobileRegEx =  "[A-Za-z]{2}"  // "^[A-Z0-9a-z.-_]{5}$"
        do {
            let regex = try NSRegularExpression(pattern: mobileRegEx)
            let nsString = nameString as NSString
            let results = regex.matches(in: nameString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0
            {
                returnValue = false
            }
        }catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
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
        }catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    // email validaton
    func isValidEmailAddress(_ emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0
            {
                returnValue = false
            }
            
        }catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    // mobile no. validation
    func isValidPhoneNumber(_ phoneNumberString: String) -> Bool {
        var returnValue = true
        //        let mobileRegEx = "^[789][0-9]{9,11}$"
        let mobileRegEx = "^[0-9]{10}$"
        do {
            let regex = try NSRegularExpression(pattern: mobileRegEx)
            let nsString = phoneNumberString as NSString
            let results = regex.matches(in: phoneNumberString, range: NSRange(location: 0, length: nsString.length))
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
    
    // MARK:- API CALL Methods
    
    func registerAPICall(parameters_firstName: String, parameters_lastName: String, parameters_email: String, parameters_mobile: String, parameters_password: String, parameters_confirmPassword: String, parameters_otp: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.SIGN_UP + "firstName=\(parameters_firstName)&lastName=\(parameters_lastName)&email=\(parameters_email)&mobile=\(parameters_mobile)&password=\(parameters_password)&confirmpassword=\(parameters_confirmPassword)&otp=\(parameters_otp)&responsetype=\(parameters_responseType)"
            
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
                    AppUtility.sharedInstance.showAlertToastMesssageForSuccess(messageToUser: res_msg)
                                        // OPEN POPUP VIEW
                                        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                                        self.view.bringSubview(toFront: self.mVerificationView)
                                        self.mVerificationView.isHidden = false
                                        self.registerButton.isUserInteractionEnabled = false
                                        self.mAlreadyAMemberButton.isUserInteractionEnabled = false
                                        self.navigationController?.navigationBar.isUserInteractionEnabled = false
                                        self.disableAllTextFields()
//                                        self.clearAllTextFields()
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
    
    func signUpAfterVerifyOTPAPICall(parameters_firstName: String, parameters_lastName: String, parameters_email: String, parameters_mobile: String, parameters_password: String, parameters_confirmPassword: String, parameters_otp: String, parameters_responseType: String) {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.SIGN_UP + "firstName=\(parameters_firstName)&lastName=\(parameters_lastName)&email=\(parameters_email)&mobile=\(parameters_mobile)&password=\(parameters_password)&confirmpassword=\(parameters_confirmPassword)&otp=\(parameters_otp)&responsetype=\(parameters_responseType)"
            
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
                                        AppUtility.sharedInstance.showAlertToastMesssageForSuccess(messageToUser: res_msg)
                                        self.clearAllTextFields()
                                        self.enableAllTextFields()
                                        self.view.backgroundColor = UIColor.black.withAlphaComponent(1.0)
                                        self.mVerificationView.isHidden = true
                                        self.registerButton.isUserInteractionEnabled = true
                                        self.mAlreadyAMemberButton.isUserInteractionEnabled = true
                                        self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                        _ = self.navigationController?.popViewController(animated: true)
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

extension RegisterViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func setBottomBorderRegister() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = UITextBorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}

