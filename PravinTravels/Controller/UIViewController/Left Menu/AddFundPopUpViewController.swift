//
//  AddFundPopUpViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 13/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire
import PaymentSDK

protocol PaymentDoneDelegate {
    func refreshWalletBalance()
}

class AddFundPopUpViewController: UIViewController, PGTransactionDelegate {

    //MARK:- Variable Declarations
    
    @IBOutlet var mView: UIView!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var addFundButton: UIButton!
    var mDelegate: PaymentDoneDelegate?
    
    var login_user_details = [String : AnyObject]()
    var paytmPaymentDetails = [String : AnyObject]()
    var mTotalAmount = Double()
    var loginUserId = Int()
    var userEmail = ""
    var userMobile = ""
    
    var txControllerVC = PGTransactionViewController()
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFundButton.layer.cornerRadius = 0.1 *
            addFundButton.frame.size.height
        mView.layer.cornerRadius = 5.0
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        
        if let userId = UserDefaults.standard.value(forKey: Constant.LOGIN_USER_ID) as? Int{
            self.loginUserId = userId
            self.getMyProfileDetailsAPICall(parameters_uId: "\(userId)", parameters_updateId: "0", parameters_responseType: "2")
        }
    }
    
    //MARK:- PaytmSDK Delegate Methods
    
    //Called when transaction gets finished
    func didFinishedResponse(_ controller: PGTransactionViewController, response responseString: String) {
//        let msg : String = responseString
        var titlemsg : String = ""
        var txnId : String = ""
        var orderId : String = ""
        var mAmount : String = ""
        if let data = responseString.data(using: String.Encoding.utf8) {
            do {
                if let jsonresponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] , jsonresponse.count > 0{
                    titlemsg = jsonresponse["STATUS"] as? String ?? ""
                    txnId = jsonresponse["TXNID"] as? String ?? ""
                    orderId = jsonresponse["ORDERID"] as? String ?? ""
                    mAmount = jsonresponse["TXNAMOUNT"] as? String ?? "0"
                    if (titlemsg == "TXN_FAILURE"){
                        AppUtility.sharedInstance.showAlertToastMesssage(messageToUser: titlemsg)
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        let msgStr = "\n Transaction Id : \(txnId) \n Order Id : \(orderId)"
                        self.showPaymentSuccessAlert(msgToUser: msgStr, amount: mAmount, txnID: txnId, orderID: orderId)
                    }
                }
            } catch {
                print("Something went wrong, Please try again later....")
            }
        }
    }
    
    //Called when transaction gets cancelled
    func didCancelTrasaction(_ controller : PGTransactionViewController) {
        print("didCancelTrasaction: \(controller.description)")
        AppUtility.sharedInstance.showAlertToastMesssage(messageToUser: "Transaction Cancel.")
        controller.navigationController?.popViewController(animated: true)
    }
    
    //Called when a required parameter is missing.
    func errorMisssingParameter(_ controller : PGTransactionViewController, error : NSError?) {
        print("errorMisssingParameter: \(String(describing: error?.description))")
        controller.navigationController?.popViewController(animated: true)
    }
    
    func paytmPayment(mID: String, orderId:String, website: String, txnAmount: String, checkSumHash: String, callbackURL: String)  {
        let type :ServerType = .eServerTypeStaging
        let order = PGOrder(orderID: "", customerID: "", amount: "", eMail: "", mobile: "")
        order.params = ["MID": mID,
                        "ORDER_ID": orderId,
                        "CUST_ID": userEmail,
                        "MOBILE_NO": userMobile,
            "EMAIL": userEmail,
            "CHANNEL_ID": "WAP",
            "WEBSITE": website,
            "TXN_AMOUNT": txnAmount,
            "INDUSTRY_TYPE_ID": "Retail",
            "CHECKSUMHASH": checkSumHash,
            "CALLBACK_URL": callbackURL]
        self.txControllerVC =  (self.txControllerVC.initTransaction(for: order) as?PGTransactionViewController)!
        self.txControllerVC.title = "Paytm Payments"
        self.txControllerVC.setLoggingEnabled(true)
        if(type != ServerType.eServerTypeNone) {
            self.txControllerVC.serverType = type;
        } else {
            return
        }
        self.txControllerVC.merchant = PGMerchantConfiguration.defaultConfiguration()
        self.txControllerVC.delegate = self
        self.navigationController?.pushViewController(self.txControllerVC, animated: true)
    }
    
    //MARK:- Instance Methods
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    func showPaymentSuccessAlert(msgToUser: String, amount: String, txnID: String, orderID: String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Payment Successful...!" , message: msgToUser, preferredStyle: .alert)
        let cancelAction : UIAlertAction = UIAlertAction(title: "OK", style: .cancel) {
            action -> Void in
            //call API
            self.navigationController?.popViewController(animated: true)
            self.addCashAfterSuccessTransactionAPICall(parameters_uId: "\(self.loginUserId)", parameters_paidAmount: amount, parameters_transactionId: txnID, parameters_reference: orderID, parameters_UserIPAddress: Constant.USER_IP_ADDRESS, parameters_UserAgent: Constant.USER_AGENT, parameters_responseType: "2")
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    //MARK:- IBAction Methods

    @IBAction func actionOnCancelButton(_ sender: Any) {
        self.removeAnimate()
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    @IBAction func actinoOnAddFundButton(_ sender: Any) {
        let amount = amountTextField.text!
        if (amount == ""){
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please add some amount?")
        }else{
            //API Call
            self.addCCRCashAPICall(parameters_uId: "\(loginUserId)", parameters_paidAmount: "\(mTotalAmount)", parameters_transactionId: "", parameters_guestMailId: userEmail, parameters_guestMobileNumber: userMobile, parameters_responseType: "2")
        }
    }
    
    @IBAction func actionOnSegmentControl(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            mTotalAmount = mTotalAmount + 100
            amountTextField.text = "₹ \(mTotalAmount)"
        }else if segmentControl.selectedSegmentIndex == 1 {
            mTotalAmount = mTotalAmount + 200
            amountTextField.text = "₹ \(mTotalAmount)"
        }else{
            mTotalAmount = mTotalAmount + 300
            amountTextField.text = "₹ \(mTotalAmount)"
        }
    }
    
    //MARK:- Instance Methods
    
    func setUserDetails()  {
        if let email = login_user_details["email"] as? String{
            self.userEmail = email
            UserDefaults.standard.set(email, forKey: Constant.LOGIN_USER_EMAIL)
        }
        if let mobile = login_user_details["mobile"] as? String{
            self.userMobile = mobile
        }
    }
    
    func getPaymentDetails()  {
        var mMId = ""
        var mOrderId = ""
        var mWebsite = ""
        var mTxnAmount = ""
        var mCheckSumHash = ""
        var mCallbackURL = ""
        
        if let salt = paytmPaymentDetails["salt"] as? String{
            mMId = salt
        }
        if let reference = paytmPaymentDetails["reference"] as? String{
            mOrderId = reference
        }
        if let paytmwebsite = paytmPaymentDetails["paytmwebsite"] as? String{
            mWebsite = paytmwebsite
        }
        if let TXN_AMOUNT = paytmPaymentDetails["TXN_AMOUNT"] as? String{
            mTxnAmount = TXN_AMOUNT
        }
        if let CHECKSUMHASH = paytmPaymentDetails["CHECKSUMHASH"] as? String{
            mCheckSumHash = CHECKSUMHASH
        }
        if let CALLBACK_URL = paytmPaymentDetails["CALLBACK_URL"] as? String{
            mCallbackURL = CALLBACK_URL
        }
        
        self.paytmPayment(mID: mMId, orderId: mOrderId, website: mWebsite, txnAmount: mTxnAmount, checkSumHash: mCheckSumHash, callbackURL: mCallbackURL)
    }
    
    //MARK:- API CALL Methods
    
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
    
    func addCCRCashAPICall(parameters_uId: String, parameters_paidAmount: String, parameters_transactionId: String, parameters_guestMailId: String, parameters_guestMobileNumber: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.ADD_CASH_WALLET_BALANCE + "uId=\(parameters_uId)&paidAmount=\(parameters_paidAmount)&transactionId=\(parameters_transactionId)&guestMailId=\(parameters_guestMailId)&guestMobileNumber=\(parameters_guestMobileNumber)&responsetype=\(parameters_responseType)"
            
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
                                    if let responseCode = dictionaryArray["responseCode"] as? Int{
                                        if (responseCode == 1){
                                            self.paytmPaymentDetails = dictionaryArray as [String : AnyObject]
                                            self.getPaymentDetails()
                                        }else{
                                            if let responseMessage = dictionaryArray["responseMessage"] as? String{
                                            AppUtility.sharedInstance.showAlertToastMesssage(messageToUser: responseMessage)
                                            }
                                        }
                                        self.removeAnimate()
                                        self.navigationController?.navigationBar.isUserInteractionEnabled = true
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
    
    func addCashAfterSuccessTransactionAPICall(parameters_uId: String, parameters_paidAmount: String, parameters_transactionId: String, parameters_reference: String, parameters_UserIPAddress: String, parameters_UserAgent: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.ADD_CASH_WALLET_BALANCE + "uId=\(parameters_uId)&paidAmount=\(parameters_paidAmount)&transactionId=\(parameters_transactionId)&reference=\(parameters_reference)&UserIPAddress=\(parameters_UserIPAddress)&UserAgent=\(parameters_UserAgent)&responsetype=\(parameters_responseType)"
            
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
                                    if let responseCode = dictionaryArray["responseCode"] as? Int{
                                        if (responseCode == 1){
                                            //call delegate
                                            self.mDelegate?.refreshWalletBalance()
                                        }else{
                                            if let responseMessage = dictionaryArray["responseMessage"] as? String{
                                                AppUtility.sharedInstance.showAlertToastMesssage(messageToUser: responseMessage)
                                            }
                                        }
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
