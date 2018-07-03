//
//  ContactsViewController.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 25/06/18.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ContactsViewController: UIViewController {

    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var amount: UILabel!
    
   
    
    var actIndicator: UIActivityIndicatorView!
    
    let contactVm = ContactsViewModel()
    
    var selectedName: String?
    
    
    lazy var searchController: UISearchController = ({
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = true
        controller.searchBar.backgroundColor = UIColor.clear
        controller.searchBar.placeholder = "search country"
//        controller.searchBar.text = "Braz"
        return controller
    })()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureComponents()
        
        
        actIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
      
        actIndicator.center = self.view.center
        actIndicator.hidesWhenStopped = true
        actIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(actIndicator)
        
        bindUI()
        contactVm.loadModels()
      
        
        
//      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configureComponents() {
        let nib = UINib(nibName: "ContactsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "tableCell")
        tableView.rowHeight = 97
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Países"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func bindUI () {
        
       
        
        
        contactVm.filterCountries.asDriver()
            .map { "\($0.count)" }
            .drive(amount.rx.text)
            .disposed(by: disposeBag)
        
        contactVm.filterCountries.asDriver()
            .map{ $0 }
            .drive(tableView.rx.items(cellIdentifier: "tableCell", cellType: ContactsTableViewCell.self)) {
                row, model, cell in
                cell.configure(with: model)
                
               
                
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            
            let itemViewModel = self?.contactVm.countries.value[indexPath.row]

//            itemViewModel.map {
//                print("itemSelected \($0)")
//
//            }
            
            
        }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CountryModel.self)
            .subscribe(onNext: { countryModel in
                
//                print("Model selected \(countryModel)")
                //self.contactVm.loadDetail(countryModel: countryModel)
                self.selectedName = countryModel.name
               self.performSegue(withIdentifier: "fromTableToDetail", sender: self)
            
          
                
            })
                .disposed(by: disposeBag)
        
        let searchBar = searchController.searchBar
        tableView.tableHeaderView = searchBar
        tableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.size.height)
        
        searchBar.rx.text
        .orEmpty
        .distinctUntilChanged()
        .bind(to: contactVm.searchValue)
        .disposed(by: disposeBag)
        
        
        contactVm.showActivityIndicator.asDriver()
            .drive(actIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
//        contactVm.resultDetail.asObservable()
//            .bind(onNext: { (item) in
//                print("onNext Bind \(item.count)")
//
//            })
//        .disposed(by: disposeBag)
        
  
     
    
        

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? DetalheViewController {
            next.receivedName = selectedName
        }
    }
    
}
