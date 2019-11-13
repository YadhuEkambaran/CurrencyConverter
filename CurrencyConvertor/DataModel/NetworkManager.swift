//
//  NetworkManager.swift
//  CurrencyConvertor
//
//  Created by yadhukrishnan E on 12/11/19.
//  Copyright © 2019 AYA. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    static func fetchCurrencies(url: String ,networkListener: NetworkProtocol) {
        AF.request(url).responseJSON { (response) -> Void in
            switch response.result {
            case .success:
                let jsonDetails = JSON(response.value!)
                networkListener.success(response: jsonDetails)
            case let .failure(Error):
                networkListener.failed(statusCode: 404, response: Error.errorDescription!)
            }
        }
    }
    
    static func fetchCountries(url: String ,networkListener: NetworkProtocol) {
        AF.request(url).responseJSON { (response) -> Void in
            switch response.result {
            case .success:
                let jsonDetails = JSON(response.value!)
                networkListener.success(response: jsonDetails)
            case let .failure(Error):
                networkListener.failed(statusCode: 404, response: Error.errorDescription!)
            }
        }
    }
    
    static func fetchConvert(countryCode: String ,networkListener: NetworkProtocol) {
        let url = String(format: Constants.CONVERT, countryCode)
        print(url)
        AF.request(url).responseJSON { (response) -> Void in
            switch response.result {
            case .success:
                let jsonDetails = JSON(response.value!)
                networkListener.success(response: jsonDetails)
            case let .failure(Error):
                networkListener.failed(statusCode: 404, response: Error.errorDescription!)
            }
        }
    }
}
