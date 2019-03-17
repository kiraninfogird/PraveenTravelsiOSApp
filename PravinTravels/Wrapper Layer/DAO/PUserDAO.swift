//
//  PUserDAO.swift
//  PravinTravels
//
//  Created by IIPL 5 on 15/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class PUserDAO: NSObject {
    
    static var instance: PUserDAO? = nil
    
    var masterSourceCityArray = [String]()
    var masterDestinationCityArray = [String]()
    var masterMutableDictForSourceCity = [String: Int]()
    var masterMutableDictForDestinationCity = [String: Int]()
    
    class var sharedInstance: PUserDAO {
        
        if instance == nil {
            self.instance = PUserDAO()
        }
        return self.instance!
    }
    
    // MARK:- City Name list Array
    
    // Save and Retrive the Source city array
    func saveMasterSourceCityArray(_ sourceCityArray: [String]) {
        masterSourceCityArray = sourceCityArray
    }
    
    func getMasterSourceCityArray() -> [String] {
        if masterSourceCityArray.isEmpty{
            return [""]
        }else{
            return masterSourceCityArray
        }
    }
    
    // Save and Retrive the Destination city array
    func saveMasterDestinationCityArray(_ destinationCityArray: [String]) {
        masterDestinationCityArray = destinationCityArray
    }
    
    func getMasterDestinationCityArray() -> [String] {
        if masterDestinationCityArray.isEmpty{
            return [""]
        }else{
            return masterDestinationCityArray
        }
    }
    
    // Save and Retrive the Source city mutable dictionary
    func saveMasterSourceCityMutableDictionary(_ sourceCityDict: [String: Int]) {
        masterMutableDictForSourceCity = sourceCityDict
    }
    
    func getMasterSourceCityMutableDictionary() -> [String:Int] {
        if masterMutableDictForSourceCity.isEmpty{
            return ["" : 0]
        }else{
            return masterMutableDictForSourceCity
        }
    }
    
    // Save and Retrive the Destination city mutable dictionary
    func saveMasterDestinationCityMutableDictionary(_ destinationCityDict: [String: Int]) {
        masterMutableDictForDestinationCity = destinationCityDict
    }
    
    func getMasterDestinationCityMutableDictionary() -> [String:Int] {
        if masterMutableDictForDestinationCity.isEmpty{
            return ["" : 0]
        }else{
            return masterMutableDictForDestinationCity
        }
    }

}
