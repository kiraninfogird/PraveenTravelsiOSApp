//
//  OutstationViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 10/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class OutstationViewController: UIViewController, UITextFieldDelegate, SelectCityDelegate {
    
    //MARK:- Variable Declaration
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var sourceCityTextField: UITextField!
    @IBOutlet var destinationCityTextField: UITextField!
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var endDateTextField: UITextField!
    @IBOutlet var timeTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    let picker : UIDatePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var doneButton = UIButton()
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
    
    var isStartDateCalenderOpen = true
    var isEndDateCalenderOpen = true
    var isTimePickerOpen = true
    var isEndDateSelected = false
    
    var sourceCityArray = [String]()
    var mutableDictForSourceCity = [String: Int]()
    var selectedCityID = Int()
    var selectedCityName = ""
    
    var isSourceTextField = true
    var tripTypeID = 1
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceCityTextField.setBottomBorder3()
        destinationCityTextField.setBottomBorder3()
        startDateTextField.setBottomBorder3()
        endDateTextField.setBottomBorder3()
        timeTextField.setBottomBorder3()
        searchButton.layer.cornerRadius = 0.3 *
            searchButton.frame.size.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Outstation"
        //        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.isNavigationBarHidden = false
        self.addDoneButton()
        self.doneButton.isHidden = true
    }
    
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if (textField == sourceCityTextField || textField == destinationCityTextField){
            if (textField == sourceCityTextField){
                isSourceTextField = true
            }else{
                isSourceTextField = false
            }
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
                self.doneButton.isHidden = false
            }else{
                picker.removeFromSuperview()
                self.isCalenderOpen = true
                self.doneButton.isHidden = true
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
                    self.doneButton.isHidden = false
                }else{
                    picker.removeFromSuperview()
                    self.isCalenderOpen = true
                    self.doneButton.isHidden = true
                }
            }
            return false
            
        }else{
            if isTimePickerOpen{
                self.openTimePicker()
                self.isTimePickerOpen = false
                self.doneButton.isHidden = false
            }else{
                timePicker.removeFromSuperview()
                self.isTimePickerOpen = true
                self.doneButton.isHidden = true
            }
            return false
        }
    }
    
    //MARK:- Instance Methods
    
    @objc func doneButtonAction()  {
        picker.removeFromSuperview()
        timePicker.removeFromSuperview()
        isTimePickerOpen = true
        isCalenderOpen = true
        doneButton.isHidden = true
    }
    
    func addDoneButton(){
        doneButton = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: (self.view.frame.height/2 + 40), width: 50, height: 21))
        doneButton.backgroundColor = Colors.buttonThemeColor
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        self.view.addSubview(doneButton)
    }
    
    func openDatePicker()  {
        view.endEditing(true)
        picker.datePickerMode = UIDatePickerMode.date
        picker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2 + 60), width: self.view.frame.width, height: 220.0)
        picker.backgroundColor = UIColor.white
        self.view.addSubview(picker)
        picker.addTarget(self, action: #selector(LocalViewController.dueDateChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func dueDateChanged(_ sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = DateFormatter.Style.none
        let dateObj = sender.date
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let new_date = dateFormatter.string(from: dateObj)
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd-MM-yyyy"
        
        if isStartDate{
            start_date = dateObj
            let isGreater = start_date.isGreater123(than: yesterday!)
            if isGreater{
                startDateTextField.text = new_date
                timeTextField.text = ""
                if isEndDateSelected{
                    if let userDefaultEndDate = UserDefaults.standard.value(forKey: Constant.END_DATE) as? Date{
                        let isUserDefaultEndDateGreater = userDefaultEndDate.isGreater123(than: start_date)
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
            let isEndDateGreater = end_date.isGreater123(than: start_date)
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
        timePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2 + 60), width: self.view.frame.width, height: 220.0)
        timePicker.backgroundColor = UIColor.white
        timePicker.reloadInputViews()
        self.view.addSubview(timePicker)
        timePicker.addTarget(self, action: #selector(OutstationViewController.startTimeDiveChanged), for: UIControlEvents.valueChanged)
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
        let journeyRoute = "\(sourceCityTextField.text!) -> " + "\(destinationCityTextField.text!) | " + "\(dayCount)-day(s) | " + "\(travelDate) | " + "\(pickupTime)"
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchACabViewController") as! SearchACabViewController
        vc.journey_route = journeyRoute
        vc.mTrip_type_option = "\(tripTypeID)"
        vc.mTravel_type_option = "1"
        vc.source_city_name = sourceCityTextField.text!
        vc.destination_city_name = destinationCityTextField.text!
        vc.journey_travel_Date = travelDate
        vc.journey_end_date = travelEndDate
        vc.no_of_days = dayCount
        vc.journey_pickup_time = pickupTime
        vc.comming_vc_name = "Outstation"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func clearAllTextFieldValue()  {
        sourceCityTextField.text = ""
        destinationCityTextField.text = ""
        startDateTextField.text = ""
        endDateTextField.text = ""
        timeTextField.text = ""
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnSegmentControl(_ sender: Any) {
        clearAllTextFieldValue()
        if segmentControl.selectedSegmentIndex == 0 {
            tripTypeID = 1
        }else if segmentControl.selectedSegmentIndex == 1{
            tripTypeID = 2
        }else {
            tripTypeID = 3
        }
    }
    
    @IBAction func actionOnSearchCabButton(_ sender: Any) {
        if sourceCityTextField.text != ""{
            if destinationCityTextField.text != ""{
                if startDateTextField.text != ""{
                    if endDateTextField.text != ""{
                        if timeTextField.text != ""{
                            sendToSearchCabVC()
                        }else{
                            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please select pickup time?")
                        }
                    }else{
                        AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please select end date?")
                    }
                }else{
                    AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please select start date?")
                }
            }else{
                AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please select destination city?")
            }
        }else{
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Please select source city?")
        }
    }
    
    //MARK:- Delegate Methods
    
    func getCityNameAndID(_ mName: String, mID: Int) {
        if (isSourceTextField){
            sourceCityTextField.text = mName
            selectedCityID = mID
        }else{
            destinationCityTextField.text = mName
            selectedCityID = mID
        }
    }
}
extension Date {
    func isGreater123(than date: Date) -> Bool {
        return self >= date
    }
    func isSmaller123(than date: Date) -> Bool {
        return self < date
    }
    func isEqual123(to date: Date) -> Bool {
        return self == date
    }
}
extension UITextField {
    func setBottomBorder3() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
