//
//  ViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 05/12/18.
//  Copyright © 2018 IIPL 5. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {
    
    //MARK:- Variable Declaration
    
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var registerBtn: UIButton!
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        signInBtn.layer.cornerRadius = 0.1 *
            signInBtn.frame.size.height
        registerBtn.layer.cornerRadius = 0.1 *
            registerBtn.frame.size.height
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnSignInButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionOnRegisterButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

