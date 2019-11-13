//
//  NetworkProtocol.swift
//  CurrencyConvertor
//
//  Created by yadhukrishnan E on 12/11/19.
//  Copyright © 2019 AYA. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol NetworkProtocol {
    func success(response: JSON)
    func failed(statusCode: Int, response: String)
}
