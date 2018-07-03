//
//  DetailViewModel.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 03/07/2018.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//

import RxSwift


class DetailViewModel {
    
    var receivedName = Variable<String>("")
    var resultFromApi = Variable<CountryDetailModel>(CountryDetailModel())
    
    let disposeBag = DisposeBag()

    init (countryName: String) {
        
        self.receivedName.value = countryName
    }
   
    
    func fetchDetail () {
        
        ContactsService.getDetails(countryName: receivedName.value)
            .subscribe(onSuccess: { fetchData in
               
                self.resultFromApi.value = fetchData[0]
                
                
            })
            .disposed(by: disposeBag)
    }
    
}
