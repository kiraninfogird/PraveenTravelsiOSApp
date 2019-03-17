//
//  AppDelegate.swift
//  PravinTravels
//
//  Created by IIPL 5 on 05/12/18.
//  Copyright © 2018 IIPL 5. All rights reserved.
//com.IIPL.PravinTravels

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import FacebookLogin
import FacebookCore
import FacebookShare

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Reachability
        AppUtility.sharedInstance.initializeReachabilityCallbacks()
        
        //Keyboard setup
        IQKeyboardManager.sharedManager().enable = true
        
        // Navigation Bar button Attributes
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = Colors.whiteColor
        navigationBarAppearace.barTintColor = Colors.appThemeColor
        navigationBarAppearace.backgroundColor = Colors.appThemeColor
        
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor:Colors.whiteColor]
        
        // Status Bar Attributes
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = Colors.statusBarColor
        
        // FB Settings
//        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions, sourceApplication: <#String?#>, annotation: <#Any#>)
        
        if  UserDefaults.standard.value(forKey: Constant.LOGIN_USER_ID) != nil{
            self.goToHomeVC()
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    //MARK:- Instance Methods
    
    func goToHomeVC()  {
        let rootVC = self.window!.rootViewController as! UINavigationController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        rootVC.pushViewController(vc, animated: true)
    }
    
    //MARK:- Google/Facebook SignIn Methods
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("URL AbsoluteString = \(url.absoluteString)")
        if url.absoluteString.contains("com.googleusercontent.apps") {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            
        }
            /*
        else if url.absoluteString.contains("fb1279300242197274") {
            return SDKApplicationDelegate.shared.application(app,
                                                             open: url,
                                                             options: options)
            
        }
             */
        else {
            //return PDKClient.sharedInstance().handleCallbackURL(url)
            print("Error while open URL from app delegate in google or facebook sign in")
        }
        
        return true
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}


