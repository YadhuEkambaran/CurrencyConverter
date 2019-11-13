//
//  Currency.swift
//  CurrencyConvertor
//
//  Created by yadhukrishnan E on 12/11/19.
//  Copyright © 2019 AYA. All rights reserved.
//

import Foundation

class Currency {
    var currencyShort: String
    var currencyFull: String
    
    init(currencyShortForm shortForm: String, currencyFullForm fullForm: String) {
        self.currencyShort = shortForm
        self.currencyFull = fullForm
    }
}
