//
//  TodoViewModel.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 21/06/18.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//


protocol TodoMenuItemViewPresentable {
    var title: String? { get }
    var backColor: String? { get }
}

protocol TodoMenuViewItemDelegate {
    func onMenuItemSelected() -> ()
}

class TodoMenuItemViewModel: TodoMenuItemViewPresentable, TodoMenuViewItemDelegate {
    var title: String?
    var backColor: String?
    weak var parent: TodoItemViewDelegate?
    
    init(parentViewModel: TodoItemViewDelegate) {
        self.parent = parentViewModel
    }
    
    
    func onMenuItemSelected() {
        //not require an implementation
    }
    
}
class RemoveMenuItemViewModel: TodoMenuItemViewModel {
    
    
    override func onMenuItemSelected() {
     print("Remove button selected")
    
        parent?.onRemoveSelected()
    }
}

class DoneMenuItemViewModel: TodoMenuItemViewModel {
    
    
    override func onMenuItemSelected() {
        print("Done button selected")
        parent?.onDoneSelected()
    }
}


protocol TodoItemViewDelegate: class {
    func onItemSelected() -> (Void)
    func onRemoveSelected() -> (Void)
    func onDoneSelected() -> (Void)
}

protocol TodoItemPresentable {
    var id: String? { get }
    var textValue: String? { get }
    var isDone: Bool? { get set }
    var menuItems: [TodoMenuItemViewPresentable]? { get }
}


class  TodoItemViewModel: TodoItemPresentable {
    var id: String? = "0"
    var textValue: String?
    var menuItems: [TodoMenuItemViewPresentable]? = []
    weak var parent: TodoViewDelegate?
    var isDone: Bool? = false
    
    init(id: String?, textValue: String?, parentViewModel: TodoViewDelegate) {
        self.id = id
        self.textValue = textValue
        self.parent = parentViewModel
        let removeMenuItem = RemoveMenuItemViewModel(parentViewModel: self)
        removeMenuItem.title = "Remove"
        removeMenuItem.backColor = "ff0000"
        
        let doneMenuItem = DoneMenuItemViewModel(parentViewModel: self)
        doneMenuItem.title = isDone! ? "Undone" : "Done"
        doneMenuItem.backColor = "008000"
        
        menuItems?.append(contentsOf: [removeMenuItem, doneMenuItem])
    }
}

protocol TodoViewDelegate: class  {
    func onAddTodoItem() -> ()
    func onDeleteTodoItem(todoId: String) -> ()
    func onDoneTodoItem(todoId: String) -> ()
}

protocol TodoViewPresentable {
    var newTodoItem: String? { get }
}

class TodoViewModel {

    weak var view: TodoView?
    var newTodoItem: String?
    var items: [TodoItemPresentable] = []
    
    init(view: TodoView?) {
        self.view = view
        let item1 = TodoItemViewModel(id: "1", textValue: "Ir ao mercado", parentViewModel: self)
        let item2 = TodoItemViewModel(id: "2", textValue: "Ir ao dentista", parentViewModel: self)
        let item3 = TodoItemViewModel(id: "3", textValue: "Ir ao médico", parentViewModel: self )

         items.append(contentsOf: [
        item1,
        item2,
        item3])
    }
}

extension TodoViewModel: TodoViewDelegate {
    func onDeleteTodoItem(todoId: String) {
        guard let index = self.items.index(where: {$0.id! == todoId}) else {
            print("todoId not exists")
            return
        }
        
        self.items.remove(at: index)
        view?.deleteTodoItem(at: index)
    }
    
    func onAddTodoItem() {
        
        
        guard let newValue = newTodoItem else {
            print("New value is empty")
            return
        }
        
        
        
        let itemIndex = String(items.count + 1)
        let newItem = TodoItemViewModel(id: "\(itemIndex)", textValue: newValue, parentViewModel: self)
        self.items.append(newItem)
        self.newTodoItem = ""
        self.view?.insertTodoItem()
        
    }
    
    func onDoneTodoItem(todoId: String) {
        print("Todo item done with: \(todoId)")
        
        guard let index = self.items.index(where: {$0.id! == todoId}) else {
            print("todoId not exists")
            return
        }
        
        var todoItem = self.items[index]
        
        let _isDone = !(todoItem.isDone)!
        
        todoItem.isDone = _isDone
        self.view?.onUpdateTodoItem(at: index)
    }
    
    
}

extension TodoItemViewModel: TodoItemViewDelegate {
    func onRemoveSelected() {
        parent?.onDeleteTodoItem(todoId: id!)
    }
    
    func onDoneSelected() {
        parent?.onDoneTodoItem(todoId: id!)
    }
    
    func onItemSelected() {
        print("The received id on viewmodel was: \(id ?? "nulo") with value \(textValue ?? "Nulo")")
    }
    
    
}