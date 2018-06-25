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
    
    let contactVm = ContactsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        
        contactVm.loadModels()
        
        
//      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func bindUI () {
        
        let nib = UINib(nibName: "ContactsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "tableCell")
        
        contactVm.countries.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "tableCell", cellType: ContactsTableViewCell.self)) {
                row, model, cell in
                cell.configure(with: model)
               
                
        }.disposed(by: disposeBag)
    
    }


}
