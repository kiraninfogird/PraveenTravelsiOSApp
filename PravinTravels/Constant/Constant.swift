//
//  Constant.swift
//  PravinTravels
//
//  Created by IIPL 5 on 15/01/19.
//  Copyright © 2019 IIPL 5. All rights reserved.
//

import UIKit

class Constant: NSObject {
    
    static var BASE_URL_DOMAIN = "https://"
    static var BASE_URL = "http://parveentravelstest.safegird.com/api/customer/" // test
    static var API_KEY = "S2AORU-KOXBNK-161JB3-S5HFAV-CI5O47" // test
    
//    static var BASE_URL = "http://clearcarrental.cabsaas.com/api/ccrcustomer/" // live
//    static var API_KEY = "PVU1ZE-ZE4TPC-5IXWAJ-P2E6ZE-QONPEC-4IUGWD"  // live
    
    static var USER_IP_ADDRESS = "255.249.155.5"
    static var USER_ID = "1212"
    static var USER_AGENT = "iOSApp"
//    static var CAB_PHOTO = "https://www.clearcarrental.com/photocar/"
    static var CAB_PHOTO = "http://parveentravelstest.safegird.com/images/vehicle/"

    static var SIGN_IN = "signIn/?"
    static var SIGN_UP = "signUp/?"
    static var FORGOT_PASSWORD = "forgetPass/?"
    static var CHANGE_PASSWORD = "changePassword/?"
    static var RESET_PASSWORD = "resetPass/?"
    static var MY_PROFILE_DETAILS = "basicDetails/?"
    static var GET_CCR_CASH_WALLET_BALANCE = "cashWallet/?"
    static var ADD_CASH_WALLET_BALANCE = "cashWalletAdd/?"
    static var MY_BOOKING = "customerBooking/?"
    static var BOOKING_CANCELLATION = "cancellation/?"
    static var LOGIN_WITH_FACEBOOK = "faceCheck/?"
    static var LOGIN_WITH_GOOGLE = "googleSignUp/?"
    static var GET_CITY_LIST = "getsourcecity/?"
//    static var SOURCE_CITY = "getsourcecity/?"
//    static var DESTINATION_CITY = "getsourcecity/?"
    static var CITY_LOCATION = "cityLocation/?"
    static var VEHICLE_SEARCH_RESULT = "vehiclesearchresultapp/?"
    static var COUPON_CODE = "coupon/?"
    static var BOOKING_REQUEST_NEW = "bookingRequestNew/?"
    static var BOOKING_CONFIRM_NEW = "bookingConfirmNew/?"
    static var CITY_LOCAL_PKG = "getcitylocalpkg/?"
    static var BOOKING_BEFORE = "bookingbefore/?"//tripTypeOption=4
    
    // MARK:- NSUserDefault
    
    static var LOGIN_USER_ID = "login_user_id"
    static var LOGIN_USER_EMAIL = "login_user_email"
    static var END_DATE = "end_date"
    static var LOGIN_USER_DETAILS = "login_user_details"
    static var LOGIN_WITH_GOOGLE_OR_FACEBOOK = "login_with_google_or_facebook"
}
