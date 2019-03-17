//
//  OneWayDealsViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 10/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class OneWayDealsViewController: UIViewController, UITextFieldDelegate, SelectCityDelegate {
    
    //MARK:- Variable Declaration
    
    @IBOutlet var sourceCityTextField: UITextField!
    @IBOutlet var destinationCityTextField: UITextField!
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    var picker : UIDatePicker = UIDatePicker()
    var start_date = Date()
    var end_date = Date()
    var isCalenderOpen = true
    var selectedSourceCityID = Int()
    var selectedDestinationCityID = Int()
    var isSourceCityTextField = true
    
    var pickerBackgroundView:UIView?
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceCityTextField.setBottomBorder1()
        destinationCityTextField.setBottomBorder1()
        startDateTextField.setBottomBorder1()
        searchButton.layer.cornerRadius = 0.3 *
            searchButton.frame.size.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Oneway Deal"
//        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if (textField == sourceCityTextField || textField == destinationCityTextField){
            if (textField == sourceCityTextField){
                isSourceCityTextField = true
            }else{
                isSourceCityTextField = false
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityListViewController") as! CityListViewController
            vc.mDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            return false
            
        }else{
            if isCalenderOpen{
                self.openDatePicker()
                self.isCalenderOpen = false
            }else{
                pickerBackgroundView?.removeFromSuperview()
                self.isCalenderOpen = true
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
        if (startDateTextField.text == ""){
            startDateTextField.text = result
        }
        pickerBackgroundView?.removeFromSuperview()
        isCalenderOpen = true
    }
    
    @objc func cancelButtonAction()  {
        pickerBackgroundView?.removeFromSuperview()
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
        
        picker.addTarget(self, action: #selector(OneWayDealsViewController.dueDateChanged), for: UIControlEvents.valueChanged)
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
        
        start_date = dateObj
        let isGreater = start_date.isGreater11(than: yesterday!)
        if isGreater{
            startDateTextField.text = new_date
        }else{
            AppUtility.sharedInstance.showAlertWithoutIcon(title: "Alert", subTitle: "Selected date is earlier than current date")
        }
    }
    
    func sendToSearchCabVC()  {
        let travelDate = startDateTextField.text!
        let journeyRoute = "\(sourceCityTextField.text!) -> " + "\(destinationCityTextField.text!) | " + "1-day(s) | " + "\(travelDate)"
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchACabViewController") as! SearchACabViewController
        vc.journey_route = journeyRoute
        vc.source_city_name = sourceCityTextField.text!
        vc.destination_city_name = destinationCityTextField.text!
        vc.journey_travel_Date = travelDate
        vc.no_of_days = 1
        vc.comming_vc_name = "Deal"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnSearchCabButton(_ sender: Any) {
        if sourceCityTextField.text != ""{
            if destinationCityTextField.text != ""{
                if startDateTextField.text != ""{
                    sendToSearchCabVC()
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
        if (isSourceCityTextField){
            sourceCityTextField.text = mName
            selectedSourceCityID = mID
        }else{
            destinationCityTextField.text = mName
            selectedDestinationCityID = mID
        }
    }
    
}
extension Date {
    func isGreater11(than date: Date) -> Bool {
        return self >= date
    }
    func isSmaller11(than date: Date) -> Bool {
        return self < date
    }
    func isEqual11(to date: Date) -> Bool {
        return self == date
    }
}

extension UITextField {
    func setBottomBorder1() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
