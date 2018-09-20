//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Ioan Oprea on 07/09/2018.
//  Copyright © 2018 Ioan Oprea. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm()
    var toDoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
   
    @IBOutlet weak var searchTodoItem: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   searchTodoItem.delegate = self
    }
    
    @IBAction func addToDo(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add task", message: "", preferredStyle: .alert)
        
        let actionAdd = UIAlertAction(title: "Add", style: .default) {(action) in
            guard let title = alert.textFields?.first?.text else { return }
            guard let currentCategory = self.selectedCategory else { return }
            if title != "" {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = title
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving item \(error)")
                }
            }
            
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type here..."
        }

        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }

    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            item.done ? formatCell(cell: cell, completed: true) : formatCell(cell: cell, completed: false)
        } else {
            cell.textLabel?.text = "No items..."
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let item = toDoItems?[indexPath.row] else { return }
        if editingStyle == .delete {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch { print(error) }
          tableView.reloadData()
        }
    }
   
    //MARK: cell formatting
    
    func strikeTxt(text: String, style:Int) -> NSAttributedString {
        return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.strikethroughStyle: style])
    }
    
    func formatCell(cell: UITableViewCell, completed: Bool){
        let text = cell.textLabel?.text!
        if completed {
            cell.accessoryType = .checkmark
            cell.textLabel?.attributedText = strikeTxt(text: text!, style: 2)
        } else {
            cell.accessoryType = .none
            cell.textLabel?.attributedText = strikeTxt(text: text!, style: 0)
        }
        
    }
    


    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }



}

//
//extension TodoListViewController: UISearchBarDelegate {
//    //MARK: search bar delegate methods
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> =  Item.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//      //  request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        searchBar.resignFirstResponder()
//        getItems(with: request)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let word = searchBar.text!
//        if word.count == 0 {
//            getItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        } else {
//            let request: NSFetchRequest<Item> =  Item.fetchRequest()
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", word)
//            getItems(with: request)
//        }
//    }
//
//}
//
