//
//  Country.swift
//  CurrencyConvertor
//
//  Created by yadhukrishnan E on 12/11/19.
//  Copyright © 2019 AYA. All rights reserved.
//

import Foundation

class Country {
    var id: String
    var currencyId: String
    var alpha3: String
    var currencyName: String
    var currencySymbol: String
    var name: String
    var flagURL: URL?
    
    
    init(id: String, alpha3: String, currencyId: String, name: String, currencyName: String, currencySymbol: String) {
        self.id = id
        self.alpha3 = alpha3
        self.currencyId = currencyId
        self.name = name
        self.currencyName = currencyName
        self.currencySymbol = currencySymbol
        self.flagURL = URL(string: "\(Constants.IMAGE_BASE_URL)\(name.lowercased().replacingOccurrences(of: " ", with: "_"))/\(name.lowercased().replacingOccurrences(of: " ", with: "_"))_640.png")
        
        if let tempURL = flagURL {
            print(" URl -------\(tempURL)---------")
        }
    }
    
    
}
