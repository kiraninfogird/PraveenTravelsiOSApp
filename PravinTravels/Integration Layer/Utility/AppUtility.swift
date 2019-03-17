//
//  AppUtility.swift
//  PravinTravels
//
//  Created by IIPL 5 on 15/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import Reachability
import SCLAlertView
import SVProgressHUD
import Toaster

class AppUtility: NSObject {
    
    //declare this property where it won't go out of scope relative to your listener
    var mIsNetworkAvailable = false
    let reachability = Reachability()!
    var mIsCityListActive = true
    var isPaymentDone = false
    var isCCRCashAddDone = false

    //MARK:- Singleton
    
    static var instance: AppUtility? = nil
    class var sharedInstance: AppUtility {
        if instance == nil {
            self.instance = AppUtility()
        }
        return self.instance!
    }
    
    //MARK:- Reachability Utility
    
    func initializeReachabilityCallbacks() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            mIsNetworkAvailable = true
        case .cellular:
            print("Reachable via Cellular")
            mIsNetworkAvailable = true
        case .none:
            print("Network not reachable")
            mIsNetworkAvailable = false
        }
    }
    
    /*
    @objc func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi network")
            } else {
                print("Reachable via Cellular network")
            }
            mIsNetworkAvailable = true
        } else {
            print("Network not reachable")
            mIsNetworkAvailable = false
        }
    }
 */
    
    //MARK:- Show alert message
    
    func showAlertWith(title: String, subTitle: String) {
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        _ = alertView.showCustom(title, subTitle: subTitle, color: Colors.appThemeColor, icon: UIImage(named: "logo")!)
    }
    
    func showAlertWithoutIcon(title: String, subTitle: String) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Ok"){
        }
        
        _ = alertView.showCustom(title, subTitle: subTitle, color: Colors.appThemeColor, icon: UIImage(named: "logo")!)
    }
    
    //MARK:- Show Progress Indicator
    
    func showProgressIndicatorWith(message: String) {
        DispatchQueue.main.async(execute: {
            SVProgressHUD.setForegroundColor(UIColor.darkGray) //Colors.appThemeColor
            SVProgressHUD.setBackgroundColor(UIColor.white)
            SVProgressHUD.setMaximumDismissTimeInterval(20.0)
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.show(withStatus: message)
            SVProgressHUD.dismiss(withDelay: 25) // dissmiss svprogress after specific time
        })
    }
    
    func hideProgressIndicatorWith() {
        DispatchQueue.main.async(execute: {
            SVProgressHUD.dismiss()
        })
    }
    
    
    //MARK:- Show alert toast message
    
    func showAlertToastMesssage(messageToUser: String)  {
        DispatchQueue.main.async(execute: {
            let mToast = Toast(text: messageToUser)
            mToast.view.backgroundColor = Colors.toastMessageThemeColor //UIColor.darkGray
            mToast.view.layer.cornerRadius = 05
            mToast.view.textColor = UIColor.white
            mToast.duration = Delay.long
            mToast.view.font = UIFont.systemFont(ofSize: 16)
            mToast.show()
        })
    }
    
    func showAlertToastMesssageForSuccess(messageToUser: String)  {
        DispatchQueue.main.async(execute: {
            let mToast = Toast(text: messageToUser)
            mToast.view.backgroundColor = Colors.toastMessageLightGrayThemeColor
            mToast.view.layer.cornerRadius = 05
            mToast.view.textColor = UIColor.white
            mToast.duration = Delay.long
            mToast.view.font = UIFont.systemFont(ofSize: 16)
            mToast.show()
        })
    }
    
}
