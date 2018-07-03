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
    
    var detailVM: DetailViewModel?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailVM = DetailViewModel(countryName: receivedName!)
        
        detailVM?.fetchDetail()
       
        
        detailVM?.resultFromApi.asDriver()
            .map{$0}
            .drive(onNext: {(item) in
                                self.name.text = item.name ?? "Nao informado"
                                self.capital.text = item.capital ?? "Nao Informado"
                                self.region.text = item.region ?? "Nao informado"
                                self.subRegion.text = item.subregion ?? "Nao informado"
                                self.population.text = "\(item.population ?? -1)"
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
