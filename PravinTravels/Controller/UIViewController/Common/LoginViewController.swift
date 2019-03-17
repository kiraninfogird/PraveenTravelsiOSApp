//
//  LoginViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 13/12/18.
//  Copyright © 2018 IIPL 5. All rights reserved.
//

import UIKit
import GoogleSignIn
import Alamofire

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    //MARK:- Variable Declarations
    
    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var passButton: UIButton!
    
    var userDeatilsObject = [[String : AnyObject]]()
    var userFullName = ""
    var userFirstName = ""
    var userLastName = ""
    var userEmail = ""
    var userMobile = ""
    var userGoogleLoginToken = ""
    var userGoogleId = ""
    
    //MARK:- ViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTF.setBottomBorderLogin()
        passwordTF.setBottomBorderLogin()
        //hideKeyboardWhenTappedAround()
        signInButton.layer.cornerRadius = 0.1 *
            signInButton.frame.size.height
        registerButton.layer.cornerRadius = 0.1 *
            registerButton.frame.size.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- IBActions Methods
    
    @IBAction func actionOnForgotPasswordButton(_ sender: Any) {
        self.view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordOneViewController") as! ForgotPasswordOneViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionOnSignInButton(_ sender: Any) {
        self.view.endEditing(true)
        let userName = userNameTF.text!
        let password = passwordTF.text!
        
        if userName.isEmpty || password.isEmpty{
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Fields should not be empty, Please fill all the fields...")
        }else{
            self.getLoginUserDetailsAPICall(parameters_email: userName, parameters_password: password, parameters_responsetype: "2")
        }
    }
    
    @IBAction func actionOnFacebookButton(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func actionOnGoogleButton(_ sender: Any) {
        self.view.endEditing(true)
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "262146695211-c9q1g8igg82t89lheiv6svmaruda07un.apps.googleusercontent.com" // Client-Id
        self.view.isUserInteractionEnabled = false
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func dontHaveAccountButton(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func actionOnRegisterButton(_ sender: Any) {
        self.view.endEditing(true)
        self.goToRegister()
    }
    
    @IBAction func actionOnPassButton(_ sender: Any) {
        if (passwordTF.isSecureTextEntry == true){
            passwordTF.isSecureTextEntry = false
            passButton.setImage(UIImage(named: "show_pass"), for: .normal)
        }else{
            passButton.setImage(UIImage(named: "hide_pass"), for: .normal)
            passwordTF.isSecureTextEntry = true
        }
    }
    
    // MARK:- Google SignIn Delegate Methods
    
    private func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        print("signInWillDispatch...")
    }
    
    // Present a view that prompts the user to sign in with Google
    private func signIn(signIn: GIDSignIn!,
                        presentViewController viewController: UIViewController!) {
        print("presentViewController...")
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    private func signIn(signIn: GIDSignIn!,
                        dismissViewController viewController: UIViewController!) {
        print("dismissViewController...")
        self.view.isUserInteractionEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let imageURL = user.profile.imageURL(withDimension: 150)

            if let mFullName = fullName{
                self.userFullName = mFullName
            }
            if let mFirstName = givenName{
                self.userFirstName = mFirstName
            }
            if let mLastName = familyName{
                self.userLastName = mLastName
            }
            if let mEmail = email{
                self.userEmail = mEmail
            }
            if let mToken = idToken{
                self.userGoogleLoginToken = mToken
            }
            if let mUserId = userId{
                self.userGoogleId = mUserId
            }
            
            print("userId: \(String(describing: userId)) \n idToken: \(String(describing: idToken)) \n givenName: \(String(describing: givenName)) \n familyName: \(String(describing: familyName)) \n userEmail: \(String(describing: email)) \n imageURL: \(String(describing: imageURL)) \n fullName: \(String(describing: fullName))")
            
            UserDefaults.standard.set("GOOGLE", forKey:Constant.LOGIN_WITH_GOOGLE_OR_FACEBOOK)
            self.view.isUserInteractionEnabled = true
//            self.goToHome()
        }else {
            self.view.isUserInteractionEnabled = true
            print("Error while doing google sign: \(error.localizedDescription)")
        }
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                        withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
    
//    MARK:- Instance Methods
    
    func goToHome() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func goToRegister() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- API CALL Methods
    
    func getLoginUserDetailsAPICall(parameters_email: String, parameters_password: String, parameters_responsetype: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            let todosEndpoint: String = Constant.BASE_URL + Constant.SIGN_IN + "email=\(parameters_email)&password=\(parameters_password)&responsetype=\(parameters_responsetype)"
            
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
                                    if let email = dictionaryArray["email"] as? String{
                                        UserDefaults.standard.set(email, forKey: Constant.LOGIN_USER_EMAIL)
                                    }
                                    if let responseMessage = dictionaryArray["responseMessage"] as? String{
                                        res_msg = responseMessage
                                    }
                                    if let uId = dictionaryArray["uId"] as? Int{
                                        if uId != 0{
                                            UserDefaults.standard.set(uId, forKey: Constant.LOGIN_USER_ID)
                                        }
                                    }
                                    if res_code == 1 {
                                        if let object = data as? [[String : AnyObject]]{
                                            // save loginUserDetails in UserDefaults
                                            self.userDeatilsObject =  object
                                            UserDefaults.standard.set(self.userDeatilsObject, forKey: Constant.LOGIN_USER_DETAILS)
                                        }
                                        self.goToHome()
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

extension LoginViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func setBottomBorderLogin() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = UITextBorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
