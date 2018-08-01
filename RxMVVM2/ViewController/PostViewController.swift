//
//  PostViewController.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 04/07/2018.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostViewController: UIViewController {

    
    let identifier = "PostCell"
    
    @IBOutlet weak var amountRegister: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
    }

    
}


