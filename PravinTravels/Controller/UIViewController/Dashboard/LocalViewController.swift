//
//  LocalViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 06/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire

class LocalViewController: UIViewController, UITextFieldDelegate, SelectCityDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    //MARK:- Variable Declaration
    
    var picker : UIDatePicker = UIDatePicker()
    var timePicker = UIDatePicker()
//    var doneButton = UIButton()
    var daysListArray = [String]()
    
    var isFromStartDateButton = Bool()
    var isFromEndDateButton = Bool()
    var isSelectTimeDateButton = Bool()
    var start_date = Date()
    var end_date = Date()
    var selectedTime = ""
    
    var isCalenderOpen = true
    var isStartDate = false
    var isEndDate = false
    var selectedSegmentDay = "fullday"
    
    var isStartDateCalenderOpen = true
    var isEndDateCalenderOpen = true
    var isTimePickerOpen = true
    var isEndDateSelected = false
    
    var sourceCityArray = [String]()
    var mutableDictForSourceCity = [String: Int]()
    var selectedCityID = Int()
    var selectedCityName = ""
    
    var pkgPicker: UIPickerView!
    var pkgPickerValues = [""]
    
    @IBOutlet var selectCityTextField: UITextField!
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var endDateTextField: UITextField!
    @IBOutlet var timeTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var selectPackageTextField: UITextField!
    
    var pickerBackgroundView:UIView?
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCityTextField.setBottomBorder()
        selectPackageTextField.setBottomBorder()
        startDateTextField.setBottomBorder()
        endDateTextField.setBottomBorder()
        timeTextField.setBottomBorder()
        searchButton.layer.cornerRadius = 0.1 *
            searchButton.frame.size.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Local"
//        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.isNavigationBarHidden = false
        
        pkgPicker = UIPickerView()
        pkgPicker.dataSource = self
        pkgPicker.delegate = self
        selectPackageTextField.inputView = pkgPicker
        selectPackageTextField.isUserInteractionEnabled = false
