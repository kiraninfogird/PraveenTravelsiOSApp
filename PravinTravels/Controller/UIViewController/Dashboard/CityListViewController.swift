//
//  CityListViewController.swift
//  PravinTravels
//
//  Created by IIPL 5 on 12/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit
import Alamofire

protocol SelectCityDelegate {
    func getCityNameAndID(_ mName : String, mID : Int)
}

class CityListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    //MARK:- Variable Declartation
    
    var cityItems = [[String : AnyObject]]()
    var cityItemsFiltered = [[String : AnyObject]]()
    var mDelegate: SelectCityDelegate?
    var cityId = Int()
    var tripType = Int()
    
    @IBOutlet var mSearchBarTextField: UISearchBar!
    @IBOutlet var mTableView: UITableView!
    @IBOutlet var noDataAvailableLabel: UILabel!
    
    //MARK:- ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mSearchBarTextField.delegate = self
        if (cityId == 0){
            self.getAllCityAPICall()
        }else{
            self.getPickUpAndDropCityLocationAPICall(parameters_cityId: "\(cityId)", parameters_tripType: "\(tripType)", parameters_responseType: "2")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Search City"
        self.navigationController?.isNavigationBarHidden = false
        mTableView.tableFooterView = UIView(frame: .zero)// Remove empty cell from tableview
    }

    //MARK:- SearchBar Delegate Methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cityItemsFiltered.removeAll()
        if searchText.utf8CString.count != 0 {
            for strCity in cityItems {
                if (cityId == 0){
                    //for City
                    if let ctname = strCity["ctname"] as? String{
                        let range = ctname.lowercased().range(of: searchText, options: .caseInsensitive, range: nil,   locale: nil)
                        if range != nil {
                            cityItemsFiltered.append(strCity)
                        }
                    }
                }else{
                    //for pickUp & Drop Location
                    if let locname = strCity["locname"] as? String{
                        let range = locname.lowercased().range(of: searchText, options: .caseInsensitive, range: nil,   locale: nil)
                        if range != nil {
                            cityItemsFiltered.append(strCity)
                        }
                    }
                }
            }
        } else {
            cityItemsFiltered = cityItems
        }
        mTableView.reloadData()
    }
    
    /*
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cityItemsFiltered.removeAll()
        if searchText.utf8CString.count != 0 {
            for strCity in cityItems {
                let ctname = strCity["ctname"] as! String
                let range = ctname.lowercased().range(of: searchText, options: .caseInsensitive, range: nil,   locale: nil)
                if range != nil {
                    cityItemsFiltered.append(strCity)
                }
            }
        } else {
            cityItemsFiltered = cityItems
        }
        mTableView.reloadData()
    }
    */
 
    //MARK:- UITableViewDataSource and Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cityItemsFiltered.count == 0{
            noDataAvailableLabel.isHidden = false
        }else{
            noDataAvailableLabel.isHidden = true
        }
        return cityItemsFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citycell")!
        let dict : NSDictionary = cityItemsFiltered[indexPath.row] as NSDictionary
        if (cityId == 0){
            if let ctname = dict["ctname"] as? String{
                cell.textLabel!.text = ctname
            }
        }else{
            if let locname = dict["locname"] as? String{
                cell.textLabel!.text = locname
            }
        }
        cell.textLabel?.textAlignment = .left
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict : NSDictionary = cityItemsFiltered[indexPath.row] as NSDictionary
        if (cityId == 0){
            if let ctname = dict["ctname"] as? String{
                if let cityId = dict["cityId"] as? Int{
                    self.mDelegate?.getCityNameAndID(ctname, mID: cityId)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else{
            if let locname = dict["locname"] as? String{
                if let locationId = dict["locationId"] as? Int{
                    self.mDelegate?.getCityNameAndID(locname, mID: locationId)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }

    }
    
    // MARK:- API CALL Methods
    
    func getAllCityAPICall(){
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            let todosEndpoint: String = Constant.BASE_URL + Constant.GET_CITY_LIST
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
                                    self.cityItems =  dictionaryArray as [[String : AnyObject]]
                                    self.cityItemsFiltered = self.cityItems
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
    
    func getPickUpAndDropCityLocationAPICall(parameters_cityId: String, parameters_tripType: String, parameters_responseType: String)  {
        
        if AppUtility.sharedInstance.mIsNetworkAvailable{
            let todosEndpoint: String = Constant.BASE_URL + Constant.CITY_LOCATION + "cityId=\(parameters_cityId)&tripType=\(parameters_tripType)&responsetype=\(parameters_responseType)"
            let escapedString = todosEndpoint.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            AppUtility.sharedInstance.showProgressIndicatorWith(message: "Fetching location...")
            
            Alamofire.request(escapedString!, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    AppUtility.sharedInstance.hideProgressIndicatorWith()
                    if let data = response.result.value{
                            if let apresult = (data as? [String : AnyObject])?["apresult"]{
                                if let dictionaryArray = apresult as? Array<Dictionary<String, AnyObject?>> {
                                    if dictionaryArray.count > 0 {
                                        self.cityItems =  dictionaryArray as [[String : AnyObject]]
                                        self.cityItemsFiltered = self.cityItems
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

}
