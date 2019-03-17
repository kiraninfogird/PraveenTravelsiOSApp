//
//  SearchACabViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 31/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchACabViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- Variable Declarations
    
    var journey_route = ""
    var comming_vc_name = ""
    var packageName = ""
    var mTrip_type_option = ""
    var mTravel_type_option = ""
    var source_city_name = ""
    var destination_city_name = ""
    var journey_travel_Date = ""
    var journey_end_date = ""
    var no_of_days = Int()
    var journey_pickup_time = ""
    var pickup_location = ""
    var drop_location = ""
    
    var mSearchItems = [[String : AnyObject]]()
    var mDealItems = [[String : AnyObject]]()
    var isFromTransfer = false
    var mTotalAmt = Double()
    var mDiscountPercentage = Double()
    
    @IBOutlet var routeLabel: UILabel!
    @IBOutlet var mTableView: UITableView!
    @IBOutlet var noDataLabel: UILabel!
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routeLabel.text = journey_route
        self.mTableView.register(UINib(nibName: "OnewayDealTableViewCell", bundle: nil), forCellReuseIdentifier: "OnewayDealTableViewCell")
        callToAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Search A Cab"
//        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.noDataLabel.isHidden = true
        mTableView.tableFooterView = UIView(frame: .zero)// Remove empty cell from tableview
    }
    
    //MARK:- TableView DataSource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mSearchItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  comming_vc_name == "Deal"{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "OnewayDealTableViewCell")! as! OnewayDealTableViewCell
            
            let dict : NSDictionary = mSearchItems[indexPath.row] as NSDictionary
            var imageURL = ""
            
            cell2.bookDealButton.layer.cornerRadius = 0.3 *
                cell2.bookDealButton.frame.size.height
            
            if let vehicleName = dict["vehicleName"] as? String{
                cell2.carNameLabel.text = vehicleName
            }else{
                cell2.carNameLabel.text = "NA"
            }
            if let vehicleSeatCapacityNo = dict["vehicleSeatCapacityNo"] as? Int{
                cell2.carDetailsLabel.text = " AC | \(vehicleSeatCapacityNo) Seats"
            }else if let vehicleSeatCapacityNo = dict["vehicleSeatCapacityNo"] as? String{
                cell2.carDetailsLabel.text = " AC | \(vehicleSeatCapacityNo) Seats"
            }else{
                cell2.carDetailsLabel.text = "NA"
            }
            if let travelDate = dict["travelDate"] as? String{
                cell2.dateLabel.text = travelDate
            }else{
                cell2.dateLabel.text = "NA"
            }
            if let fromTimeNew = dict["fromTimeNew"] as? String{
                if let toTimeNew = dict["toTimeNew"] as? String{
                    cell2.timeLabel.text = fromTimeNew + " To " + toTimeNew
                }else{
                    cell2.timeLabel.text = "NA"
                }
            }else{
                cell2.timeLabel.text = "NA"
            }
            if let totalAmount = dict["totalAmount"] as? Int{
                cell2.totalAmountButton.setTitle("₹ " + "\(totalAmount)", for: .normal)
                self.mTotalAmt = Double(totalAmount)
            }else if let totalAmount = dict["totalAmount"] as? Double{
                cell2.totalAmountButton.setTitle("₹ " + "\(totalAmount)", for: .normal)
                self.mTotalAmt = totalAmount
            }else{
                cell2.totalAmountButton.setTitle("₹ 0", for: .normal)
                self.mTotalAmt = 0
            }
            if let basicFare = dict["basicFare"] as? Int{
                cell2.cutAmountLabel.text = "₹ " + "\(basicFare)"
                self.mDiscountPercentage = (Double(basicFare) - self.mTotalAmt) * 100 / Double(basicFare)
                cell2.disPercentLabel.text = "\(self.mDiscountPercentage)" + " %"
            }else if let basicFare = dict["basicFare"] as? Double{
                cell2.cutAmountLabel.text = "₹ " + "\(basicFare)"
                self.mDiscountPercentage = (basicFare - self.mTotalAmt) * 100 / basicFare
                cell2.disPercentLabel.text = "\(self.mDiscountPercentage)" + " %"
            }else{
                cell2.cutAmountLabel.text = "₹ " + "0"
                self.mDiscountPercentage = 0.0
                cell2.disPercentLabel.text = "\(self.mDiscountPercentage)" + " %"
            }
            // make cell2.totalAmountButton Label dashed line
            let mViewBorder = CAShapeLayer()
            mViewBorder.strokeColor = UIColor.magenta.cgColor
            mViewBorder.lineDashPattern = [2, 2]
            mViewBorder.frame = cell2.totalAmountButton.bounds
            mViewBorder.fillColor = nil
            mViewBorder.path = UIBezierPath(rect: cell2.totalAmountButton.bounds).cgPath
            cell2.totalAmountButton.layer.addSublayer(mViewBorder)
            
            // make cell2.dashLabel Label dashed line
            let mViewBorder2 = CAShapeLayer()
            mViewBorder2.strokeColor = UIColor.magenta.cgColor
            mViewBorder2.lineDashPattern = [2, 2]
            mViewBorder2.frame = cell2.dashLabel.bounds
            mViewBorder2.fillColor = nil
            mViewBorder2.path = UIBezierPath(rect: cell2.dashLabel.bounds).cgPath
            cell2.dashLabel.layer.addSublayer(mViewBorder2)
            
            if let vPhoto = dict["vPhoto"] as? String{
                imageURL  = vPhoto
            }
            let todosEndpoint: String = Constant.CAB_PHOTO
            Alamofire.request(todosEndpoint + imageURL).responseImage { response in
                debugPrint(response)
                if let image = response.result.value {
                    cell2.carImageView.image = image
                }else{
                    cell2.carImageView.image = nil
                }
            }
            if let delaExpire = dict["delaExpire"] as? Int{
                if (delaExpire != 0){
                    cell2.bookDealButton.setTitle("Sold Out", for: .normal)
                    cell2.bookDealButton.backgroundColor = UIColor.lightGray
                    cell2.bookDealButton.isUserInteractionEnabled = false
                }else{
                    cell2.bookDealButton.setTitle("Book Deal", for: .normal)
                    cell2.bookDealButton.backgroundColor = UIColor.blue
                    cell2.bookDealButton.isUserInteractionEnabled = true
                }
            }
            
            cell2.bookDealButton.tag = indexPath.row
            cell2.bookDealButton.addTarget(self, action: #selector(SearchACabViewController.actionOnBookDealButtonClick(_:)), for: .touchUpInside)
            
            return cell2
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CabTableViewCell")! as! CabTableViewCell
            
            let dict : NSDictionary = mSearchItems[indexPath.row] as NSDictionary
            var imageURL = ""
            
            cell.bookCabButton.layer.cornerRadius = 0.3 *
                cell.bookCabButton.frame.size.height
            
            if let vehicle_name = dict["vehicle"] as? String{
                cell.carNameLabel.text = vehicle_name
            }else{
                cell.carNameLabel.text = "NA"
            }
            if let seatingCapacity = dict["seatingCapacity"] as? Int{
                if let vehicleCategory = dict["VehicleCategory"]{
                    let str = String(describing: vehicleCategory)
                    if let vCat = str as? String{
                        cell.carDetailsLabel.text = "\(vCat)" + " | " + "\(seatingCapacity) Seats"
                    }
                }else{
                    cell.carDetailsLabel.text = "\(seatingCapacity) Seats"
                }
            }else{
                cell.carDetailsLabel.text = "NA"
            }
            if (!isFromTransfer){
                if let perKm = dict["perKm"] as? String{
                    cell.perKmLabel.text = "₹ " + perKm
                }else if let perKm = dict["perKm"] as? Int{
                    cell.perKmLabel.text = "₹ " + "\(perKm)"
                }else if let perKm = dict["perKm"] as? Double{
                    cell.perKmLabel.text = "₹ " + "\(perKm)"
                }else{
                    cell.perKmLabel.text = "NA"
                }
                if let advanceamount = dict["advanceamount"] as? Int{
                    cell.advanceAmtLabel.text = "₹ " + "\(advanceamount)"
                }else if let advanceamount = dict["advanceamount"] as? Double{
                    cell.advanceAmtLabel.text = "₹ " + "\(advanceamount)"
                }else{
                    cell.advanceAmtLabel.text = "₹ " + "0"
                }
            }else{
                cell.perKmLabel.text = ""
                cell.advanceAmtLabel.text = ""
                cell.advanceStaticLabel.text = ""
                cell.perKmStaticLabel.text = ""
            }
            if let totalAmount = dict["totalAmount"] as? Int{
                cell.totalAmtLabel.text = "₹ " + "\(totalAmount)"
            }else if let totalAmount = dict["totalAmount"] as? Double{
                cell.totalAmtLabel.text = "₹ " + "\(totalAmount)"
            }else if let totalAmount = dict["localBasicRate"] as? Int{
                cell.totalAmtLabel.text = "₹ " + "\(totalAmount)"
            }else if let totalAmount = dict["transferBasicRate"] as? Int{
                cell.totalAmtLabel.text = "₹ " + "\(totalAmount)"
            }else{
                cell.totalAmtLabel.text =  "₹ " + "0"
            }
            if let vpic = dict["vpic"] as? String{
                imageURL  = vpic
            }
            let todosEndpoint: String = Constant.CAB_PHOTO
            Alamofire.request(todosEndpoint + imageURL).responseImage { response in
                debugPrint(response)
                if let image = response.result.value {
                    cell.carImageView.image = image
                }else{
                    cell.carImageView.image = nil
                }
            }
            
            cell.bookCabButton.tag = indexPath.row
            cell.bookCabButton.addTarget(self, action: #selector(SearchACabViewController.actionOnBookCabButtonClick(_:)), for: .touchUpInside)
            
            cell.fareDetailsButton.tag = indexPath.row
            cell.fareDetailsButton.addTarget(self, action: #selector(SearchACabViewController.actionOnFareDetailsButtonClick(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
    
    // MARK:- IBAction Methods
    
    @objc func actionOnBookCabButtonClick(_ sender: UIButton)  {
        let mButton : UIButton = sender
        let selectedObject = self.mSearchItems[mButton.tag]
        var mVehicleName = "NA"
        var mTAmt = Double()
        var mAdvAmt = Double()
        var mBasicAmt = Double()
        var mSerTaxAmt = Double()
        
        if let vehicle = selectedObject["vehicle"] as? String{
            mVehicleName = vehicle
        }
        if let totalAmount = selectedObject["totalAmount"] as? Int{
            mTAmt = Double(totalAmount)
        }else if let totalAmount = selectedObject["totalAmount"] as? Double{
            mTAmt = totalAmount
        }
        if let advanceamount = selectedObject["advanceamount"] as? Int{
            mAdvAmt = Double(advanceamount)
        }else if let advanceamount = selectedObject["advanceamount"] as? Double{
            mAdvAmt = advanceamount
        }
        if let serviceTaxAmount = selectedObject["serviceTaxAmount"] as? Int{
            mSerTaxAmt = Double(serviceTaxAmount)
        }else if let serviceTaxAmount = selectedObject["serviceTaxAmount"] as? Double{
            mSerTaxAmt = serviceTaxAmount
        }
        if let basicRate = selectedObject["basicRate"] as? Int{
            mBasicAmt = Double(basicRate)
        }else if let basicRate = selectedObject["basicRate"] as? Double{
            mBasicAmt = basicRate
        }else if let localBasicRate = selectedObject["localBasicRate"] as? Int{
            mBasicAmt = Double(localBasicRate)
        }else if let localBasicRate = selectedObject["localBasicRate"] as? Double{
            mBasicAmt = localBasicRate
        }
        
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookPopUpViewController") as! BookPopUpViewController
        popOverVC.mTotalAmount = mTAmt
        popOverVC.mAdvanceAmt = mAdvAmt
        popOverVC.mServiceTaxAmount = mSerTaxAmt
        popOverVC.mbasicAmount = mBasicAmt
        //
        popOverVC.mCarName = mVehicleName
        popOverVC.pickupCity_B = source_city_name
        popOverVC.dropCity_B = destination_city_name
        popOverVC.travelDate_B = journey_travel_Date
        popOverVC.PickUpTime_B = journey_pickup_time
        popOverVC.travelEndDate_B = journey_end_date
        popOverVC.days_B = "\(no_of_days)"
        popOverVC.mCommingVCName_B = comming_vc_name
        popOverVC.tripType_B = mTrip_type_option
        popOverVC.tripRoot_B = mTravel_type_option
        popOverVC.packageName_B = packageName
        popOverVC.pickUpLocation_B = pickup_location
        popOverVC.dropLocation_B = drop_location
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @objc func actionOnFareDetailsButtonClick(_ sender: UIButton)  {
        let mButton : UIButton = sender
        let selectedObject = self.mSearchItems[mButton.tag]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FareDetailsViewController") as! FareDetailsViewController
        vc.mSelectedDict = selectedObject
        vc.isCommingFrom = comming_vc_name
        vc.mLocalPackageStr = packageName
        vc.trip_type = mTrip_type_option
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func actionOnBookDealButtonClick(_ sender: UIButton)  {
        let mButton : UIButton = sender
        let selectedObject = self.mSearchItems[mButton.tag]
        var mDealId = Int()
        var mDealAmt = Double()
        var mGSTAmt = Double()
        var mTotalCost = Double()
        var mTotalKm = ""
        var mPerKm = ""
        var mDate = ""
        var mVehicleName = ""

        if let vehicle = selectedObject["vehicle"] as? String{
            mVehicleName = vehicle
        }
        if let dealId = selectedObject["dealId"] as? Int{
            mDealId = dealId
        }
        if let totalAmount = selectedObject["totalAmount"] as? Int{
            mTotalCost = Double(totalAmount)
        }else if let totalAmount = selectedObject["totalAmount"] as? Double{
            mTotalCost = totalAmount
        }
        if let dealFare = selectedObject["dealFare"] as? Int{
            mDealAmt = Double(dealFare)
        }else if let dealFare = selectedObject["dealFare"] as? Double{
            mDealAmt = dealFare
        }
        if let serviceTaxAmount = selectedObject["serviceTaxAmount"] as? Int{
            mGSTAmt = Double(serviceTaxAmount)
        }else if let serviceTaxAmount = selectedObject["serviceTaxAmount"] as? Double{
            mGSTAmt = serviceTaxAmount
        }
        if let distance = selectedObject["distance"] as? Int{
            mTotalKm = "\(distance)"
        }else if let distance = selectedObject["distance"] as? Double{
            mTotalKm = "\(Int(distance))"
        }
        if let extKm = selectedObject["extKm"] as? Int{
            mPerKm = "\(extKm)"
        }else if let extKm = selectedObject["extKm"] as? Double{
            mPerKm = "\(Int(extKm))"
        }else if let extKm = selectedObject["extKm"] as? String{
            mPerKm = extKm
        }
        if let travelDate = selectedObject["travelDate"] as? String{
            mDate = travelDate
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnewayDealTermsConditionViewController") as! OnewayDealTermsConditionViewController
        vc.dealId = mDealId
        vc.dealAmt = mDealAmt
        vc.gstAmt = mGSTAmt
        vc.totalCost = mTotalCost
        vc.totalKm = mTotalKm
        vc.perKm = mPerKm
        vc.travelDateStr = mDate
        vc.carName = mVehicleName
        vc.pickupCity = source_city_name
        vc.dropCity = destination_city_name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- Instance Methods
    
    func callToAPI()  {
        if comming_vc_name == "Local"{
            self.getSearchVechicleDetailAPICall(parameters_tripTypeOption: mTrip_type_option, parameters_sourceCity: source_city_name, parameters_travelDate: journey_travel_Date, parameters_days: "\(no_of_days)", parameters_pTime: journey_pickup_time, parameters_travelTypeOption: mTravel_type_option, parameters_HourlyPackage: packageName, parameters_responseType: "2")
            
        }else if  comming_vc_name == "Deal"{
            self.getSearchVechicleDetailForOneWayDealAPICall(parameters_tripTypeOption: "12", parameters_travelTypeOption: "7", parameters_sourceCity: source_city_name, parameters_destinationCity: destination_city_name, parameters_travelDate: journey_travel_Date, parameters_days: "\(no_of_days)", parameters_responseType: "2")
            
        }else if comming_vc_name == "Transfer"{
            isFromTransfer = true
            self.getSearchVechicleDetailForTransferAPICall(parameters_tripTypeOption: mTrip_type_option, parameters_travelTypeOption: mTravel_type_option, parameters_sourceCity: source_city_name, parameters_pickUpLocaction: pickup_location, parameters_dropLocation: drop_location, parameters_travelDate: journey_travel_Date, parameters_days: "\(no_of_days)", parameters_pTime: journey_pickup_time, parameters_responseType: "2")            
            
        }else if comming_vc_name == "Outstation"{
            self.getSearchVechicleDetailForOutstationAPICall(parameters_tripTypeOption: mTrip_type_option, parameters_sourceCity: source_city_name, parameters_destinationCity: destination_city_name, parameters_travelDate: journey_travel_Date, parameters_days: "\(no_of_days)", parameters_pTime: journey_pickup_time, parameters_travelTypeOption: mTravel_type_option, parameters_responseType: "2")
        }
    }
    
    // MARK:- API CALL Methods
    
    // Local
    func getSearchVechicleDetailAPICall(parameters_tripTypeOption: String, parameters_sourceCity: String, parameters_travelDate: String, parameters_days: String, parameters_pTime: String,parameters_travelTypeOption: String, parameters_HourlyPackage: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.VEHICLE_SEARCH_RESULT + "tripTypeOption=\(parameters_tripTypeOption)&sourceCity=\(parameters_sourceCity)&travelDate=\(parameters_travelDate)&days=\(parameters_days)&pTime=\(parameters_pTime)&travelTypeOption=\(parameters_travelTypeOption)&HourlyPackage=\(parameters_HourlyPackage)&responsetype=\(parameters_responseType)"
            
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
                                        if (responseCode == 0){
                                            self.mTableView.isHidden = true
                                            self.noDataLabel.isHidden = false
                                        }
                                    }
                                    if  let result = (data as? [String : AnyObject])?["result"]{
                                        if let dictionaryArray = result as? Array<Dictionary<String, AnyObject?>> {
                                            if dictionaryArray.count > 0 {
                                                self.mSearchItems =  dictionaryArray as [[String : AnyObject]]
                                                self.noDataLabel.isHidden = true
                                                self.mTableView.isHidden = false
                                                self.mTableView.reloadData()
                                            }else{
                                                self.mTableView.isHidden = true
                                                self.noDataLabel.isHidden = false
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
    
    //Oneway Deal
    func getSearchVechicleDetailForOneWayDealAPICall(parameters_tripTypeOption: String, parameters_travelTypeOption: String, parameters_sourceCity: String, parameters_destinationCity: String, parameters_travelDate: String, parameters_days: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.VEHICLE_SEARCH_RESULT + "tripTypeOption=\(parameters_tripTypeOption)&travelTypeOption=\(parameters_travelTypeOption)&sourceCity=\(parameters_sourceCity)&destinationCity=\(parameters_destinationCity)&travelDate=\(parameters_travelDate)&days=\(parameters_days)&responsetype=\(parameters_responseType)"
            
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
                                        if (responseCode == 0){
                                            self.mTableView.isHidden = true
                                            self.noDataLabel.isHidden = false
                                        }
                                    }
                                    if  let result = (data as? [String : AnyObject])?["result"]{
                                        if let dictionaryArray = result as? Array<Dictionary<String, AnyObject?>> {
                                            if dictionaryArray.count > 0 {
                                                self.mSearchItems =  dictionaryArray as [[String : AnyObject]]
                                                self.noDataLabel.isHidden = true
                                                self.mTableView.isHidden = false
                                                self.mTableView.reloadData()
                                            }else{
                                                self.mTableView.isHidden = true
                                                self.noDataLabel.isHidden = false
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
    
    // Transfer
    func getSearchVechicleDetailForTransferAPICall(parameters_tripTypeOption: String,parameters_travelTypeOption: String, parameters_sourceCity: String, parameters_pickUpLocaction: String, parameters_dropLocation: String, parameters_travelDate: String, parameters_days: String, parameters_pTime: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.VEHICLE_SEARCH_RESULT + "tripTypeOption=\(parameters_tripTypeOption)&travelTypeOption=\(parameters_travelTypeOption)&sourceCity=\(parameters_sourceCity)&pickUpLocation=\(parameters_pickUpLocaction)&dropLocation=\(parameters_dropLocation)&travelDate=\(parameters_travelDate)&days=\(parameters_days)&pTime=\(parameters_pTime)&responsetype=\(parameters_responseType)"
            
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
                                        if (responseCode == 0){
                                            self.mTableView.isHidden = true
                                            self.noDataLabel.isHidden = false
                                        }
                                    }
                                    if  let result = (data as? [String : AnyObject])?["result"]{
                                        if let dictionaryArray = result as? Array<Dictionary<String, AnyObject?>> {
                                            if dictionaryArray.count > 0 {
                                                self.mSearchItems =  dictionaryArray as [[String : AnyObject]]
                                                self.noDataLabel.isHidden = true
                                                self.mTableView.isHidden = false
                                                self.mTableView.reloadData()
                                            }else{
                                                self.mTableView.isHidden = true
                                                self.noDataLabel.isHidden = false
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

    // Outstation
    func getSearchVechicleDetailForOutstationAPICall(parameters_tripTypeOption: String, parameters_sourceCity: String, parameters_destinationCity: String, parameters_travelDate: String, parameters_days: String, parameters_pTime: String,parameters_travelTypeOption: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            
            let todosEndpoint: String = Constant.BASE_URL + Constant.VEHICLE_SEARCH_RESULT + "tripTypeOption=\(parameters_tripTypeOption)&sourceCity=\(parameters_sourceCity)&destinationCity=\(parameters_destinationCity)&travelDate=\(parameters_travelDate)&days=\(parameters_days)&pTime=\(parameters_pTime)&travelTypeOption=\(parameters_travelTypeOption)&responsetype=\(parameters_responseType)"
            
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
                                        if (responseCode == 0){
                                            self.mTableView.isHidden = true
                                            self.noDataLabel.isHidden = false
                                        }
                                    }
                                    if  let result = (data as? [String : AnyObject])?["result"]{
                                        if let dictionaryArray = result as? Array<Dictionary<String, AnyObject?>> {
                                            if dictionaryArray.count > 0 {
                                                self.mSearchItems =  dictionaryArray as [[String : AnyObject]]
                                                self.noDataLabel.isHidden = true
                                                self.mTableView.isHidden = false
                                                self.mTableView.reloadData()
                                            }else{
                                                self.mTableView.isHidden = true
                                                self.noDataLabel.isHidden = false
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
