//
//  MyProfileViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 12/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire

class MyProfileViewController: UIViewController {
    
    //MARK:- Variable Declarations
    
    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var mobileTextField: UITextField!
    @IBOutlet var updateButton: UIButton!
    
    var login_user_details = [String : AnyObject]()
    var loginUserId = Int()
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        firstNameTF.setBottomBorder_profile()
        lastNameTextField.setBottomBorder_profile()
        emailTextField.setBottomBorder_profile()
        mobileTextField.setBottomBorder_profile()
        updateButton.layer.cornerRadius = 0.1 *
            updateButton.frame.size.height
        
        if let userId = UserDefaults.standard.value(forKey: Constant.LOGIN_USER_ID) as? Int{
            self.loginUserId = userId
            self.getMyProfileDetailsAPICall(parameters_uId: "\(userId)", parameters_updateId: "0", parameters_responseType: "2")
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
    
    @IBAction func actionOnUpdateProfileButton(_ sender: Any) {
        let firstName = firstNameTF.text!
        let lastName = lastNameTextField.text!
        let email = emailTextField.text!
        let mobile = mobileTextField.text!
        
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || mobile.isEmpty {
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Fields should not be empty, please fill all the fields...")
        }else{
            let isFirstNameValid = isValidName(firstName)
            if isFirstNameValid{
                let isLastNameValid = isValidName(lastName)
                if isLastNameValid{
                    let isEmailAddressValid = isValidEmailAddress(email)
                    if isEmailAddressValid{
                        let isMobileValid = isValidPhoneNumber(mobile)
                        if isMobileValid{
                            self.updateProfileDetailsAPICall(parameters_uId: "\(self.loginUserId)", parameters_firstName: firstName, parameters_lastName: lastName, parameters_email: email, parameters_mobile: mobile, parameters_updateId: "1", parameters_responseType: "2")
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
    
    //MARK:- Instance Methods
    
    func setUserDetails()  {
        if let firstName = login_user_details["firstName"] as? String{
            self.firstNameTF.text = firstName
        }
        if let lastName = login_user_details["lastName"] as? String{
            self.lastNameTextField.text = lastName
        }
        if let email = login_user_details["email"] as? String{
            self.emailTextField.text = email
            UserDefaults.standard.set(email, forKey: Constant.LOGIN_USER_EMAIL)
        }
        if let mobile = login_user_details["mobile"] as? String{
            self.mobileTextField.text = mobile
        }
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
        } catch let error as NSError {
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
        } catch let error as NSError {
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
    
    func getMyProfileDetailsAPICall(parameters_uId: String, parameters_updateId: String, parameters_responseType: String)  {
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.MY_PROFILE_DETAILS + "uId=\(parameters_uId)&updateId=\(parameters_updateId)&responsetype=\(parameters_responseType)"
            
            let escapedString = todosEndpoint.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            AppUtility.sharedInstance.showProgressIndicatorWith(message: "Processing...")
            
            Alamofire.request(escapedString!, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    AppUtility.sharedInstance.hideProgressIndicatorWith()
                    if let data = response.result.value{
                        if  let result = (data as? [String : AnyObject]){
                            if let dictionaryArray = result as? Dictionary<String, AnyObject?> {
                                if dictionaryArray.count > 0 {
                                    self.login_user_details = dictionaryArray as [String : AnyObject]
                                    self.setUserDetails()
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
    
    func updateProfileDetailsAPICall(parameters_uId: String, parameters_firstName: String, parameters_lastName: String, parameters_email: String, parameters_mobile: String, parameters_updateId: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.MY_PROFILE_DETAILS + "uId=\(parameters_uId)&firstName=\(parameters_firstName)&lastName=\(parameters_lastName)&email=\(parameters_email)&mobile=\(parameters_mobile)&updateId=\(parameters_updateId)&responsetype=\(parameters_responseType)"
            
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
extension MyProfileViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyProfileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func setBottomBorder_profile() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
