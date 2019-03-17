//
//  MySettingViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 12/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire

class MySettingViewController: UIViewController {

    //MARK:- Variable Declarations
    
    @IBOutlet var oldPassTextField: UITextField!
    @IBOutlet var newPassTextField: UITextField!
    @IBOutlet var confirmPassTextField: UITextField!
    @IBOutlet var changePassButton: UIButton!
    
    @IBOutlet var oldPassButton: UIButton!
    @IBOutlet var newPassButton: UIButton!
    @IBOutlet var confirmPassButton: UIButton!
    
    var loginUserId = Int()
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Setting"
        oldPassTextField.setBottomBorder_setting()
        newPassTextField.setBottomBorder_setting()
        confirmPassTextField.setBottomBorder_setting()
        changePassButton.layer.cornerRadius = 0.1 *
            changePassButton.frame.size.height
        
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
    
    @IBAction func actionOnChangePasswordButton(_ sender: Any) {
        let oldPassword = oldPassTextField.text!
        let newPassword = newPassTextField.text!
        let confirmPassword = confirmPassTextField.text!
        
        if oldPassword != ""{
            if newPassword != ""{
                let isPasswordValid = isValidPassword(newPassword)
                if isPasswordValid{
                    if confirmPassword != ""{
                        let isConfirmPasswordValid = isValidPassword(confirmPassword)
                        if isConfirmPasswordValid{
                            self.changePasswordAPICall(parameters_uId: "\(loginUserId)", parameters_oldPass: oldPassword, parameters_newPass: newPassword, parameters_cofirmPass: confirmPassword, parameters_responseType: "2")
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
    
    @IBAction func actionOnOldPassButton(_ sender: Any) {
        if (oldPassTextField.isSecureTextEntry == true){
            oldPassTextField.isSecureTextEntry = false
            oldPassButton.setImage(UIImage(named: "show_pass"), for: .normal)
        }else{
            oldPassButton.setImage(UIImage(named: "hide_pass"), for: .normal)
            oldPassTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func actionOnNewPassButton(_ sender: Any) {
        if (newPassTextField.isSecureTextEntry == true){
            newPassTextField.isSecureTextEntry = false
            newPassButton.setImage(UIImage(named: "show_pass"), for: .normal)
        }else{
            newPassButton.setImage(UIImage(named: "hide_pass"), for: .normal)
            newPassTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func actionOnConfirmButton(_ sender: Any) {
        if (confirmPassTextField.isSecureTextEntry == true){
            confirmPassTextField.isSecureTextEntry = false
            confirmPassButton.setImage(UIImage(named: "show_pass"), for: .normal)
        }else{
            confirmPassButton.setImage(UIImage(named: "hide_pass"), for: .normal)
            confirmPassTextField.isSecureTextEntry = true
        }
    }
    
    //MARK:-  Instance Methods
    
    func clearAllTextFields()  {
        oldPassTextField.text = ""
        newPassTextField.text = ""
        confirmPassTextField.text = ""
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
    
    // MARK:- API CALL Methods
    
    func changePasswordAPICall(parameters_uId: String, parameters_oldPass: String, parameters_newPass: String, parameters_cofirmPass: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.CHANGE_PASSWORD + "uId=\(parameters_uId)&oldPass=\(parameters_oldPass)&newPass=\(parameters_newPass)&cofirmPass=\(parameters_cofirmPass)&responsetype=\(parameters_responseType)"
            
            let escapedString = todosEndpoint.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            AppUtility.sharedInstance.showProgressIndicatorWith(message: "Processing...")
            
            Alamofire.request(escapedString!, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    AppUtility.sharedInstance.hideProgressIndicatorWith()
                    if let data = response.result.value{
                        if  (data as? [String : AnyObject]) != nil{
                            if let dictionaryArray = data as? Dictionary<String, AnyObject?> {
                                if dictionaryArray.count > 0{
                                    var res_code = 0
                                    var res_msg = ""
                                    if let responseCode = dictionaryArray["responseCode"] as? Int{
                                        res_code = responseCode
                                    }
                                    if let responseMessage = dictionaryArray["responseMessage"] as? String{
                                        res_msg = responseMessage
                                    }
                                    if (res_code == 1){
                                        AppUtility.sharedInstance.showAlertToastMesssageForSuccess(messageToUser: res_msg)
                                        self.clearAllTextFields()
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

extension UITextField {
    func setBottomBorder_setting() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

/*
 
 [Result]: SUCCESS: {
 responseCode = 0;
 responseMessage = "Old password is not matched";
 }
 
 if dictionaryArray.count > 0 {
 var res_code = 0
 var res_msg = ""
 for i in 0..<dictionaryArray.count{
 let Object = dictionaryArray[i]
 if let responseCode = Object["responseCode"] as? Int{
 res_code = responseCode
 }
 if let responseMessage = Object["msg"] as? Array<String>{
 res_msg = responseMessage[0]
 
 }else if let responseMessage = Object["responseMessage"] as? Array<String>{
 res_msg = responseMessage[0]
 }
 }
 if res_code == 1 {
 AppUtility.sharedInstance.showAlertToastMesssageForSuccess(messageToUser: res_msg)
 self.clearAllTextFields()
 }else{
 AppUtility.sharedInstance.showAlertToastMesssage(messageToUser: res_msg)
 }
 }
 
*/
