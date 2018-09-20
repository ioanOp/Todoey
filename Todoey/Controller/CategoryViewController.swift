//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ioan Oprea on 17/09/2018.
//  Copyright © 2018 Ioan Oprea. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {

    var categories: Results<Category>?
    let realm = try! Realm()
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category){
        try! realm.write {
            realm.add(category)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add category", message: "Create a new to do list", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let listName = (alert.textFields?.first?.text)!
            if listName != "" {
                let newList = Category()
                newList.name = listName
                self.save(category: newList)
            }
        }))
        alert.addTextField { (textField) in
            textField.placeholder = "Type here..."
        }
        present(alert, animated: true)
    }
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = categories?[indexPath.row].name.capitalized ?? "No categories"
        return cell
    }
 
    //MARK: table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        guard let category = categories?[indexPath.row] else { return }
//        if editingStyle == .delete {
//            do {
//                try realm.write {
//                    category.items.removeAll()
//                    realm.delete(category)
//                }
//            } catch { print(error) }
//        }
//        tableView.reloadData()
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
}


//MARK: SwipeCell delegate methods

extension CategoryViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let category = self.categories?[indexPath.row] {
                try! self.realm.write {
                    category.items.removeAll()
                    self.realm.delete(category)
                }
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
