//
//  ContactsViewModel.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 25/06/18.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//

import RxSwift


class ContactsViewModel {
    var countries = Variable<[CountryModel]>([])
    var filterCountries = Variable<[CountryModel]>([])
    var searchValue = Variable<String>("")
    var showActivityIndicator = Variable<Bool>(false)
    lazy var searchValueObs: Observable<String> = self.searchValue.asObservable()
    lazy var countryObs: Observable<[CountryModel]>  = self.countries.asObservable()
    lazy var filterCountryObs: Observable<[CountryModel]>  = self.filterCountries.asObservable()
    let disposeBag = DisposeBag()
    var resultDetail = Variable<[CountryDetailModel]>([])
    
    
    init () {
        searchValueObs
            .subscribe(onNext: { (value) in
                
                self.countryObs.map({ $0.filter( {
                    
                    if value.isEmpty { return true }
                    
                    return (($0.name?.lowercased().contains(value.lowercased()))! || ($0.capital?.lowercased().contains(value.lowercased()))! || ($0.region?.lowercased().contains(value.lowercased()))!)
                    
                })
                }).bind(to: self.filterCountries).disposed(by: self.disposeBag)
                
                
            }).disposed(by: disposeBag)
        
    }
    
    func loadModels() {
        
        showActivityIndicator.value = true
        ContactsService.fetchModels()
            .subscribe(onSuccess: { fetchData in
                self.countries.value = fetchData
                self.showActivityIndicator.value = false
            })
            .disposed(by: disposeBag)
    }
    
 
    
}

