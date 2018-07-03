//
//  ContactsService.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 25/06/18.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//

import Foundation
import RxSwift



class ContactsService {
    
    
    static func fetchModels() -> Single<[CountryModel]> {
        return Single<[CountryModel]>.create { single in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                var models: [CountryModel] = []
                
                URLSession.shared.dataTask(with: URL(string: "https://restcountries.eu/rest/v2/all")!) { (data, response, error) in
                    
            
                    models = try! JSONDecoder().decode([CountryModel].self, from: data!)
         
                    single(.success(models))
                }.resume()
            }
            
            return Disposables.create { }
        }
    }
    
    static func getDetails(countryName: String) -> Single<[CountryDetailModel]> {
        return Single<[CountryDetailModel]>.create { single in
            DispatchQueue.main.async {
                var model: [CountryDetailModel] = []
                
                let url = URL(string: "https://restcountries.eu/rest/v2/name/\(countryName)")!
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                    
                    model = try! JSONDecoder().decode([CountryDetailModel].self, from: data!)
                    
                    single(.success(model))
                    }.resume()
            }
            
            return Disposables.create { }
        }
            
        }
    }

