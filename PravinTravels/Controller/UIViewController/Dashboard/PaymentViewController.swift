//
//  PaymentViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 03/02/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire
import PaymentSDK

class PaymentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PGTransactionDelegate {
    
    //MARK:- Variable Declarations
    
    @IBOutlet var mTableView: UITableView!
    var loginUserDetails = [String : AnyObject]()
    var bookingPaymentDetails = [String : AnyObject]()
    var loginUserId = Int()
    var isProfile = false
    var mUDID = ""
    
    var total_Amount = Double()
    var advance_Amt = Double()
    var basic_Amount = Double()
    var serviceTax_Amount = Double()
    var balance_Amount = Double()
    
    var isPaymentModeFull = true
    var userCCRCashWalletBalance = Int()
    
    var txControllerVC = PGTransactionViewController()
    
    // API Parameters
    var mRefrenceNo = ""
    var mCvcName = ""
    var mDealId = Int()
    var mFinalTotalAmt = Double()
    var mUserName = ""
    var mUserMobileNo = ""
    var mUserMailId = ""
    var mUserAddress = ""
    var mAgentCode = ""
    var mCountryName = "India"
    var couponCode = ""
    var mCouponId = ""
    var mCouponValue = ""
    var mCType = ""
    var mAbcType = ""
    var mUserPaymentMode = ""
    var mUserTripType = ""
    var mUserTripRoot = ""
    var mDay = ""
    var mCars = ""
    var mUserVehicleName = ""
    var mUserVehiclePickupTime = ""
    var mUserTravelDate = ""
    var mUserTravelEndDate = ""
    var mUserPickupCity = ""
    var mUserDropCity = ""
    var mUserPickupLocation = ""
    var mUserDropLocation = ""
    var mUserPackageName = ""
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Confirm Booking"
        if let userId = UserDefaults.standard.value(forKey: Constant.LOGIN_USER_ID) as? Int{
            self.loginUserId = userId
            if mCvcName == "Deal"{
                self.initialSetupForCouponView()
            }
            self.getMyProfileDetailsAPICall(parameters_uId: "\(userId)", parameters_updateId: "0", parameters_responseType: "2")
            self.getCCRCashWalletBalanceDetailsAPICall(parameters_uId: "\(userId)", parameters_responseType: "2")
            self.getUDID()
        }
    }
    
    //MARK:- TableView DataSource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell")! as! PaymentTableViewCell
        
        if (isProfile){
            if let firstName = loginUserDetails["firstName"] as? String{
                if let lastName = loginUserDetails["lastName"] as? String{
                    cell.nameTF.text = firstName + " " + lastName
                }
            }
            if let email = loginUserDetails["email"] as? String{
                cell.emailTF.text = email
                UserDefaults.standard.set(email, forKey: Constant.LOGIN_USER_EMAIL)
            }
            if let mobile = loginUserDetails["mobile"] as? String{
                cell.mobileTF.text = mobile
            }
        }
        
        cell.carNameLabel.text = mUserVehicleName
        cell.basicAmtLabel.text = "₹ \(basic_Amount)"
        cell.serviceTaxLabel.text = "₹ \(serviceTax_Amount)"
        cell.totalAmtLabel.text = "₹ \(total_Amount)"
        cell.advAmtLabel.text = "₹ \(advance_Amt)"
        cell.balAmountLabel.text = "₹ \(balance_Amount)"
        if (isPaymentModeFull){
            mFinalTotalAmt = total_Amount
            cell.payAmountButton.setTitle("₹ \(total_Amount)", for: .normal)
        }else{
            mFinalTotalAmt = advance_Amt
            cell.payAmountButton.setTitle("₹ \(advance_Amt)", for: .normal)
        }
        
        // make cell2.payAmountButton Label dashed line
        let mViewBorder2 = CAShapeLayer()
        mViewBorder2.strokeColor = UIColor.blue.cgColor
        mViewBorder2.lineDashPattern = [2, 2]
        mViewBorder2.frame = cell.payAmountButton.bounds
        mViewBorder2.fillColor = nil
        mViewBorder2.path = UIBezierPath(rect: cell.payAmountButton.bounds).cgPath
        cell.payAmountButton.layer.addSublayer(mViewBorder2)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 680
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
                        "CUST_ID": mUserMailId,
                        "MOBILE_NO": mUserMobileNo,
                        "EMAIL": mUserMailId,
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
    
    func showPaymentSuccessAlert(msgToUser: String, amount: String, txnID: String, orderID: String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Payment Successful...!" , message: msgToUser, preferredStyle: .alert)
        let cancelAction : UIAlertAction = UIAlertAction(title: "OK", style: .cancel) {
            action -> Void in
            //call API
            self.navigationController?.popViewController(animated: true)
            self.bookingConfirmAPICall(parameters_reference: orderID, parameters_transactionId: txnID, parameters_paidAmount: "\(amount)", parameters_paymentMode: self.mUserPaymentMode, parameters_uId: "\(self.loginUserId)", parameters_apiKey: Constant.API_KEY, parameters_userIpAddress: Constant.USER_IP_ADDRESS, parameters_userId: Constant.USER_ID, parameters_userAgent: Constant.USER_AGENT, parameters_responseType: "2")
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnApplyCodeButton(_ sender: Any) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = mTableView.cellForRow(at: indexPath) as! PaymentTableViewCell
        if (cell.couponCodeTextField.text == ""){
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please enter valid coupon code?")
        }else{
            couponCode = cell.couponCodeTextField.text!
            print("couponCode: \(couponCode)")
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please enter valid coupon code?")
            /*
             self.applyCouponCodeAPICall(parameters_uId: "\(self.loginUserId)", parameters_couponCode: couponCode, parameters_appliedfor: "1", parameters_deviceimei: mUDID, parameters_basicAmount: "\(self.mBasicAmt)", parameters_fromCity: mFromCity, parameters_toCity: mToCity, parameters_startDate: mStartDate, parameters_endDate: mEndDate, parameters_cars: mTotal_car, parameters_login_state: "1", parameters_tripType: mTripType, parameters_apiKey: Constant.API_KEY, parameters_userIpAddress: Constant.USER_IP_ADDRESS, parameters_userId: Constant.USER_ID, parameters_userAgent: Constant.USER_AGENT, parameters_responseType: "2")
             */
        }
        cell.couponCodeSucessMsgLabel.text = ""
    }
    
    @IBAction func actionOnCreditDebitCardButton(_ sender: Any) {
        mUserPaymentMode = "6"
        self.checkFinalValidation()
    }
    
    @IBAction func actionOnCashWalletButton(_ sender: Any) {
        mUserPaymentMode = "7"
        self.checkFinalValidation()
    }
    
    // MARK:- Instance Methods
    
    func checkFinalValidation()  {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = mTableView.cellForRow(at: indexPath) as! PaymentTableViewCell
        
        let isNameValid = isValidName(cell.nameTF.text!)
        let isEmailAddressValid = isValidEmailAddress(cell.emailTF.text!)
        let isMobileValid = isValidPhoneNumber(cell.mobileTF.text!)
        let isAddressValid = isValidName(cell.addressTF.text!)
        if (isNameValid){
            if (isEmailAddressValid){
                if (isMobileValid){
                    if (isAddressValid){
                        mUserName = cell.nameTF.text!
                        mUserMailId = cell.emailTF.text!
                        mUserMobileNo = cell.mobileTF.text!
                        mUserAddress = cell.addressTF.text!
                        if (self.mUserPaymentMode == "7"){
                            if self.mFinalTotalAmt <= Double(self.userCCRCashWalletBalance){
                                self.showAlertMessageToUser(message: "Do you want to confirm pay from wallet for booking?")
                                cell.creditCardImageView.image = UIImage(named: "circle")
                                cell.walletImageView.image = UIImage(named: "circle_fill")
                            }else{
                                AppUtility.sharedInstance.showAlertToastMesssage(messageToUser: "You have insufficient cash wallet balance?")
                            }
                        }else{
                            cell.walletImageView.image = UIImage(named: "circle")
                            cell.creditCardImageView.image = UIImage(named: "circle_fill")
                            self.showAlertMessageToUser(message: "Do you want to confirm pay for booking?")
                        }
                    }else{
                        AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please enter valid address?")
                    }
                }else{
                    AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please enter valid mobile number?")
                }
            }else{
                AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please enter valid email?")
            }
        }else{
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please enter name?")
        }
    }
    
    func getPaymentDetails()  {
        var mMId = ""
        var mOrderId = ""
        var mWebsite = ""
        var mTxnAmount = ""
        var mCheckSumHash = ""
        var mCallbackURL = ""
        
        if let salt = bookingPaymentDetails["salt"] as? String{
            mMId = salt
        }
        if let reference = bookingPaymentDetails["reference"] as? String{
            mOrderId = reference
        }
        if let paytmwebsite = bookingPaymentDetails["paytmwebsite"] as? String{
            mWebsite = paytmwebsite
        }
        if let TXN_AMOUNT = bookingPaymentDetails["TXN_AMOUNT"] as? String{
            mTxnAmount = TXN_AMOUNT
        }
        if let CHECKSUMHASH = bookingPaymentDetails["CHECKSUMHASH"] as? String{
            mCheckSumHash = CHECKSUMHASH
        }
        if let CALLBACK_URL = bookingPaymentDetails["CALLBACK_URL"] as? String{
            mCallbackURL = CALLBACK_URL
        }
        
        self.paytmPayment(mID: mMId, orderId: mOrderId, website: mWebsite, txnAmount: mTxnAmount, checkSumHash: mCheckSumHash, callbackURL: mCallbackURL)
    }
    
    func showAlertMessageToUser(message: String)  {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("Ok button click...")
            self.callToAPI()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel button click...")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getUDID() {
        let currentIphoneUUID = UUID().uuidString
        self.mUDID = currentIphoneUUID
    }
    
    func initialSetupForCouponView()  {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = mTableView.cellForRow(at: indexPath) as! PaymentTableViewCell
        
        cell.couponView.isHidden = true
        cell.couponViewLabel.isHidden = true
        cell.couponViewHeightConstraint.constant = 0.0
    }
    
    func callToAPI()  {
        if mCvcName == "Local" || mCvcName == "Outstation" {
            self.bookingRequestForLocalAndOutstationAPICall(parameters_uId: "\(self.loginUserId)", parameters_guestName: mUserName, parameters_guestMobileNo: mUserMobileNo, parameters_guestMailId: mUserMailId, parameters_guestCountry: mCountryName, parameters_pickupCity: mUserPickupCity, parameters_DropCity: mUserDropCity, parameters_pickUpaddress: mUserAddress, parameters_travelDate: mUserTravelDate, parameters_pickupTime: mUserVehiclePickupTime, parameters_vehicleName: mUserVehicleName, parameters_cars: mCars, parameters_days: mDay, parameters_tripType: mUserTripType, parameters_tripRoot: mUserTripRoot, parameters_paidAmount: "\(self.mFinalTotalAmt)", parameters_paymentMode: mUserPaymentMode, parameters_couponId: mCouponId, parameters_couponValue: mCouponValue, parameters_ctype: mCType, parameters_agentCode: mAgentCode, parameters_apiKey:Constant.API_KEY, parameters_userIpAddress: Constant.USER_IP_ADDRESS, parameters_guestCity: mUserPickupCity, parameters_userAgent: Constant.USER_AGENT, parameters_responseType: "2")
        }
        else if mCvcName == "Transfer" {
            self.bookingRequestForTransferAPICall(parameters_uId: "\(self.loginUserId)", parameters_guestName: mUserName, parameters_guestMobileNo: mUserMobileNo, parameters_guestMailId: mUserMailId, parameters_guestCountry: mCountryName, parameters_pickupCity: mUserPickupCity, parameters_pickUpaddress: mUserAddress, parameters_pickUpLocation: mUserPickupLocation, parameters_dropLocation: mUserDropLocation, parameters_travelDate: mUserTravelDate, parameters_pickupTime: mUserVehiclePickupTime, parameters_vehicleName: mUserVehicleName, parameters_cars: mCars, parameters_days: mDay, parameters_tripType: mUserTripType, parameters_tripRoot: mUserTripRoot, parameters_paidAmount: "\(self.mFinalTotalAmt)", parameters_paymentMode: mUserPaymentMode, parameters_couponId: mCouponId, parameters_couponValue: mCouponValue, parameters_ctype: mCType, parameters_agentCode: mAgentCode, parameters_userIpAddress: Constant.USER_IP_ADDRESS, parameters_guestCity: mUserPickupCity, parameters_userAgent: Constant.USER_AGENT, parameters_responseType: "2")
        } else{
            
        self.oneWayDealBookingRequestAPICall(parameters_uniqueRefNo: "\(self.loginUserId)", parameters_dealId: "\(self.mDealId)", parameters_guestName: mUserName, parameters_guestMobileNo: mUserMobileNo, parameters_guestMailId: mUserMailId, parameters_guestCountry: mCountryName, parameters_pickupCity: mUserPickupCity, parameters_dropCity: mUserDropCity, parameters_pickUpaddress: mUserAddress, parameters_travelDate: mUserTravelDate, parameters_pickupTime: mUserVehiclePickupTime, parameters_vehicleName: mUserVehicleName, parameters_cars: "1", parameters_days: "1", parameters_tripType: mUserTripType, parameters_tripRoot: mUserTripRoot, parameters_paidAmount: "\(self.mFinalTotalAmt)", parameters_paymentMode: mUserPaymentMode, parameters_agentCode: mAgentCode, parameters_UserID: Constant.USER_ID, parameters_UserIPAddress: Constant.USER_IP_ADDRESS, parameters_UserAgent: Constant.USER_AGENT, parameters_guestCity: mUserPickupCity, parameters_couponId: "", parameters_ctype: "", parameters_responsetype: "2")
        }
    }
    
    func moveToBookingDetailsVC()  {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func generateTransactionId(length: Int) -> String {
        var code = ""
        let base62chars = [Character]("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".characters)
        let maxBase : UInt32 = 62
        let minBase : UInt16 = 32
        
        for _ in 0..<length {
            let random = Int(arc4random_uniform(UInt32(min(minBase, UInt16(maxBase)))))
            code.append(base62chars[random])
        }
        return code
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
                                    self.loginUserDetails = dictionaryArray as [String : AnyObject]
                                    self.isProfile = true
                                    self.mTableView.reloadData()
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
    
    func getCCRCashWalletBalanceDetailsAPICall(parameters_uId: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.GET_CCR_CASH_WALLET_BALANCE + "uId=\(parameters_uId)&responsetype=\(parameters_responseType)"
            
            let escapedString = todosEndpoint.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            AppUtility.sharedInstance.showProgressIndicatorWith(message: "Processing...")
            
            Alamofire.request(escapedString!, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    
                    AppUtility.sharedInstance.hideProgressIndicatorWith()
                    if let data = response.result.value{
                        if  let result = (data as? [String : AnyObject])?["result"]{
                            if let dictionaryArray = result as? Array<Dictionary<String, AnyObject?>> {
                                if dictionaryArray.count > 0 {
                                    let Object = dictionaryArray[0]
                                    if let balance = Object["balance"] as? Int{
                                        self.userCCRCashWalletBalance = balance
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
    
    // LOCAL and OUTSTATION
    func bookingRequestForLocalAndOutstationAPICall(parameters_uId: String, parameters_guestName: String, parameters_guestMobileNo: String, parameters_guestMailId: String, parameters_guestCountry: String, parameters_pickupCity: String, parameters_DropCity: String, parameters_pickUpaddress: String, parameters_travelDate: String, parameters_pickupTime: String,parameters_vehicleName: String, parameters_cars: String, parameters_days: String, parameters_tripType: String, parameters_tripRoot: String, parameters_paidAmount: String, parameters_paymentMode: String, parameters_couponId: String, parameters_couponValue: String,parameters_ctype: String, parameters_agentCode: String, parameters_apiKey: String, parameters_userIpAddress: String, parameters_guestCity: String, parameters_userAgent: String, parameters_responseType: String)  {
        
        var todosEndpoint: String = ""
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            if mCvcName == "Local"{
                todosEndpoint = Constant.BASE_URL + Constant.BOOKING_REQUEST_NEW + "uniqueRefNo=\(parameters_uId)&guestName=\(parameters_guestName)&guestMobileNo=\(parameters_guestMobileNo)&guestMailId=\(parameters_guestMailId)&guestCountry=\(parameters_guestCountry)&pickupCity=\(parameters_pickupCity)&dropCity=\(parameters_pickupCity)&pickUpaddress=\(parameters_pickUpaddress)&travelDate=\(parameters_travelDate)&pickupTime=\(parameters_pickupTime)&vehicleName=\(parameters_vehicleName)&cars=\(parameters_cars)&days=\(parameters_days)&tripType=\(parameters_tripType)&tripRoot=\(parameters_tripRoot)&paidAmount=\(parameters_paidAmount)&paymentMode=\(parameters_paymentMode)&couponId=\(parameters_couponId)&couponValue=\(parameters_couponValue)&ctype=\(parameters_ctype)&agentCode=\(parameters_agentCode)&ApiKey=\(parameters_apiKey)&UserIPAddress=\(parameters_userIpAddress)&guestCity=\(parameters_guestCity)&UserAgent=\(parameters_userAgent)&responsetype=\(parameters_responseType)"
                
            }else{
                todosEndpoint = Constant.BASE_URL + Constant.BOOKING_REQUEST_NEW + "uniqueRefNo=\(parameters_uId)&guestName=\(parameters_guestName)&guestMobileNo=\(parameters_guestMobileNo)&guestMailId=\(parameters_guestMailId)&guestCountry=\(parameters_guestCountry)&pickupCity=\(parameters_pickupCity)&dropCity=\(parameters_DropCity)&pickUpaddress=\(parameters_pickUpaddress)&travelDate=\(parameters_travelDate)&pickupTime=\(parameters_pickupTime)&vehicleName=\(parameters_vehicleName)&cars=\(parameters_cars)&days=\(parameters_days)&tripType=\(parameters_tripType)&tripRoot=\(parameters_tripRoot)&paidAmount=\(parameters_paidAmount)&paymentMode=\(parameters_paymentMode)&couponId=\(parameters_couponId)&couponValue=\(parameters_couponValue)&ctype=\(parameters_ctype)&agentCode=\(parameters_agentCode)&UserIPAddress=\(parameters_userIpAddress)&guestCity=\(parameters_guestCity)&UserAgent=\(parameters_userAgent)&responsetype=\(parameters_responseType)"
            }
            
            let escapedString = todosEndpoint.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            AppUtility.sharedInstance.showProgressIndicatorWith(message: "Processing...")
            
            Alamofire.request(escapedString!, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    
                    AppUtility.sharedInstance.hideProgressIndicatorWith()
                    if let data = response.result.value{
                        if  (data as? [String : AnyObject]) != nil{
                            if let dictionaryArray = data as? Dictionary<String, AnyObject?> {
                                var referenceId = ""
                                if dictionaryArray.count > 0 {
                                    if (self.mUserPaymentMode == "6"){
                                        self.bookingPaymentDetails =  dictionaryArray as [String : AnyObject]
                                        self.getPaymentDetails()
                                    }else{
                                        if let reference = dictionaryArray["reference"] as? String{
                                            referenceId = reference
                                        }
                                        let txnId = self.generateTransactionId(length: 11)
                                        self.bookingConfirmAPICall(parameters_reference: referenceId, parameters_transactionId: txnId, parameters_paidAmount: "\(self.mFinalTotalAmt)", parameters_paymentMode: self.mUserPaymentMode, parameters_uId: "\(self.loginUserId)", parameters_apiKey: Constant.API_KEY, parameters_userIpAddress: Constant.USER_IP_ADDRESS, parameters_userId: Constant.USER_ID, parameters_userAgent: Constant.USER_AGENT, parameters_responseType: "2")
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
    
    // TRANSFER
    func bookingRequestForTransferAPICall(parameters_uId: String, parameters_guestName: String, parameters_guestMobileNo: String, parameters_guestMailId: String, parameters_guestCountry: String, parameters_pickupCity: String, parameters_pickUpaddress: String,parameters_pickUpLocation: String, parameters_dropLocation: String, parameters_travelDate: String, parameters_pickupTime: String,parameters_vehicleName: String, parameters_cars: String, parameters_days: String, parameters_tripType: String, parameters_tripRoot: String, parameters_paidAmount: String, parameters_paymentMode: String, parameters_couponId: String, parameters_couponValue: String,parameters_ctype: String, parameters_agentCode: String, parameters_userIpAddress: String, parameters_guestCity: String, parameters_userAgent: String, parameters_responseType: String)  {
        
        var todosEndpoint: String = ""
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            todosEndpoint = Constant.BASE_URL + Constant.BOOKING_REQUEST_NEW + "uniqueRefNo=\(parameters_uId)&guestName=\(parameters_guestName)&guestMobileNo=\(parameters_guestMobileNo)&guestMailId=\(parameters_guestMailId)&guestCountry=\(parameters_guestCountry)&pickupCity=\(parameters_pickupCity)&pickUpaddress=\(parameters_pickUpaddress)&pickUpLocation=\(parameters_pickUpLocation)&dropLocation=\(parameters_dropLocation)&travelDate=\(parameters_travelDate)&pickupTime=\(parameters_pickupTime)&vehicleName=\(parameters_vehicleName)&cars=\(parameters_cars)&days=\(parameters_days)&tripType=\(parameters_tripType)&tripRoot=\(parameters_tripRoot)&paidAmount=\(parameters_paidAmount)&paymentMode=\(parameters_paymentMode)&couponId=\(parameters_couponId)&couponValue=\(parameters_couponValue)&ctype=\(parameters_ctype)&agentCode=\(parameters_agentCode)&UserIPAddress=\(parameters_userIpAddress)&guestCity=\(parameters_guestCity)&UserAgent=\(parameters_userAgent)&responsetype=\(parameters_responseType)"
            
            let escapedString = todosEndpoint.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            AppUtility.sharedInstance.showProgressIndicatorWith(message: "Processing...")
            
            Alamofire.request(escapedString!, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    
                    AppUtility.sharedInstance.hideProgressIndicatorWith()
                    if let data = response.result.value{
                        if  (data as? [String : AnyObject]) != nil{
                            if let dictionaryArray = data as? Dictionary<String, AnyObject?> {
                                var referenceId = ""
                                if dictionaryArray.count > 0 {
                                    if (self.mUserPaymentMode == "6"){
                                        self.bookingPaymentDetails =  dictionaryArray as [String : AnyObject]
                                        self.getPaymentDetails()
                                    }else{
                                        if let reference = dictionaryArray["reference"] as? String{
                                            referenceId = reference
                                        }
                                        let txnId = self.generateTransactionId(length: 11)
                                        self.bookingConfirmAPICall(parameters_reference: referenceId, parameters_transactionId: txnId, parameters_paidAmount: "\(self.mFinalTotalAmt)", parameters_paymentMode: self.mUserPaymentMode, parameters_uId: "\(self.loginUserId)", parameters_apiKey: Constant.API_KEY, parameters_userIpAddress: Constant.USER_IP_ADDRESS, parameters_userId: Constant.USER_ID, parameters_userAgent: Constant.USER_AGENT, parameters_responseType: "2")
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
    
    func bookingConfirmAPICall(parameters_reference: String, parameters_transactionId: String, parameters_paidAmount: String, parameters_paymentMode: String, parameters_uId: String, parameters_apiKey: String, parameters_userIpAddress: String, parameters_userId: String, parameters_userAgent: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.BOOKING_CONFIRM_NEW + "reference=\(parameters_reference)&transactionId=\(parameters_transactionId)&paidAmount=\(parameters_paidAmount)&paymentMode=\(parameters_paymentMode)&uId=\(parameters_uId)&ApiKey=\(parameters_apiKey)&UserIPAddress=\(parameters_userIpAddress)&UserID=\(parameters_userId)&UserAgent=\(parameters_userAgent)&responsetype=\(parameters_responseType)"
            
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
                                    var resMsg = ""
                                    if let responseCode = dictionaryArray["responseCode"] as? Int{
                                        if let responseMessage = dictionaryArray["responseMessage"] as? String{
                                            resMsg = responseMessage
                                        }
                                        if (responseCode == 1){
                                            self.moveToBookingDetailsVC()
                                            AppUtility.sharedInstance.showAlertToastMesssageForSuccess(messageToUser: resMsg)
                                        }else{
                                            AppUtility.sharedInstance.showAlertToastMesssage(messageToUser: resMsg)
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
    
    func applyCouponCodeAPICall(parameters_uId: String, parameters_couponCode: String, parameters_appliedfor: String, parameters_deviceimei: String, parameters_basicAmount: String, parameters_fromCity: String, parameters_toCity: String, parameters_startDate: String, parameters_endDate: String, parameters_cars: String,parameters_login_state: String, parameters_tripType: String, parameters_apiKey: String, parameters_userIpAddress: String, parameters_userId: String, parameters_userAgent: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.COUPON_CODE + "userId=\(parameters_uId)&couponCode=\(parameters_couponCode)&appliedfor=\(parameters_appliedfor)&deviceimei=\(parameters_deviceimei)&basicAmount=\(parameters_basicAmount)&fromCity=\(parameters_fromCity)&toCity=\(parameters_toCity)&startDate=\(parameters_startDate)&endDate=\(parameters_endDate)&cars=\(parameters_cars)&login_state=\(parameters_login_state)&tripType=\(parameters_tripType)&ApiKey=\(parameters_apiKey)&UserIPAddress=\(parameters_userIpAddress)&UserID=\(parameters_userId)&UserAgent=\(parameters_userAgent)&responsetype=\(parameters_responseType)"
            
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
                                        if let responseMessage = Object["msg"] as? Array<String>{
                                            res_msg = responseMessage[0]
                                        }
                                        if let couponValue = Object["couponValue"] as? String{
                                            self.mCouponValue = couponValue
                                        }
                                        if let couponID = Object["couponId"] as? String{
                                            self.mCouponId = couponID
                                        }
                                        if let ctype = Object["ctype"] as? String{
                                            self.mCType = ctype
                                        }else if let ctype2 = Object["ctype"] as? Int{
                                            self.mCType = "\(ctype2)"
                                        }
                                        if let abcId = Object["abcId"] as? String{
                                            self.mAbcType = abcId
                                        }else if let abcId2 = Object["abcId"] as? Int{
                                            self.mAbcType = "\(abcId2)"
                                        }
                                    }
                                    /*
                                     if res_code == 1 {
                                     AppUtility.sharedInstance.showAlertToastMesssageForSuccess(messageToUser: res_msg)
                                     self.setNewValuesAfterApplyCouponCode()
                                     self.mCouponMessageLabel.isHidden = false
                                     self.mApplyCouponCodeButton.setTitle("Remove Code", for: .normal)
                                     self.mCouponMessageLabel.text = "You got discount of ₹ " + self.mCoupon_value + "/-"
                                     self.mCouponMessageLabel.textColor = Colors.toastMessageLightGrayThemeColor
                                     self.isCouponApply = true
                                     }else{
                                     AppUtility.sharedInstance.showAlertToastMesssage(messageToUser: res_msg)
                                     self.mCouponMessageLabel.isHidden = false
                                     self.mApplyCouponCodeButton.setTitle("Apply Coupon Code", for: .normal)
                                     self.mCouponMessageLabel.text = "Invalid coupon code."
                                     self.mCouponMessageLabel.textColor = UIColor.red
                                     }
                                     */
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
    
    //DEAL
    func oneWayDealBookingRequestAPICall(parameters_uniqueRefNo: String, parameters_dealId: String, parameters_guestName: String, parameters_guestMobileNo: String, parameters_guestMailId: String, parameters_guestCountry: String, parameters_pickupCity: String, parameters_dropCity: String,parameters_pickUpaddress: String, parameters_travelDate: String, parameters_pickupTime: String, parameters_vehicleName: String, parameters_cars: String, parameters_days: String, parameters_tripType: String, parameters_tripRoot: String, parameters_paidAmount: String, parameters_paymentMode: String, parameters_agentCode: String, parameters_UserID: String, parameters_UserIPAddress: String, parameters_UserAgent: String, parameters_guestCity: String, parameters_couponId: String, parameters_ctype: String, parameters_responsetype: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.BOOKING_REQUEST_NEW + "uniqueRefNo=\(parameters_uniqueRefNo)&dealId=\(parameters_dealId)&guestName=\(parameters_guestName)&guestMobileNo=\(parameters_guestMobileNo)&guestMailId=\(parameters_guestMailId)&guestCountry=\(parameters_guestCountry)&pickupCity=\(parameters_pickupCity)&dropCity=\(parameters_dropCity)&pickUpaddress=\(parameters_pickUpaddress)&travelDate=\(parameters_travelDate)&pickupTime=\(parameters_pickupTime)&vehicleName=\(parameters_vehicleName)&cars=\(parameters_cars)&days=\(parameters_days)&tripType=\(parameters_tripType)&tripRoot=\(parameters_tripRoot)&paidAmount=\(parameters_paidAmount)&paymentMode=\(parameters_paymentMode)&agentCode=\(parameters_agentCode)&UserIPAddress=\(parameters_UserIPAddress)&UserID=\(parameters_UserID)&guestCity=\(parameters_guestCity)&UserAgent=\(parameters_UserAgent)&couponId=\(parameters_couponId)&ctype=\(parameters_ctype)&responsetype=\(parameters_responsetype)"
            
            let escapedString = todosEndpoint.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            AppUtility.sharedInstance.showProgressIndicatorWith(message: "Processing...")
            
            Alamofire.request(escapedString!, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    AppUtility.sharedInstance.hideProgressIndicatorWith()
                    if let data = response.result.value{
                        if  (data as? [String : AnyObject]) != nil{
                            if let dictionaryArray = data as? Dictionary<String, AnyObject?> {
                                var referenceId = ""
                                if dictionaryArray.count > 0 {
                                    if (self.mUserPaymentMode == "6"){
                                        self.bookingPaymentDetails =  dictionaryArray as [String : AnyObject]
                                        self.getPaymentDetails()
                                    }else{
                                        if let reference = dictionaryArray["reference"] as? String{
                                            referenceId = reference
                                        }
//                                        let txnId = self.generateTransactionId(length: 11)
//                                        self.bookingConfirmAPICall(parameters_reference: referenceId, parameters_transactionId: txnId, parameters_paidAmount: "\(self.mFinalTotalAmt)", parameters_paymentMode: self.mUserPaymentMode, parameters_uId: "\(self.loginUserId)", parameters_apiKey: Constant.API_KEY, parameters_userIpAddress: Constant.USER_IP_ADDRESS, parameters_userId: Constant.USER_ID, parameters_userAgent: Constant.USER_AGENT, parameters_responseType: "2")
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
    
    func dealBookingConfirmAPICall(parameters_uId: String, parameters_dealId: String, parameters_reference: String, parameters_transactionId: String, parameters_paidAmount: String, parameters_paymentMode: String, parameters_couponId: String, parameters_couponValue: String,parameters_abcId: String, parameters_apiKey: String, parameters_userIpAddress: String, parameters_userId: String, parameters_userAgent: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.BOOKING_CONFIRM_NEW + "dealId=\(parameters_dealId)&uId=\(parameters_uId)&reference=\(parameters_reference)&transactionId=\(parameters_transactionId)&paidAmount=\(parameters_paidAmount)&paymentMode=\(parameters_paymentMode)&couponId=\(parameters_couponId)&couponValue=\(parameters_couponValue)&abcId=\(parameters_abcId)&ApiKey=\(parameters_apiKey)&UserIPAddress=\(parameters_userIpAddress)&UserID=\(parameters_userId)&UserAgent=\(parameters_userAgent)&responsetype=\(parameters_responseType)"
            
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
                                    var res_msg = ""
                                    for i in 0..<dictionaryArray.count{
                                        let Object = dictionaryArray[i]
                                        if let responseMessage = Object["msg"] as? String{
                                            res_msg = responseMessage
                                        }
                                    }
                                    AppUtility.sharedInstance.showAlertToastMesssageForSuccess(messageToUser: res_msg)
                                    //                                    self.usedTimerForDelay()
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
