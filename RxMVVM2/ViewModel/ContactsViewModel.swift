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
    
    let disposeBag = DisposeBag()
    
    
    func loadModels() {
        ContactsService.fetchModels()
            .subscribe(onSuccess: { fetchData in
                self.countries.value = fetchData
            })
            .disposed(by: disposeBag)
    }
    
}

