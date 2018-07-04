//
//  DetalheViewController.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 28/06/18.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetalheViewController: UIViewController {

    var receivedName: String?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var subRegion: UILabel!
    @IBOutlet weak var population: UILabel!
    @IBOutlet weak var borders: UILabel!
    @IBOutlet weak var demonym: UILabel!
    @IBOutlet weak var currencies: UILabel!
    
    var detailVM: DetailViewModel?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title?.append(" \(receivedName ?? "404")")
        
        detailVM = DetailViewModel(countryName: receivedName!)
        
        detailVM?.fetchDetail()
       
        
        detailVM?.resultFromApi.asDriver()
            .map{$0}
            .drive(onNext: {(item) in
                self.name.text = "Nome: \(item.name ?? "Nao informado")"
                self.capital.text = "Capital: \(item.capital ?? "Nao Informado")"
                self.region.text = "Região: \(item.region ?? "Nao informado")"
                self.subRegion.text = "Sub região: \(item.subregion ?? "Nao informado")"
                self.population.text = "Populaçao: \(item.population ?? -1)"
                self.borders.text = "Fronteiras: \(item.borders.map {$0}?.joined(separator: ", ") ?? "Sem fronteira")"
                self.demonym.text = "Demonym: \(item.demonym ?? "Náo informado")"
                let s = item.currencies?.first
                self.currencies.text = "Currencies: \(s.map { return "\($0["name"] ?? "Sem nome"), \($0["code"] ?? "Sem codigo"), \($0["symbol"] ?? "Sem simbolo")"} ?? "Falha no map")"
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            }).disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
   
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
