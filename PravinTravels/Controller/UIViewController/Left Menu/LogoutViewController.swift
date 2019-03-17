//
//  LogoutViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 13/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import SCLAlertView
import FacebookLogin
import FacebookCore
import GoogleSignIn

class LogoutViewController: UIViewController, GIDSignInUIDelegate {
    
    //MARK:- Variable Declarations
    
    var socialLoginUsing = ""
    
    //MARK:- ViewController LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        if let loginUsing = UserDefaults.standard.value(forKey: Constant.LOGIN_WITH_GOOGLE_OR_FACEBOOK) as? String{
            self.socialLoginUsing = loginUsing
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        self.showAlertWith(title: "Alert", subTitle: "Do you want to Logout?")
    }
    
    //MARK:- Show Custom Alert View
    
    func showAlertWith(title: String, subTitle: String) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Logout"){
            if self.socialLoginUsing == "GOOGLE"{
                UserDefaults.standard.setValue(nil, forKey: Constant.LOGIN_WITH_GOOGLE_OR_FACEBOOK)
                GIDSignIn.sharedInstance().signOut()
            }
            else if self.socialLoginUsing == "FACEBOOK"{
                UserDefaults.standard.setValue(nil, forKey: Constant.LOGIN_WITH_GOOGLE_OR_FACEBOOK)
                let FBManager = LoginManager()
                FBManager.logOut()
            }
            
            UserDefaults.standard.setValue(nil, forKey: Constant.LOGIN_USER_ID)
            UserDefaults.standard.setValue(nil, forKey: Constant.LOGIN_USER_DETAILS)
            UserDefaults.standard.setValue(nil, forKey: Constant.LOGIN_USER_EMAIL)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alertView.addButton("Cancel") {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.present(vc, animated: true, completion: nil)
        }
        _ = alertView.showCustom(title, subTitle: subTitle, color: Colors.appThemeColor, icon: UIImage(named: "google_plus")!)
    }
    
}