//        selectPackageTextField.text = pkgPickerValues[0]
        
        let menuButton = self.navigationItem.leftBarButtonItem
        if self.revealViewController() != nil {
            menuButton?.target = self.revealViewController()
            menuButton?.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if (textField == selectCityTextField){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityListViewController") as! CityListViewController
            vc.mDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            return false
            
        }else if (textField == startDateTextField){
            isStartDate = true
            isEndDate = false
            if isCalenderOpen{
                self.openDatePicker()
                self.isCalenderOpen = false
            }else{
                pickerBackgroundView?.removeFromSuperview()
                self.isCalenderOpen = true
            }
            return false
            
        }else if (textField == endDateTextField){
            if startDateTextField.text == ""{
                AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please first select start date...")
            }else{
                isEndDateSelected = true
                isEndDate = true
                isStartDate = false
                if isCalenderOpen{
                    self.openDatePicker()
                    self.isCalenderOpen = false
                }else{
                    pickerBackgroundView?.removeFromSuperview()
                    self.isCalenderOpen = true
                }
            }
            return false
            
        }else if (textField == selectPackageTextField){
            return false
            
        }else{
            isStartDate = false
            isEndDate = false
            if isTimePickerOpen{
                self.openTimePicker()
                self.isTimePickerOpen = false
            }else{
                pickerBackgroundView?.removeFromSuperview()
                self.isTimePickerOpen = true
            }
            return false
        }
    }
    
    //MARK:- Instance Methods
    
    @objc func doneButtonAction()  {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        if (isStartDate){
            if (startDateTextField.text == ""){
                start_date = date
                startDateTextField.text = result
            }
        }else if (isEndDate){
            if (endDateTextField.text == ""){
                end_date = date
                endDateTextField.text = result
            }
        }
        
        pickerBackgroundView?.removeFromSuperview()
        isTimePickerOpen = true
        isCalenderOpen = true
    }
    
    @objc func cancelButtonAction()  {
        pickerBackgroundView?.removeFromSuperview()
        isTimePickerOpen = true
        isCalenderOpen = true
    }
    
    func openDatePicker()  {
        view.endEditing(true)
        if UIScreen.main.bounds.size.height < 568 {
            pickerBackgroundView = UIView(frame: CGRect(x: 0, y: 240, width: self.view.frame.size.width, height: 240))
            picker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 196))
        }else {
            pickerBackgroundView = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height - 260, width: self.view.frame.size.width, height: 260))
            picker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 216))
        }
        
        picker.datePickerMode = UIDatePickerMode.date
        pickerBackgroundView?.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        let doneButton = UIButton(type:.system)
        doneButton.frame =  CGRect(x: (pickerBackgroundView?.frame.size.width)!-70, y: 7, width: 50, height: 30)
        doneButton.setTitle("Done", for: UIControlState())
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        
        let cancelutton = UIButton(type:.system)
        cancelutton.setTitle("Cancel", for: UIControlState())
        cancelutton.frame =  CGRect(x:10, y: 7, width: 50, height: 30)
        cancelutton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        picker.backgroundColor = UIColor.white
        pickerBackgroundView?.addSubview(picker)
        pickerBackgroundView?.addSubview(doneButton)
        pickerBackgroundView?.addSubview(cancelutton)
        self.view.addSubview(pickerBackgroundView!)
        
        picker.addTarget(self, action: #selector(LocalViewController.dueDateChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func dueDateChanged(_ sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = DateFormatter.Style.none
        let dateObj = sender.date
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let new_date = dateFormatter.string(from: dateObj)
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let formatter3 = DateFormatter()
//        formatter3.dateFormat = "yyyy-MM-dd"
        formatter3.dateFormat = "dd-MM-yyyy"
        
        if isStartDate{
            start_date = dateObj
            let isGreater = start_date.isGreater1(than: yesterday!)
            if isGreater{
                startDateTextField.text = new_date
                timeTextField.text = ""
                if isEndDateSelected{
                    if let userDefaultEndDate = UserDefaults.standard.value(forKey: Constant.END_DATE) as? Date{
                        let isUserDefaultEndDateGreater = userDefaultEndDate.isGreater1(than: start_date)
                        if isUserDefaultEndDateGreater == false{
                            endDateTextField.text = new_date
                        }
                    }
                }
            }else{
                AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Selected date is earlier than current date")
            }
        }
        
        if isEndDate{
            end_date = dateObj
            let isEndDateGreater = end_date.isGreater1(than: start_date)
            if isEndDateGreater{
                UserDefaults.standard.set(end_date, forKey: Constant.END_DATE)
                endDateTextField.text = new_date
            }else{
                AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "End date is earlier than start date")
            }
        }
    }
    
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
        
        if Date().compare(start_date) == ComparisonResult.orderedDescending {
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
        cancelutton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        timePicker.backgroundColor = UIColor.white
        pickerBackgroundView?.addSubview(timePicker)
        pickerBackgroundView?.addSubview(doneButton)
        pickerBackgroundView?.addSubview(cancelutton)
        self.view.addSubview(pickerBackgroundView!)
        
        timePicker.reloadInputViews()
        timePicker.addTarget(self, action: #selector(LocalViewController.startTimeDiveChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func startTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeTextField.text = formatter.string(from: sender.date)
    }
    
    func sendToSearchCabVC()  {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        var newDate = start_date
        daysListArray.removeAll()
        
        while newDate <= end_date {
            formatter.dateFormat = "yyyy-MM-dd"
            daysListArray.append(formatter.string(from: newDate))
            newDate = calendar.date(byAdding: .day, value: 1, to: newDate)!
        }
        
        let dayCount = daysListArray.count
        let travelDate = startDateTextField.text!
        let travelEndDate = endDateTextField.text!
        let pickupTime = timeTextField.text!
        let journeyRoute = "\(selectCityTextField.text!) -> " + "\(selectPackageTextField.text!) -> " + "\(dayCount)-day(s) | " + "\(travelDate) | " + "\(pickupTime)"
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchACabViewController") as! SearchACabViewController
        vc.journey_route = journeyRoute
        vc.mTrip_type_option = "4"
        vc.mTravel_type_option = "2"
        vc.source_city_name = selectCityTextField.text!
        vc.packageName = selectPackageTextField.text!
        vc.journey_travel_Date = travelDate
        vc.journey_end_date = travelEndDate
        vc.no_of_days = dayCount
        vc.journey_pickup_time = pickupTime
        vc.comming_vc_name = "Local"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- PickerView DataSource and Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pkgPickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pkgPickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.view.endEditing(true)
        selectPackageTextField.text = pkgPickerValues[row]
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnSearchCabButton(_ sender: Any) {
        if selectCityTextField.text != ""{
            if selectPackageTextField.text != ""{
                if startDateTextField.text != ""{
                    if endDateTextField.text != ""{
                        if timeTextField.text != ""{
                            sendToSearchCabVC()
                        }else{
                            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please select valid pickup time...")
                        }
                    }else{
                        AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please select end date...")
                    }
                }else{
                    AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please select start date...")
                }
            }else{
                AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please select package...")
            }
        }else{
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please select valid city...")
        }
    }
    
    @IBAction func actionOnSegmentControl(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            selectedSegmentDay = "fullday"
        }else {
            selectedSegmentDay = "halfday"
        }
    }
    
    //MARK:- Delegate Methods
    
    func getCityNameAndID(_ mName: String, mID: Int) {
        selectCityTextField.text = mName
        selectedCityID = mID
        self.getCityLocalPkgAPICall(parameters_cityname: mName)
    }
    
    //MARK:- API Call Methods
    
    func getCityLocalPkgAPICall(parameters_cityname: String){
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            let todosEndpoint: String = Constant.BASE_URL + Constant.CITY_LOCAL_PKG + "cityname=\(parameters_cityname)"
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
                                    for i in 0..<dictionaryArray.count{
                                        let Object = dictionaryArray[i]
                                        if let time = Object["time"] as? String{
                                            self.pkgPickerValues.append(time)
                                        }
                                    }
                                    self.selectPackageTextField.isUserInteractionEnabled = true
                                    self.pkgPicker.reloadAllComponents()
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

extension Date {
    func isGreater1(than date: Date) -> Bool {
        return self >= date
    }
    func isSmaller1(than date: Date) -> Bool {
        return self < date
    }
    func isEqual1(to date: Date) -> Bool {
        return self == date
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

