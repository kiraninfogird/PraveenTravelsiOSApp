//
//  BookPopUpViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 03/02/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class BookPopUpViewController: UIViewController, UITextFieldDelegate {

    //MARK:- Variable Declaration
    
    @IBOutlet var totalCarLabel: UITextField!
    @IBOutlet var paymentModeLabel: UITextField!
    @IBOutlet var carNameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var bookNowButton: UIButton!
    @IBOutlet var popUpView: UIView!
    
    var mTotalAmtForCheck = Double()
    var mAdvanceAmtForCheck = Double()
    
    var mAdvanceAmt = Double()
    var mbasicAmount = Double()
    var mServiceTaxAmount = Double()
    var mBalanceAmount = 0.0
    var isFullMode = true
    
    var mCarName = ""
    var mTotalAmount = Double()
    var noOfCar = 1
    var mCommingVCName_B = ""
    var pickupCity_B = ""
    var dropCity_B = ""
    var packageName_B = ""
    var travelDate_B = ""
    var travelEndDate_B = ""
    var PickUpTime_B = ""
    var days_B = ""
    var tripType_B = ""
    var tripRoot_B = ""
    var pickUpLocation_B = ""
    var dropLocation_B = ""
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carNameLabel.text = mCarName
        amountLabel.text = "₹ \(mTotalAmount)"
        totalCarLabel.text = "1"
        paymentModeLabel.text = "Full"
        mTotalAmtForCheck = mTotalAmount
        mAdvanceAmtForCheck = mAdvanceAmt
        
        bookNowButton.layer.cornerRadius = 0.3 *
            bookNowButton.frame.size.height
        popUpView.layer.cornerRadius = 5.0
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
    }
    
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if (textField == totalCarLabel){
            actionSheetForCar()
            return false
        }else{
            actionSheetForPaymentMode()
            return false
        }
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnCancelButton(_ sender: Any) {
        self.removeAnimate()
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    @IBAction func actionOnBookNowButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        vc.mUserVehicleName = mCarName
        if (isFullMode){
            vc.advance_Amt = 0.0
        }else{
            vc.advance_Amt = mAdvanceAmtForCheck//mAdvanceAmt
        }
        vc.basic_Amount = mbasicAmount
        vc.serviceTax_Amount = mServiceTaxAmount
        vc.balance_Amount = mBalanceAmount
        vc.total_Amount =   mTotalAmtForCheck//mTotalAmount
        vc.isPaymentModeFull = isFullMode
        //
        vc.mUserPickupCity = pickupCity_B
        vc.mUserDropCity = dropCity_B
        vc.mUserTravelDate = travelDate_B
        vc.mUserVehiclePickupTime = PickUpTime_B
        vc.mDay = days_B
        vc.mCars = "\(noOfCar)"
        vc.mCvcName = mCommingVCName_B
        vc.mUserTripType = tripType_B
        vc.mUserTripRoot = tripRoot_B
        vc.mUserPackageName = packageName_B
        vc.mUserPickupLocation = pickUpLocation_B
        vc.mUserDropLocation = dropLocation_B
        vc.mUserTravelEndDate = travelEndDate_B
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func actionSheetForCar()  {
        let actionSheet = UIAlertController(title: "Please select car", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        let one = UIAlertAction(title: "1", style: .default)
        { _ in
            print("1")
            self.isFullMode = true
            self.totalCarLabel.text = "1"
            self.paymentModeLabel.text = "Full"
            self.amountLabel.text = "₹ \(self.mTotalAmount * 1)"
            self.mTotalAmtForCheck = self.mTotalAmount * 1
            self.noOfCar = 1
        }
        let two = UIAlertAction(title: "2", style: .default)
        { _ in
            print("2")
            self.isFullMode = true
            self.paymentModeLabel.text = "Full"
            self.totalCarLabel.text = "2"
            self.amountLabel.text = "₹ \(self.mTotalAmount * 2)"
            self.mTotalAmtForCheck = self.mTotalAmount * 2
            self.noOfCar = 2
        }
        let three = UIAlertAction(title: "3", style: .default)
        { _ in
            print("3")
            self.isFullMode = true
            self.paymentModeLabel.text = "Full"
            self.totalCarLabel.text = "3"
            self.amountLabel.text = "₹ \(self.mTotalAmount * 3)"
            self.mTotalAmtForCheck = self.mTotalAmount * 3
            self.noOfCar = 3
        }
        let four = UIAlertAction(title: "4", style: .default)
        { _ in
            print("4")
            self.isFullMode = true
            self.paymentModeLabel.text = "Full"
            self.totalCarLabel.text = "4"
            self.amountLabel.text = "₹ \(self.mTotalAmount * 4)"
            self.mTotalAmtForCheck = self.mTotalAmount * 4
            self.noOfCar = 4
        }
        let five = UIAlertAction(title: "5", style: .default)
        { _ in
            print("5")
            self.isFullMode = true
            self.paymentModeLabel.text = "Full"
            self.totalCarLabel.text = "5"
            self.amountLabel.text = "₹ \(self.mTotalAmount * 5)"
            self.mTotalAmtForCheck = self.mTotalAmount * 5
            self.noOfCar = 5
        }
        actionSheet.addAction(one)
        actionSheet.addAction(two)
        actionSheet.addAction(three)
        actionSheet.addAction(four)
        actionSheet.addAction(five)
        actionSheet.addAction(cancelActionButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func actionSheetForPaymentMode()  {
        let actionSheet = UIAlertController(title: "Please select payment mode", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        let one = UIAlertAction(title: "Full", style: .default)
        { _ in
            print("Full")
            self.isFullMode = true
            self.mBalanceAmount = 0.0
//            self.mAdvanceAmt = 0.0
            self.paymentModeLabel.text = "Full"
            self.amountLabel.text = "₹ \(self.mTotalAmount * Double(self.noOfCar))"
        }
        let two = UIAlertAction(title: "Advance", style: .default)
        { _ in
            print("Advance")
            self.isFullMode = false
            self.paymentModeLabel.text = "Advance"
            self.amountLabel.text = "₹ \(self.mAdvanceAmt * Double(self.noOfCar))"
            self.mTotalAmtForCheck = self.mTotalAmount * Double(self.noOfCar)
            self.mAdvanceAmtForCheck = (self.mAdvanceAmt * Double(self.noOfCar))
            self.mBalanceAmount =  self.mTotalAmtForCheck - (self.mAdvanceAmt * Double(self.noOfCar))
        }
        actionSheet.addAction(one)
        actionSheet.addAction(two)
        actionSheet.addAction(cancelActionButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}
