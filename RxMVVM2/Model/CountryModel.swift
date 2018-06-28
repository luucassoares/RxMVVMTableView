//
//  CountryModel.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 25/06/18.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//

struct CountryModel: Codable {
    var name: String?
    var capital: String?
    var region: String?
    
    init(name: String?, capital: String, region: String?) {
        self.name = name
        self.capital = capital
        self.region = region
    }
    
    func toString(with country: CountryModel) -> (String) {
        return "name: \(country.name ?? "Nulo") -  capital: \(country.capital ?? "Nulo") - region: \(country.region ?? "Nulo")"
    }
   
}
