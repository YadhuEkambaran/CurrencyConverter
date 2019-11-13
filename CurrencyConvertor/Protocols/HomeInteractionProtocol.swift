//
//  HomeInteractionProtocol.swift
//  CurrencyConvertor
//
//  Created by yadhukrishnan E on 12/11/19.
//  Copyright © 2019 AYA. All rights reserved.
//

import Foundation

protocol HomeInteractionProtocol {
    func onCountrySelected(forWhichOption isFrom: Bool ,selectedCountry country: Country)
}
