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
            DispatchQueue.main.async {
                var models: [CountryModel] = []
                
                URLSession.shared.dataTask(with: URL(string: "https://restcountries.eu/rest/v2/all")!) { (data, response, error) in
                    
            
                    models = try! JSONDecoder().decode([CountryModel].self, from: data!)
         
                    single(.success(models))
                }.resume()
            }
            
            return Disposables.create { }
        }
    }
}
