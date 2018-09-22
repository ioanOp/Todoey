//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Ioan Oprea on 07/09/2018.
//  Copyright © 2018 Ioan Oprea. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeCellViewController {

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
        searchTodoItem.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let hexColor = selectedCategory?.color else { fatalError() }
        guard let navBar = navigationController?.navigationBar else { fatalError() }
        let color = UIColor(hexString: hexColor)!
        navBar.barTintColor = color
        navBar.tintColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
        self.title = selectedCategory?.name
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(backgroundColor: color, returnFlat: true)]
        searchTodoItem.barTintColor = color
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = FlatSkyBlue()
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
    }
    
    @IBAction func addToDo(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add task", message: "", preferredStyle: .alert)
        
        let actionAdd = UIAlertAction(title: "Add", style: .default) {(action) in
            guard let title = alert.textFields?.first?.text else { return }
            guard let currentCategory = self.selectedCategory else { return }
            if title != "" {
                try! self.realm.write {
                    let newItem = Item()
                    newItem.title = title
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let color = UIColor(hexString: selectedCategory?.color)
        if let item = toDoItems?[indexPath.row] {
            let percentage = CGFloat(indexPath.row) / CGFloat(toDoItems!.count)
            cell.textLabel?.text = item.title
            cell.backgroundColor = color?.darken(byPercentage: percentage)
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor: cell.backgroundColor!, returnFlat: true)
            item.done ? formatCell(cell: cell, completed: true) : formatCell(cell: cell, completed: false)
        } else {
            cell.textLabel?.text = "No items..."
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            try! realm.write {
                item.done = !item.done
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
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
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            try! realm.write {
                realm.delete(item)
            }
        }
    }

}


extension TodoListViewController: UISearchBarDelegate {
    //MARK: search bar delegate methods

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let word = searchBar.text!
        if word.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", word)
            tableView.reloadData()
        }
    }

}

