import RxSwift

protocol TodoMenuItemViewPresentable {
    var title: String? { get set }
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

class TodoViewModel: TodoViewPresentable {

    var newTodoItem: String?
    var items: Variable<[TodoItemPresentable]> = Variable([])
    var showActivityIndicator = Variable<Bool>(false)
    
    
    init() {
           DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
        let item1 = TodoItemViewModel(id: "1", textValue: "Ir ao mercado", parentViewModel: self)
        let item2 = TodoItemViewModel(id: "2", textValue: "Ir ao dentista", parentViewModel: self)
        let item3 = TodoItemViewModel(id: "3", textValue: "Ir ao médico", parentViewModel: self )
        
         self.items.value.append(contentsOf: [
        item1,
        item2,
        item3])
        self.showActivityIndicator.value = false
    }
    }
}

extension TodoViewModel: TodoViewDelegate {
    func onDeleteTodoItem(todoId: String) {
        guard let index = self.items.value.index(where: {$0.id! == todoId}) else {
            print("todoId not exists")
            return
        }
        
        self.items.value.remove(at: index)
        
    }
    
    func onAddTodoItem() {
        
        
        guard let newValue = newTodoItem else {
            print("New value is empty")
            return
        }
        
        
        
        let itemIndex = String(items.value.count + 1)
        let newItem = TodoItemViewModel(id: "\(itemIndex)", textValue: newValue, parentViewModel: self)
        self.items.value.append(newItem)
        self.newTodoItem = ""
//        self.view?.insertTodoItem()
        
    }
    
    func onDoneTodoItem(todoId: String) {
        print("Todo item done with: \(todoId)")
        
        guard let index = self.items.value.index(where: {$0.id! == todoId}) else {
            print("todoId not exists")
            return
        }
        
        var todoItem = self.items.value[index]
        
        let _isDone = !(todoItem.isDone)!
        
        todoItem.isDone = _isDone
        if var doneMenuItem = todoItem.menuItems?.filter({ (todoMenuitem) -> Bool in
            todoMenuitem is DoneMenuItemViewModel
        }).first {
            doneMenuItem.title = todoItem.isDone! ? "Undone" : "Done"
        }

        self.items.value.sort(by: {
            
            if !($0.isDone!) && !($1.isDone!) {
                return $0.id! < $1.id!
            }
            
            if $0.isDone! && $1.isDone! {
                return $0.id! < $1.id!
            }
            
            return !($0.isDone)! && $1.isDone!
        })
        
        
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
