//
//  OnewayDealTermsConditionViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 20/02/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire

class OnewayDealTermsConditionViewController: UIViewController, UITextFieldDelegate {

    //MARK:- Variable Declaration
    
    @IBOutlet var selectTimeTextField: UITextField!
    @IBOutlet var gstStaticLabel: UILabel!
    @IBOutlet var dealAmountLabel: UILabel!
    @IBOutlet var gstAmountLabel: UILabel!
    @IBOutlet var totalCostLabel: UILabel!
    @IBOutlet var detalDetailsUpLabel: UILabel!
    @IBOutlet var detailsDetailsDounLabel: UILabel!
    @IBOutlet var mTextView: UITextView!
    @IBOutlet var bookDealButton: UIButton!
    
    var pickerBackgroundView:UIView?
    var timePicker = UIDatePicker()
    var selectedTime = ""
    var isTimePickerOpen = true
    
    var dealId = Int()
    var dealAmt = Double()
    var gstAmt = Double()
    var totalCost = Double()
    var totalKm = ""
    var perKm = ""
    var mutableString = ""
    var travelDateStr = ""
    var travelDate = Date()
    //
    var carName = ""
    var pickupCity = ""
    var dropCity = ""
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectTimeTextField.setBottomBorderT_C()
        bookDealButton.layer.cornerRadius = 0.1 *
            bookDealButton.frame.size.height
        getTermsConditionAPICall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Deal Term"
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if isTimePickerOpen{
            self.openTimePicker()
            self.isTimePickerOpen = false
        }else{
            pickerBackgroundView?.removeFromSuperview()
            self.isTimePickerOpen = true
        }
        return false
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnBookDealButton(_ sender: Any) {
        let time = selectTimeTextField.text!
        if (time.isEmpty){
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please select valid pickup time")
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
            vc.mUserVehicleName = carName
            vc.mDealId = dealId
            vc.advance_Amt = 0.0
            vc.basic_Amount = dealAmt
            vc.serviceTax_Amount = gstAmt
            vc.balance_Amount = 0.0
            vc.total_Amount = totalCost
            vc.mUserPickupCity = pickupCity
            vc.mUserDropCity = dropCity
            vc.mUserTravelDate = travelDateStr
            vc.mUserVehiclePickupTime = selectTimeTextField.text!
            vc.mDay = "1"
            vc.mCars = "1"
            vc.mCvcName = "Deal"
            vc.mUserTripType = "7"
            vc.mUserTripRoot = "12"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Instance Methods
    
    func setDetails()  {
        dealAmountLabel.text = "₹ \(dealAmt) /-"
        gstAmountLabel.text = "₹ \(gstAmt) /-"
        totalCostLabel.text = "₹ \(totalCost) /-"
        detalDetailsUpLabel.text = "Usable oneway limit : \(totalKm) Km"
        detailsDetailsDounLabel.text = "After \(totalKm) Km, extra charges ₹ \(perKm) PerKm"
        mTextView.text = mutableString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy"
        guard let date = dateFormatter.date(from: travelDateStr) else {
            fatalError()
        }
        print("date: \(date)")
        travelDate = date
//        travelDate = getDate()
    }

/*
    func getDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: travelDateStr)!
    }
*/
    
    func openTimePicker()  {
        view.endEditing(true)
        if UIScreen.main.bounds.size.height < 568 {
            pickerBackgroundView = UIView(frame: CGRect(x: 0, y: 240, width: self.view.frame.size.width, height: 240))
            timePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 196))
        }else {
            pickerBackgroundView = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height - 260, width: self.view.frame.size.width, height: 260))
            timePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 216))
        }
        timePicker.datePickerMode = UIDatePickerMode.time
        timePicker.minuteInterval = 15
        let date = Date()
        let calendar = Calendar.current
        let mHour = calendar.component(.hour, from: date)
        let mMinutes = calendar.component(.minute, from: date)
        let mSeconds = calendar.component(.second, from: date)
        print("hours = \(mHour):\(mMinutes):\(mSeconds)")
        
        if Date().compare(travelDate) == ComparisonResult.orderedDescending {
            let calendar = Calendar.current
            var minDateComponent = calendar.dateComponents([.hour,.minute,.second], from: Date())
            //            minDateComponent.hour = mHour + 4
            minDateComponent.hour = mHour + 1
            minDateComponent.minute = mMinutes
            minDateComponent.second = mSeconds
            let minDate = calendar.date(from: minDateComponent)
            timePicker.minimumDate = minDate! as Date
            timePicker.setDate(minDate!, animated: true)
        }
        else{
            let calendar = Calendar.current
            var minDateComponent = calendar.dateComponents([.hour,.minute,.second], from: Date())
            minDateComponent.hour = 0
            minDateComponent.minute = 0
            minDateComponent.second = 0
            let minDate = calendar.date(from: minDateComponent)
            timePicker.minimumDate = minDate! as Date
            timePicker.setDate(minDate!, animated: true)
        }
        
        pickerBackgroundView?.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        let doneButton = UIButton(type:.system)
        doneButton.frame =  CGRect(x: (pickerBackgroundView?.frame.size.width)!-70, y: 7, width: 50, height: 30)
        doneButton.setTitle("Done", for: UIControlState())
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        
        let cancelutton = UIButton(type:.system)
        cancelutton.setTitle("Cancel", for: UIControlState())
        cancelutton.frame =  CGRect(x:10, y: 7, width: 50, height: 30)
        cancelutton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        
        timePicker.backgroundColor = UIColor.white
        pickerBackgroundView?.addSubview(timePicker)
        pickerBackgroundView?.addSubview(doneButton)
        pickerBackgroundView?.addSubview(cancelutton)
        self.view.addSubview(pickerBackgroundView!)
        
        timePicker.reloadInputViews()
        timePicker.addTarget(self, action: #selector(OnewayDealTermsConditionViewController.startTimeDiveChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func startTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        selectTimeTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func doneButtonAction()  {
        pickerBackgroundView?.removeFromSuperview()
        isTimePickerOpen = true
    }
    
    //MARK:- API Call Methods
    
    func getTermsConditionAPICall()  {
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            let todosEndpoint: String = Constant.BASE_URL + "tandc?travelTypeOption=7&tripTypeOption=12"
            let escapedString = todosEndpoint.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            AppUtility.sharedInstance.showProgressIndicatorWith(message: "Processing...")
            
            Alamofire.request(escapedString!, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    AppUtility.sharedInstance.hideProgressIndicatorWith()
                    if let data = response.result.value{
                        if let apresult = (data as? [String : AnyObject])?["result"]{
                            if let dictionaryArray = apresult as? Array<Dictionary<String, AnyObject?>> {
                                if dictionaryArray.count > 0 {
                                    for i in 0..<dictionaryArray.count{
                                        let Object = dictionaryArray[i]
                                        if let tc = Object["tc"] as? String{
                                            if (self.mutableString == ""){
                                                self.mutableString = "-> " + tc
                                            }else{
                                                self.mutableString = self.mutableString + "\n -> " + tc
                                            }
                                        }
                                    }
                                    self.setDetails()
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
    func setBottomBorderT_C() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
