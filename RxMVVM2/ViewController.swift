//
//  ViewController.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 21/06/18.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//

import UIKit

extension String {
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

protocol TodoView: class {
    func insertTodoItem() -> ()
    func deleteTodoItem(at index: Int) -> ()
    func onUpdateTodoItem(at index: Int) -> ()
}

class ViewController: UIViewController {
    
    let identifier = "todoItemCellIdentifier"
    
    @IBOutlet weak var newItemTextField: UITextField!
    @IBOutlet weak var tablewViewItems: UITableView!
    
    var viewModel: TodoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "TODO Items"
        
        let nib = UINib(nibName: "TodoItemTableViewCell", bundle: nil)
        tablewViewItems.register(nib, forCellReuseIdentifier: identifier)
        
        viewModel = TodoViewModel(view: self)
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
        viewModel?.newTodoItem = valueTyped
        
        DispatchQueue.global(qos: .userInitiated).async() {
            
            self.viewModel?.onAddTodoItem()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.items.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TodoItemTableViewCell
        
        let itemViewModel = viewModel?.items[indexPath.row]
  
        cell?.configure(withViewModel: itemViewModel!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print((viewModel?.items[indexPath.row])?.textValue ?? "Nao")
        let itemViewModel = viewModel?.items[indexPath.row]
        
        (itemViewModel as? TodoItemViewDelegate)?.onItemSelected() 
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let itemViewModel = viewModel?.items[indexPath.row]
        
        var actions: [UIContextualAction] = []
        _ = itemViewModel?.menuItems?.map({ menuItem in
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

extension ViewController: TodoView {
    func deleteTodoItem(at index: Int) {
        
        
        DispatchQueue.main.async {
            
            self.tablewViewItems.beginUpdates()
            self.tablewViewItems.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
            self.tablewViewItems.endUpdates()
        }
    }
    
    func insertTodoItem() {
        
        guard let items = viewModel?.items else {
            print("list is empty")
            return
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.newItemTextField.text = self.viewModel?.newTodoItem
            self.tablewViewItems.beginUpdates()
            self.tablewViewItems.insertRows(at: [IndexPath(row: items.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
            self.tablewViewItems.endUpdates()
            })

    }
    
    func onUpdateTodoItem(at index: Int) {
        DispatchQueue.main.async {
            self.tablewViewItems.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
        }
    }
}

