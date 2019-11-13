//
//  ViewController.swift
//  CurrencyConvertor
//
//  Created by yadhukrishnan E on 09/11/19.
//  Copyright © 2019 AYA. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeVC: UIViewController {

    static var DEFAULT_DISPLAY_VALUE = "1 %@ = %f %@"
    
    @IBOutlet weak var vFrom: UIView!
    @IBOutlet weak var vTo: UIView!
    @IBOutlet weak var vAmountContainer: UIView!
    @IBOutlet weak var vResultContainer: UIView!
    
    @IBOutlet weak var btnFromCurrency: UIButton!
    @IBOutlet weak var btnToCurrency: UIButton!
    @IBOutlet weak var ivFromFlag: UIImageView!
    @IBOutlet weak var ivToFlag: UIImageView!
    @IBOutlet weak var ivFromEditFlag: UIImageView!
    @IBOutlet weak var ivToEditFlag: UIImageView!
    
    @IBOutlet weak var labelConverteredValue: UILabel!
    @IBOutlet weak var labelFromTo: UILabel!
    @IBOutlet weak var labelToFrom: UILabel!
    
    @IBOutlet weak var tvAmount: UITextField!
    
    var countries: [Country] = []
    var defaultFromCountry: Country?
    var defaultToCountry: Country?
    
    var convertedValue: Double = 0.0
    var reverseConvertedValue: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        roundTopView(view: vFrom)
        roundBottomView(view: vTo)
        round(view: ivFromFlag)
        round(view: vAmountContainer)
        round(view: vResultContainer)
        round(radius: 20, view: labelFromTo)
        round(radius: 20, view: labelToFrom)
        
        addDoneButtonOnNumpad(textField: tvAmount)
        NetworkManager.fetchCountries(url: Constants.COUNTRY, networkListener: self)
    }

    func roundTopView(view: UIView) {
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    func roundBottomView(view: UIView) {
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }
    
    
    func round(view: UIView) {
        view.layer.cornerRadius = 10
    }
    
    func round(radius: Float, view: UIView) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(radius)
    }
    
    func setConvertedValues() {
        setDefaultAmount()
        labelConverteredValue.text = String(convertedValue)
        setDisplayValue()
    }
    
    func setDisplayValue() {
        labelFromTo.text = String(format: HomeVC.DEFAULT_DISPLAY_VALUE, defaultFromCountry!.currencyId, convertedValue, defaultToCountry!.currencyId)
        labelToFrom.text = String(format: HomeVC.DEFAULT_DISPLAY_VALUE, defaultToCountry!.currencyId, reverseConvertedValue, defaultFromCountry!.currencyId)
    }
    
    func setDefaultAmount() {
           tvAmount.text = "1"
    }
    
    func setDefaultConvertionParam() {
        if let tempFrom = defaultFromCountry, let tempTo = defaultToCountry {
            setFromDetails(country: tempFrom)
            setToDetails(country: tempTo)
        }
    }
    
    func setFromDetails(country: Country) {
        defaultFromCountry = country
        btnFromCurrency.setTitle(country.currencyId, for: .normal)
        if let temp = country.flagURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: temp) {
                    DispatchQueue.main.async {
                        self.ivFromFlag.image = UIImage(data: data)
                        self.ivFromFlag.highlightedImage = UIImage(data: data)
                        self.ivFromEditFlag.image = UIImage(data: data)
                        self.ivFromEditFlag.highlightedImage = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    func setToDetails(country: Country) {
        defaultToCountry = country
        btnToCurrency.setTitle(country.currencyId, for: .normal)
        if let temp = country.flagURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: temp) {
                    DispatchQueue.main.async {
                        self.ivToFlag.image = UIImage(data: data)
                        self.ivToFlag.highlightedImage = UIImage(data: data)
                        self.ivToEditFlag.image = UIImage(data: data)
                        self.ivToEditFlag.highlightedImage = UIImage(data: data)
                    }
                }
            }
        }
        
        convertCurrency()
    }
    
    func addDoneButtonOnNumpad(textField: UITextField) {

      let keypadToolbar: UIToolbar = UIToolbar()
      keypadToolbar.items=[
        UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textField, action: #selector(UITextField.resignFirstResponder)),
        UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
      ]
      keypadToolbar.sizeToFit()
      // add a toolbar with a done button above the number pad
      textField.inputAccessoryView = keypadToolbar
    }
    
    @IBAction func onDoneClicked(_ sender: Any) {
        let value = convertedValue
        let amount = Double(tvAmount.text!)!
        
        labelConverteredValue.text = "\(value * amount)"
    }
    
    @IBAction func onReverseClicked(_ sender: Any) {
        let temp = defaultFromCountry
        defaultFromCountry = defaultToCountry
        defaultToCountry = temp
        
        setDefaultConvertionParam()
    }
    
}

/**
    Code for setting country selected from the country list
 */
extension HomeVC: HomeInteractionProtocol {
    func onCountrySelected(forWhichOption isFrom: Bool, selectedCountry country: Country) {
        if isFrom {
            setFromDetails(country: country)
        } else {
            setToDetails(country: country)
        }
    }
}

/**
    All segue methods
 */
extension HomeVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! CurrencyVC
        controller.homeInteractor = self
        controller.countries = self.countries
        if segue.identifier == "fromCurrency" {
            controller.isFrom = true
        } else if segue.identifier == "toCurrency" {
            controller.isFrom = false
        }
    }
}

/**
    Code for API handling
 */
extension HomeVC: NetworkProtocol {
    
    func convertCurrency() {
        let from = btnFromCurrency.currentTitle!
        let to = btnToCurrency.currentTitle!
        
        let url = "\(from)_\(to),\(to)_\(from)"
        NetworkManager.fetchConvert(countryCode: url, networkListener: self)
    }
    
    func success(response: JSON) {
        if response["results"].exists() {
            let json = response["results"]
            parseCountryListAPI(countriesJSON: json)
        } else {
            convertedValue = Double(response[getConvertParam()].description)!
            reverseConvertedValue = Double(response[getReverseConvertParam()].description)!
            
            setConvertedValues()
        }
    }
    
    func failed(statusCode: Int, response: String) {
        print(response.debugDescription)
    }
    
    func parseCountryListAPI(countriesJSON: JSON) {
        for (_ ,country) in countriesJSON {
            
            let id = country["id"].description
            let alpha = country["alpha3"].description
            let currencyId = country["currencyId"].description
            let name = country["name"].description
            let currencyName = country["currencyName"].description
            let currencySymbol = country["currencySymbol"].description
            
            let temp = Country(id: id, alpha3: alpha, currencyId: currencyId, name: name, currencyName: currencyName, currencySymbol: currencySymbol)
            
            if id == "US" {
                defaultFromCountry = temp
            }
            
            if id == "CA" {
                defaultToCountry = temp
            }
            
            countries.append(temp)
        }
        
        countries.sort(by: { $0.currencyName < $1.currencyName })
        
        setDefaultConvertionParam()
    }
    
    func getConvertParam() -> String {
        let from = btnFromCurrency.currentTitle!
        let to = btnToCurrency.currentTitle!
        
        return "\(from)_\(to)";
    }
    
    func getReverseConvertParam() -> String {
        let from = btnFromCurrency.currentTitle!
        let to = btnToCurrency.currentTitle!
        
        return "\(to)_\(from)";
    }
}

