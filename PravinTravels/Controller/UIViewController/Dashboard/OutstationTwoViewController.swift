//
//  OutstationTwoViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 08/02/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class OutstationTwoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SelectCityDelegate {
    
    //MARK:- Variable Declaration
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var sourceCityTextField: UITextField!
    @IBOutlet var destinationCityTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var outstationTableView: UITableView!
    @IBOutlet var addCityBarButton: UIBarButtonItem!
    
    var picker : UIDatePicker = UIDatePicker()
    var timePicker = UIDatePicker()
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
    var isDestinationTextField = false
    var tripTypeID = 1
    var cityListArray: [String] = []
    var strCity = ""
    var isCityDestinationRemoved = false
    
    var pickerBackgroundView:UIView?
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceCityTextField.setBottomBorder4()
        destinationCityTextField.setBottomBorder4()
        self.navigationItem.rightBarButtonItem = nil
        outstationTableView.isScrollEnabled = false
        outstationTableView.tableFooterView = UIView()
        searchButton.layer.cornerRadius = 0.3 *
            searchButton.frame.size.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Outstation"
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        //        let indexPath = IndexPath(row: 0, section: 0)
        let indexPath = IndexPath(row: cityListArray.count, section: 0)
        let cell = outstationTableView.cellForRow(at: indexPath) as! OutstationStaticTableViewCell
        
        if (textField == sourceCityTextField || textField == destinationCityTextField){
            if (textField == sourceCityTextField){
                isSourceTextField = true
                isDestinationTextField = false
            }else{
                isSourceTextField = false
                isDestinationTextField = true
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityListViewController") as! CityListViewController
            vc.mDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            return false
            
        }else if (textField == cell.startDateTextField){
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
            
        }else if (textField == cell.endDateTextField){
            if cell.startDateTextField.text == ""{
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
    
    //MARK:- UITableView DataSource & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityListArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == cityListArray.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "OutstationStaticTableViewCell") as? OutstationStaticTableViewCell
            cell?.startDateTextField.setBottomBorder4()
            cell?.endDateTextField.setBottomBorder4()
            cell?.timeTextField.setBottomBorder4()
            
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MulticityTableViewCell") as? MulticityTableViewCell
            cell?.destinationCityTextField.setBottomBorder4()

            if (indexPath.row < cityListArray.count){
                cell?.destinationCityTextField.text = cityListArray[indexPath.row]
            }
            
            cell?.cancelButton.tag = indexPath.row
            cell!.cancelButton.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (cityListArray.count == 0){
            return 108
        }else{
            if(indexPath.row == cityListArray.count){
                return 108
            }else{
                return 44
            }
        }
    }
    
    @objc func buttonSelected(sender: UIButton){
        print("sender.tag: \(sender.tag)")
        cityListArray.remove(at: sender.tag)
        self.checkDuplicateCityInArray()
//        self.outstationTableView.reloadData()
    }
    
    //MARK:- Instance Methods
    
    @objc func doneButtonAction()  {
        let indexPath = IndexPath(row: cityListArray.count, section: 0)
        let cell = outstationTableView.cellForRow(at: indexPath) as! OutstationStaticTableViewCell
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        if (isStartDate){
            if (cell.startDateTextField.text == ""){
                start_date = date
                cell.startDateTextField.text = result
            }
        }else if (isEndDate){
            if (cell.endDateTextField.text == ""){
                end_date = date
                cell.endDateTextField.text = result
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
        
        picker.addTarget(self, action: #selector(OutstationTwoViewController.dueDateChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func dueDateChanged(_ sender:UIDatePicker){
        let indexPath = IndexPath(row: cityListArray.count, section: 0)
        let cell = outstationTableView.cellForRow(at: indexPath) as! OutstationStaticTableViewCell
        
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
            let isGreater = start_date.isGreater1234(than: yesterday!)
            if isGreater{
                cell.startDateTextField.text = new_date
                cell.timeTextField.text = ""
                if isEndDateSelected{
                    if let userDefaultEndDate = UserDefaults.standard.value(forKey: Constant.END_DATE) as? Date{
                        let isUserDefaultEndDateGreater = userDefaultEndDate.isGreater1234(than: start_date)
                        if isUserDefaultEndDateGreater == false{
                            cell.endDateTextField.text = new_date
                        }
                    }
                }
            }else{
                AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Selected date is earlier than current date")
            }
        }
        
        if isEndDate{
            end_date = dateObj
            let isEndDateGreater = end_date.isGreater1234(than: start_date)
            if isEndDateGreater{
                UserDefaults.standard.set(end_date, forKey: Constant.END_DATE)
                cell.endDateTextField.text = new_date
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
        timePicker.addTarget(self, action: #selector(OutstationTwoViewController.startTimeDiveChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func startTimeDiveChanged(sender: UIDatePicker) {
        let indexPath = IndexPath(row: cityListArray.count, section: 0)
        let cell = outstationTableView.cellForRow(at: indexPath) as! OutstationStaticTableViewCell
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        cell.timeTextField.text = formatter.string(from: sender.date)
    }
    
    func sendToSearchCabVC()  {
        let indexPath = IndexPath(row: cityListArray.count, section: 0)
        let cell = outstationTableView.cellForRow(at: indexPath) as! OutstationStaticTableViewCell
        
        var multipleCityNameStr = ""
        let calendar = Calendar.current
        let formatter = DateFormatter()
        var newDate = start_date
        daysListArray.removeAll()
        
        while newDate <= end_date {
            formatter.dateFormat = "yyyy-MM-dd"
            daysListArray.append(formatter.string(from: newDate))
            newDate = calendar.date(byAdding: .day, value: 1, to: newDate)!
        }
        
        multipleCityNameStr = destinationCityTextField.text!
        if (self.cityListArray.count > 0){
            for i in 0..<self.cityListArray.count{
                if (multipleCityNameStr == ""){
                    multipleCityNameStr = destinationCityTextField.text! + "," + self.cityListArray[i]
                }else{
                    multipleCityNameStr = multipleCityNameStr + "," + self.cityListArray[i]
                }
            }
        }
        
        var journeyRoute = ""
        let dayCount = daysListArray.count
        let travelDate = cell.startDateTextField.text!
        let travelEndDate = cell.endDateTextField.text!
        let pickupTime = cell.timeTextField.text!
        if (segmentControl.selectedSegmentIndex == 2){
            journeyRoute = "\(sourceCityTextField.text!) -> " + "\(multipleCityNameStr) | " + "\(dayCount)-day(s) | " + "\(travelDate) | " + "\(pickupTime)"
        }else{
            journeyRoute = "\(sourceCityTextField.text!) -> " + "\(destinationCityTextField.text!) | " + "\(dayCount)-day(s) | " + "\(travelDate) | " + "\(pickupTime)"
        }

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchACabViewController") as! SearchACabViewController
        vc.journey_route = journeyRoute
        vc.mTrip_type_option = "\(tripTypeID)"
        vc.mTravel_type_option = "1"
        vc.source_city_name = sourceCityTextField.text!
        if (segmentControl.selectedSegmentIndex == 2){
            vc.destination_city_name = destinationCityTextField.text!
//            vc.destination_city_name = multipleCityNameStr
        }else{
            vc.destination_city_name = destinationCityTextField.text!
        }
        vc.journey_travel_Date = travelDate
        vc.journey_end_date = travelEndDate
        vc.no_of_days = dayCount
        vc.journey_pickup_time = pickupTime
        vc.comming_vc_name = "Outstation"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func clearAllTextFieldValue()  {
        let indexPath = IndexPath(row: cityListArray.count, section: 0)
        let cell = outstationTableView.cellForRow(at: indexPath) as! OutstationStaticTableViewCell
        
        sourceCityTextField.text = ""
        destinationCityTextField.text = ""
        cell.startDateTextField.text = ""
        cell.endDateTextField.text = ""
        cell.timeTextField.text = ""
        self.cityListArray.removeAll()
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnSegmentControl(_ sender: Any) {
        clearAllTextFieldValue()
        if segmentControl.selectedSegmentIndex == 0 {
            tripTypeID = 1
            outstationTableView.isScrollEnabled = false
            self.navigationItem.rightBarButtonItem = nil
        }else if segmentControl.selectedSegmentIndex == 1{
            tripTypeID = 2
            outstationTableView.isScrollEnabled = false
            self.navigationItem.rightBarButtonItem = nil
        }else {
            tripTypeID = 3
            outstationTableView.isScrollEnabled = true
            self.navigationItem.rightBarButtonItem = addCityBarButton
        }
    }
    
    @IBAction func actionOnSearchCabButton(_ sender: Any) {
        let indexPath = IndexPath(row: cityListArray.count, section: 0)
        let cell = outstationTableView.cellForRow(at: indexPath) as! OutstationStaticTableViewCell
        
        if sourceCityTextField.text != ""{
            if destinationCityTextField.text != ""{
                if cell.startDateTextField.text != ""{
                    if cell.endDateTextField.text != ""{
                        if cell.timeTextField.text != ""{
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
    
    @IBAction func actionOnAddCityBarButton(_ sender: Any) {
        if (sourceCityTextField.text == "" || destinationCityTextField.text == ""){
            AppUtility.sharedInstance.showAlertToastMesssage(messageToUser: "Please select the source city and destination city")
        }else{
            isSourceTextField = false
            isDestinationTextField = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityListViewController") as! CityListViewController
            vc.mDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Check MultipleCity Add Methods
    
    func checkAndAdd(str: String)  {
        if (str != ""){
            if (self.cityListArray.count == 0){
                if (str == destinationCityTextField.text!){
                    AppUtility.sharedInstance.showAlertToastMesssage(messageToUser: "Selected destination city is same, please select another city")
                }else{
                    self.addCityToArray(cityName: str)
                }
            }else{
                let index = cityListArray.endIndex - 1
                let lastItem = cityListArray[index]
                if (lastItem == str){
                    AppUtility.sharedInstance.showAlertToastMesssage(messageToUser: "Selected destination city is same, please select another city")
                }else{
                    self.addCityToArray(cityName: str)
                }
            }
        }
    }
    
    func addCityToArray(cityName: String)  {
        if (cityListArray.count == 0){
            cityListArray.insert("\(cityName)", at: 0)
        }else{
            cityListArray.insert("\(cityName)", at: cityListArray.count)
        }
        self.outstationTableView.reloadData()
    }
    
    func checkDuplicateCityInArray() {
        if (self.cityListArray.count != 0){
            if (self.cityListArray.count == 1){
                if (self.cityListArray[0] == destinationCityTextField.text!){
                    self.cityListArray.removeAll()
                }
            }else{
                for i in 0..<self.cityListArray.count - 1{
                    if (cityListArray[i] == cityListArray[i + 1]){
                        cityListArray.remove(at: i + 1)
                        break
                    }
                }
            }
        }
        self.outstationTableView.reloadData()
    }
    
    //MARK:- Delegate Methods
    
    func getCityNameAndID(_ mName: String, mID: Int) {
        if (isSourceTextField){
            sourceCityTextField.text = mName
            selectedCityID = mID
        }else if (isDestinationTextField){
            destinationCityTextField.text = mName
            selectedCityID = mID
        }else{
            selectedCityID = mID
            checkAndAdd(str: mName)
        }
    }
}

extension Date {
    func isGreater1234(than date: Date) -> Bool {
        return self >= date
    }
    func isSmaller1234(than date: Date) -> Bool {
        return self < date
    }
    func isEqual1234(to date: Date) -> Bool {
        return self == date
    }
}

extension UITextField {
    func setBottomBorder4() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
