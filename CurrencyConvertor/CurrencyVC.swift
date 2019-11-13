//
//  CurrencyVC.swift
//  CurrencyConvertor
//
//  Created by yadhukrishnan E on 11/11/19.
//  Copyright © 2019 AYA. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CurrencyVC: UITableViewController {
    
    var searchControllerBar: UISearchController!
    
    var countries: [Country]!
    var searchCountries: [Country] = []
    
    var homeInteractor: HomeInteractionProtocol?
    var isFrom: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
    }
    
    func configureSearchBar() {
        searchControllerBar = UISearchController(searchResultsController: nil)
        searchControllerBar.searchResultsUpdater = self
        searchControllerBar.obscuresBackgroundDuringPresentation = false
        searchControllerBar.searchBar.placeholder = "Search country"
        navigationItem.searchController = searchControllerBar
        definesPresentationContext = true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering {
            return searchCountries.count
        } else {
            return countries.count
        }
       
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country : Country
        if isFiltering {
            country = searchCountries[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyItem", for: indexPath)
        let countryFlag = cell.viewWithTag(1001) as! UIImageView
        let currencyLabel = cell.viewWithTag(1002) as! UILabel
        let countryName = cell.viewWithTag(1003) as! UILabel
        
        currencyLabel.text = country.name
        countryName.text = "\(country.currencyId) : \(country.currencyName)"
        if let temp = country.flagURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: temp) {
                    DispatchQueue.main.async {
                        countryFlag.image = UIImage(data: data)
                        countryFlag.highlightedImage = UIImage(data: data)
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry: Country
        if isFiltering {
            selectedCountry = searchCountries[indexPath.row]
        } else {
            selectedCountry = countries[indexPath.row]
        }
        
        if let tempInteractor = homeInteractor, let tempIsFrom = isFrom {
            tempInteractor.onCountrySelected(forWhichOption: tempIsFrom , selectedCountry: selectedCountry)
        }
        
        navigationController?.popViewController(animated: true)
    }

}

extension CurrencyVC: UISearchResultsUpdating {
    
    var isSearchEmpty: Bool {
        return searchControllerBar.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchControllerBar.isActive && !isSearchEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        if searchText.isEmpty {
            return
        }
        
        filterCountry(searchText: searchText)
    }
    
    func filterCountry(searchText: String) {
        searchCountries = countries.filter { country  in
            
            return country.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}

