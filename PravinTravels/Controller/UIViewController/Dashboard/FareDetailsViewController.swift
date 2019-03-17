//
//  FareDetailsViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 04/02/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class FareDetailsViewController: UIViewController, UITextViewDelegate {

    //MARK:- Variable Declarations
    
    var mSelectedDict = Dictionary<String, AnyObject>()
    var mBasicFare = Int()
    var mTotalFare = Int()
    var mExtraHourRate = Int()
    var perKmRate = ""
    var waitingCharge = Int()
    var dayForOutstation = ""
    var minChargeDistance = Int()
    var mDriverCharges = Int()
    var mApproxDistance = Int()
    var minAvgPerDay_oneway = Int()
    var mServiceTax = Int()
    var minKmPerDay = Int()
    var nightCharges = Int()
    var leftOverSide = Int()
    var isCommingFrom = ""
    
    var mSource_city = ""
    var mDestination_city = ""
    var start_date = ""
    var end_date = ""
    var trip_type = ""
    var travel_type = ""
    var mPickUpTime = ""
    var mPickUPLocation = ""
    var mDropLocation = ""
    var mLocalPackageStr = ""
    
    @IBOutlet var fareDetailsTextView: UITextView!{
        didSet{
            fareDetailsTextView.delegate = self
        }
    }
    @IBOutlet var tAndCTextView: UITextView!{
        didSet{
            tAndCTextView.delegate = self
        }
    }
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFareDetails()
        self.setAttributedString()
    }
    
    //MARK:- IBActions Methods
    
    @IBAction func actionOnCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Instance Methods
    
    func getFareDetails()  {
        if let localBasicRate = mSelectedDict["localBasicRate"] as? Int{
            self.mBasicFare = localBasicRate
        }else if let localBasicRate = mSelectedDict["localBasicRate"] as? Double{
            self.mBasicFare = Int(localBasicRate)
        }else if let transferBasicRate = mSelectedDict["transferBasicRate"] as? Int{
            self.mBasicFare = transferBasicRate
        }else if let transferBasicRate = mSelectedDict["transferBasicRate"] as? Double{
            self.mBasicFare = Int(transferBasicRate)
        }else if let basicRate = mSelectedDict["basicRate"] as? Int{
            self.mBasicFare = basicRate
        }else if let basicRate = mSelectedDict["basicRate"] as? Double{
            self.mBasicFare = Int(basicRate)
        }
        if let totalAmount = mSelectedDict["totalAmount"] as? Int{
            self.mTotalFare = totalAmount
        }else if let totalAmount = mSelectedDict["totalAmount"] as? Double{
            self.mTotalFare = Int(totalAmount)
        }
        if let extraHourRate = mSelectedDict["extraHourRate"] as? Int{
            self.mExtraHourRate = extraHourRate
        }else if let extraHourRate = mSelectedDict["extraHourRate"] as? Double{
            self.mExtraHourRate = Int(extraHourRate)
        }
        if let perKm = mSelectedDict["perKm"] as? String{
            self.perKmRate = perKm
        }else if let perKm = mSelectedDict["perKm"] as? Int{
            self.perKmRate = "\(perKm)"
        }else if let perKm = mSelectedDict["perKm"] as? Double{
            self.perKmRate = "\(perKm)"
        }
        if let waitingChargesPerHour = mSelectedDict["waitingChargesPerHour"] as? Int{
            self.waitingCharge = waitingChargesPerHour
        }
        if let days = mSelectedDict["days"] as? String{
            self.dayForOutstation = days
            
        }else if let days = mSelectedDict["days"] as? Int{
            self.dayForOutstation = "\(days)"
        }
        if let MinimumChargedDistance = mSelectedDict["MinimumChargedDistance"] as? Int{
            self.minChargeDistance = MinimumChargedDistance
        }else if let MinimumChargedDistance = mSelectedDict["MinimumChargedDistance"] as? Double{
            self.minChargeDistance = Int(MinimumChargedDistance)
        }
        if let driverCharges = mSelectedDict["driverCharges"] as? Int{
            self.mDriverCharges = driverCharges
        }else if let driverCharges = mSelectedDict["driverCharges"] as? Double{
            self.mDriverCharges = Int(driverCharges)
        }
        if let ApproxDistance = mSelectedDict["ApproxDistance"] as? Int{
            self.mApproxDistance = ApproxDistance
        }else if let ApproxDistance = mSelectedDict["ApproxDistance"] as? Double{
            self.mApproxDistance = Int(ApproxDistance)
        }
        if let minAvgPerDay = mSelectedDict["minAvgPerDay"] as? Int{
            self.minAvgPerDay_oneway = minAvgPerDay
        }else if let minAvgPerDay = mSelectedDict["minAvgPerDay"] as? Double{
            self.minAvgPerDay_oneway = Int(minAvgPerDay)
        }
        if let minKmsPerDay = mSelectedDict["minKmsPerDay"] as? Int{
            self.minKmPerDay = minKmsPerDay
        }else if let minKmsPerDay = mSelectedDict["minKmsPerDay"] as? Double{
            self.minKmPerDay = Int(minKmsPerDay)
        }
        if let serviceTaxAmount = mSelectedDict["serviceTaxAmount"] as? Int{
            self.mServiceTax = serviceTaxAmount
        }else if let serviceTaxAmount = mSelectedDict["serviceTaxAmount"] as? Double{
            self.mServiceTax = Int(serviceTaxAmount)
        }
        if let nightCharges = mSelectedDict["nightCharges"] as? Int{
            self.nightCharges = nightCharges
        }else if let nightCharges = mSelectedDict["nightCharges"] as? Double{
            self.nightCharges = Int(nightCharges)
        }
        if let OnewayPerKmRate = mSelectedDict["OnewayPerKmRate"] as? Int{
            self.leftOverSide = OnewayPerKmRate
        }else if let OnewayPerKmRate = mSelectedDict["OnewayPerKmRate"] as? Double{
            self.leftOverSide = Int(OnewayPerKmRate)
        }
    }
    
    // MARK:- Set Terms and Condition Attributed String Details
    
    func setAttributedString() {
        if isCommingFrom == "Local"{
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.left
            attributedStringParagraphStyle.lineSpacing = 5.0
            
            let attributedString0 = NSAttributedString(string: "Fare Details : \n", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            
            let attributedString1 = NSAttributedString(string: "Basic Fare : " + "\(self.mBasicFare) /-" + "\n" + "Total Fare : " + "\(self.mTotalFare) /-" + "\n" + "Minimum charged hour / distance per day : \(mLocalPackageStr) \n\n" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
            
            let attributedString2 = NSAttributedString(string: "Basic Fare : " + "\(self.mBasicFare)" + " X 1 = " + "\(self.mBasicFare) /-" + "\n" + "Driver Allowance  = \(mDriverCharges) /-" + "\n" + "Service Tax Amount = \(mServiceTax) /-\n" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
            
            let attributedString3 = NSAttributedString(string: "Total Cost = \(mTotalFare) /-", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            
            let attributedString4 = NSAttributedString(string: "\n\nIf you will use car/cab more than \(mLocalPackageStr) , extra charges are applicable as follows : \n", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            
            let attributedString5 = NSAttributedString(string: "After \(mLocalPackageStr) : \n" + "+ \(self.mExtraHourRate) / Hour" + "\n+" + " ₹ " + perKmRate  + "/- " + "PerKm" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
            
            let attributedString6 = NSAttributedString(string: "\n\nTerms & Conditions : \n", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            
            let attributedString7 = NSAttributedString(string: "-> One day means a one calendar day (from midnight 12 to midnight 12).\n" + "-> Toll taxes, parkings, state taxes paid by customer wherever is applicable.\n" + "-> For all calculations distance from pick up point to the drop point & back to pick up point will be considered.\n" + "-> Distance will be calculated from garage to garage.\n" + "-> The final cab rental amount will attract applicable service tax.", attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
            
            let combination = NSMutableAttributedString()
            combination.append(attributedString0)
            combination.append(attributedString1)
            combination.append(attributedString2)
            combination.append(attributedString3)
            combination.append(attributedString4)
            combination.append(attributedString5)
            combination.append(attributedString6)
            combination.append(attributedString7)
        
            self.fareDetailsTextView.attributedText = combination
            
        }else if isCommingFrom == "Transfer"{
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.alignment = NSTextAlignment.left
            attributedStringParagraphStyle.lineSpacing = 5.0
            
            let attributedString0 = NSAttributedString(string: "Fare Details : \n", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            
            let attributedString1 = NSAttributedString(string: "Waiting Charges : \n" + "+ ₹ \(self.waitingCharge) " + "Per Hour \n\n" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
            
            let attributedString2 = NSAttributedString(string: "Basic Fare : " + "\(self.mBasicFare)" + " X 1 = " + "\(self.mBasicFare) /-" + "\n" + "Service Tax Amount = \(mServiceTax) /-\n" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
            
            let attributedString3 = NSAttributedString(string: "Total Cost = \(mTotalFare) /-", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            
            let attributedString4 = NSAttributedString(string: "\n\nTerms & Conditions : \n", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            
            let attributedString5 = NSAttributedString(string: "-> Parking will be extra as actual.\n" + "-> Pick up location to drop location route is fixed so cannot be altered as per the customer request .\n\n" + "-> One day means a one calendar day (from midnight 12 to midnight 12).\n" + "-> Toll taxes, parkings, state taxes paid by customer wherever is applicable.\n" + "-> Distance will be calculated from garage to garage.\n" + "-> The final cab rental amount will attract applicable service tax.", attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
            
            let combination = NSMutableAttributedString()
            combination.append(attributedString0)
            combination.append(attributedString1)
            combination.append(attributedString2)
            combination.append(attributedString3)
            combination.append(attributedString4)
            combination.append(attributedString5)
            
            self.fareDetailsTextView.attributedText = combination
            
        } else if isCommingFrom == "Outstation"{
            if (trip_type == "1"){
                //Roundtrip
                let attributedStringParagraphStyle = NSMutableParagraphStyle()
                attributedStringParagraphStyle.alignment = NSTextAlignment.left
                attributedStringParagraphStyle.lineSpacing = 5.0
                
                var attributedString2 = NSAttributedString()
                var attributedString3 = NSAttributedString()
                var attributedString4 = NSAttributedString()
                var attributedString5 = NSAttributedString()
                var attributedString6 = NSAttributedString()
                
                let attributedString1 = NSAttributedString(string: "Fare Details : \n", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                attributedString2 = NSAttributedString(string: "Approximate Roundtrip distance : " + "\(self.mApproxDistance) Km" + "\n" + "Minimum charged distance : " + "\(self.minChargeDistance) Km/day", attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])

                var total_distance = Int()
                var total_driver_charges = Int()
                var total_dist_with_perkm_charges = Int()
                if let intDays = Int(self.dayForOutstation){
                    total_distance = intDays * self.minChargeDistance
                    total_driver_charges = intDays * self.mDriverCharges
                }
                if let intVal = Int(perKmRate){
                    total_dist_with_perkm_charges = intVal * total_distance
                }
                
                attributedString3 = NSAttributedString(string: "Estimated Km Charged : " + "\(total_distance)" + " X " + "\(perKmRate) = " + "\(total_dist_with_perkm_charges) /-" + "\n" + "Driver Allowance : " + "\(self.mDriverCharges)" + " X \(self.dayForOutstation)" + "  = \(total_driver_charges) /-" + "\n" + "Night Charges = \(nightCharges) /-" + "\n" + "Service Tax Amount = \(mServiceTax) /-\n" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
                
                attributedString4 = NSAttributedString(string: "Total Cost = \(mTotalFare) /-", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                attributedString5 = NSAttributedString(string: "\n\nIf you will use car/cab more than " + "\(self.dayForOutstation) day(s) and " + "\(total_distance) Km, extra charges as follows;\n" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                attributedString6 = NSAttributedString(string: "After : " + "\(total_distance) Km & " + "\n+" + " ₹ " + perKmRate + " Per Km\n\n" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
                
                let attributedString7 = NSAttributedString(string: "\n\nTerms & Conditions : \n", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                let attributedString8 = NSAttributedString(string: "-> One day means a one calendar day (from midnight 12 to midnight 12).\n" + "-> Toll taxes, parkings, state taxes paid by customer wherever is applicable.\n" + "-> For all calculations distance from pick up point to the drop point & back to pick up point will be considered.\n" + "-> Distance will be calculated from garage to garage.\n" + "-> The final cab rental amount will attract applicable service tax.", attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
                
                let combination = NSMutableAttributedString()
                combination.append(attributedString1)
                combination.append(attributedString2)
                combination.append(attributedString3)
                combination.append(attributedString4)
                combination.append(attributedString5)
                combination.append(attributedString6)
                combination.append(attributedString7)
                combination.append(attributedString8)
                
                self.fareDetailsTextView.attributedText = combination
            
            }else if (trip_type == "2"){
                //Oneway
                let attributedStringParagraphStyle = NSMutableParagraphStyle()
                attributedStringParagraphStyle.alignment = NSTextAlignment.left
                attributedStringParagraphStyle.lineSpacing = 5.0
                
                var attributedString3 = NSAttributedString()
                var attributedString4 = NSAttributedString()
                var attributedString5 = NSAttributedString()
                var attributedString6 = NSAttributedString()
                
                let attributedString1 = NSAttributedString(string: "Fare Details : \n", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                let attributedString2 = NSAttributedString(string: "Approximate Oneway distance : " + "\(self.mApproxDistance * 2) Km" + "\n" + "Minimum charged distance : " + "\(self.minChargeDistance) Km/day\n\n", attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
                
                var total_distance = Int()
                var total_driver_charges = Int()
                var total_dist_with_perkm_charges = Int()
                var total_leftover_charge = Int()
                var both_side = Int()
                if let intDays = Int(self.dayForOutstation){
                    total_distance = intDays * self.minChargeDistance
                    total_driver_charges = intDays * self.mDriverCharges
                }
                if let intVal = Int(perKmRate){
                    total_dist_with_perkm_charges = intVal * mApproxDistance
                    both_side = intVal + leftOverSide
                    total_leftover_charge = leftOverSide * mApproxDistance
                }
                
                attributedString3 = NSAttributedString(string: "Approx Oneway Distance : " + "\(mApproxDistance)" + " X " + "\(perKmRate) = " + "\(total_dist_with_perkm_charges) /-\n" + "Approx Leftover Distance : " + "\(mApproxDistance)" + " X " + "\(leftOverSide) = " + "\(total_leftover_charge) /-" + "\n" + "Driver Allowance : " + "\(self.mDriverCharges)" + " X \(self.dayForOutstation)" + "  = \(total_driver_charges) /-" + "\n" + "Night Charges = \(nightCharges) /-" + "\n" + "Service Tax Amount = \(mServiceTax) /-\n" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
                
                attributedString4 = NSAttributedString(string: "Total Cost = \(mTotalFare) /-", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                attributedString5 = NSAttributedString(string: "\n\nIf you will use car/cab more than " + "\(self.dayForOutstation) day(s) and " + "\(mApproxDistance) Km, extra charges as follows;\n" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                attributedString6 = NSAttributedString(string: "After : " + "\(mApproxDistance) Km : " + "\n+" + " ₹ " + perKmRate + " /Km (One Side)\n+" + " ₹ " + "\(leftOverSide)" + " /Km (Leftover Side)\n+" + " ₹ " + "\(both_side)" + " /Km (Both Side)" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
                
                let attributedString7 = NSAttributedString(string: "\n\nTerms & Conditions : \n", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                let attributedString8 = NSAttributedString(string: "-> One day means a one calendar day (from midnight 12 to midnight 12).\n" + "-> Toll taxes, parkings, state taxes paid by customer wherever is applicable.\n" + "-> For all calculations distance from pick up point to the drop point & back to pick up point will be considered.\n" + "-> Distance will be calculated from garage to garage.\n" + "-> The final cab rental amount will attract applicable service tax.", attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
                
                let combination = NSMutableAttributedString()
                combination.append(attributedString1)
                combination.append(attributedString2)
                combination.append(attributedString3)
                combination.append(attributedString4)
                combination.append(attributedString5)
                combination.append(attributedString6)
                combination.append(attributedString7)
                combination.append(attributedString8)
                
                self.fareDetailsTextView.attributedText = combination
            
            }else{
                //Multicity
                let attributedStringParagraphStyle = NSMutableParagraphStyle()
                attributedStringParagraphStyle.alignment = NSTextAlignment.left
                attributedStringParagraphStyle.lineSpacing = 5.0
                
                var attributedString2 = NSAttributedString()
                var attributedString3 = NSAttributedString()
                var attributedString4 = NSAttributedString()
                var attributedString5 = NSAttributedString()
                var attributedString6 = NSAttributedString()
                
                let attributedString1 = NSAttributedString(string: "Fare Details : \n", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                attributedString2 = NSAttributedString(string: "Approximate Multicity distance : " + "\(self.minChargeDistance) Km" + "\n" + "Minimum charged distance : " + "\(self.minChargeDistance) Km/day", attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
                
                var total_distance = Int()
                var total_driver_charges = Int()
                var total_dist_with_perkm_charges = Int()
                if let intDays = Int(self.dayForOutstation){
                    total_distance = intDays * self.minChargeDistance
                    total_driver_charges = intDays * self.mDriverCharges
                }
                if let intVal = Int(perKmRate){
                    total_dist_with_perkm_charges = intVal * total_distance
                }
                
                attributedString3 = NSAttributedString(string: "Estimated Km Charged : " + "\(total_distance)" + " X " + "\(perKmRate) = " + "\(total_dist_with_perkm_charges) /-" + "\n" + "Driver Allowance : " + "\(self.mDriverCharges)" + " X \(self.dayForOutstation)" + "  = \(total_driver_charges) /-" + "\n" + "Night Charges = \(nightCharges) /-" + "\n" + "Service Tax Amount = \(mServiceTax) /-\n" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
                
                attributedString4 = NSAttributedString(string: "Total Cost = \(mTotalFare) /-", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                attributedString5 = NSAttributedString(string: "\n\nIf you will use car/cab more than " + "\(self.dayForOutstation) day(s) and " + "\(total_distance) Km, extra charges as follows;\n" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                attributedString6 = NSAttributedString(string: "After : " + "\(total_distance) Km &" + "\(self.dayForOutstation) Day(s) : " + "\n+" + " ₹ " + perKmRate + " /Km\n+" + " ₹ " + "\(mDriverCharges)" + " /day (Driver Charges)" , attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
                
                let attributedString7 = NSAttributedString(string: "\n\nTerms & Conditions : \n", attributes:[NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                let attributedString8 = NSAttributedString(string: "-> One day means a one calendar day (from midnight 12 to midnight 12).\n" + "-> Toll taxes, parkings, state taxes paid by customer wherever is applicable.\n" + "-> For all calculations distance from pick up point to the drop point & back to pick up point will be considered.\n" + "-> Distance will be calculated from garage to garage.\n" + "-> The final cab rental amount will attract applicable service tax.", attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.paragraphStyle: attributedStringParagraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.5))])
                
                let combination = NSMutableAttributedString()
                combination.append(attributedString1)
                combination.append(attributedString2)
                combination.append(attributedString3)
                combination.append(attributedString4)
                combination.append(attributedString5)
                combination.append(attributedString6)
                combination.append(attributedString7)
                combination.append(attributedString8)
                
                self.fareDetailsTextView.attributedText = combination
            }
        }
    }

}
