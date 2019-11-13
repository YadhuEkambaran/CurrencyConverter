//
//  Constants.swift
//  CurrencyConvertor
//
//  Created by yadhukrishnan E on 12/11/19.
//  Copyright © 2019 AYA. All rights reserved.
//

import Foundation

class Constants {
    private static var BASE_URL = "https://free.currconv.com/api/v7/"
    public static var IMAGE_BASE_URL = "https://img.freeflagicons.com/thumb/round_icon/"
    
    public static var CURRENCY = BASE_URL + "currencies?apiKey=0c300b981bd3f8b45570"
    public static var COUNTRY = BASE_URL + "countries?apiKey=0c300b981bd3f8b45570"
    public static var CONVERT = BASE_URL + "convert?q=%@&compact=ultra&apiKey=0c300b981bd3f8b45570"
}
