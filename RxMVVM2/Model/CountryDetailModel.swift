//
//  CountryDetailModel.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 03/07/2018.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//
struct CountryDetailModel: Codable {
    var name: String?
    var capital: String?
    var region: String?
    var subregion: String?
    var population: Int?
    var borders: [String]?
    var demonym: String?
    var currencies: [[String: String]]?
    
    init () {
        
    }
    
    init(name: String?, capital: String?, region: String?, subregion: String?, population: Int?, borders: [String]?, demonym: String?, currencies: [[String: String]]?) {
        self.name = name
        self.capital = capital
        self.region = region
        self.subregion = subregion
        self.population = population
        self.borders = borders
        self.demonym = demonym
        self.currencies = currencies
    }

    
}
