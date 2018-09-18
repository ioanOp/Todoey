//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ioan Oprea on 17/09/2018.
//  Copyright © 2018 Ioan Oprea. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categs = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadCategories() {
        if let tempCats = try? context.fetch(Category.fetchRequest()) as [Category] {
            categs = tempCats
        }
        tableView.reloadData()
    }
    
    func saveCategories(){
        do {
             try context.save()
        } catch {
            print(error)
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
                let newList = Category(context: self.context)
                newList.name = listName
                self.categs.append(newList)
                self.saveCategories()
            }
        }))
        alert.addTextField { (textField) in
            textField.placeholder = "Type here..."
        }
        present(alert, animated: true)
    }
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categs.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categs[indexPath.row].name
        return cell
    }
 
    //MARK: table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categs[indexPath.row]
        }
        
    }
}
