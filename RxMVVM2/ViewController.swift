//
//  ViewController.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 21/06/18.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
 
class ViewController: UIViewController {
    
    let identifier = "todoItemCellIdentifier"
    let disposeBag = DisposeBag()
    
    var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newItemTextField: UITextField!
    @IBOutlet weak var tablewViewItems: UITableView!
    
    var viewModel = TodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "TODO Items"
        
        let nib = UINib(nibName: "TodoItemTableViewCell", bundle: nil)
        tablewViewItems.register(nib, forCellReuseIdentifier: identifier)
        
        actIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        actIndicator.center = self.view.center
        actIndicator.hidesWhenStopped = true
        actIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.view.addSubview(actIndicator)

        bindUI()
        
    }
    
    func bindUI () {
        //        viewModel?.items.asObservable().bind(to: tablewViewItems.rx.items(cellIdentifier: identifier, cellType: TodoItemTableViewCell.self)) { index, item, cell in
        //            cell.configure(withViewModel: item)
        //
        //            }.disposed(by: disposeBag)
        
        viewModel.items.asDriver().drive(
        tablewViewItems.rx.items(cellIdentifier: identifier, cellType: TodoItemTableViewCell.self)) { row, model, cell in
            cell.configure(withViewModel: model)
            }.disposed(by: disposeBag)
        
        tablewViewItems.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            
            let itemViewModel = self?.viewModel.items.value[indexPath.row]
            (itemViewModel as? TodoItemViewDelegate)?.onItemSelected()
            
            
        }).disposed(by: disposeBag)
        
        
        viewModel.showActivityIndicator.asDriver()
            .drive(actIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func addBtnClick(_ sender: Any) {
        guard let valueTyped = newItemTextField.text, !valueTyped.isEmpty else {
            print("no value entered")
            return
        }
        viewModel.newTodoItem = valueTyped
        
        DispatchQueue.global(qos: .userInitiated).async() {
            
            self.viewModel.onAddTodoItem()
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let itemViewModel = viewModel.items.value[indexPath.row]
        
        var actions: [UIContextualAction] = []
        _ = itemViewModel.menuItems?.map({ menuItem in
            let menuAction = UIContextualAction(style: .normal, title: menuItem.title) { (action, sourceView, success: (Bool) -> (Void)) in
                
                if let delegate = menuItem as? TodoMenuViewItemDelegate {
                    
                    DispatchQueue.global(qos: .background).async {
                        delegate.onMenuItemSelected()
                    }
                }
                
                success(true)
                
              
            }
            
            menuAction.backgroundColor = menuItem.backColor?.hexColor
            actions.append(menuAction)
        })
        
    

        return UISwipeActionsConfiguration(actions: actions)
    }


}

