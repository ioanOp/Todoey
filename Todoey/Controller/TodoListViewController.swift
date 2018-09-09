//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Ioan Oprea on 07/09/2018.
//  Copyright © 2018 Ioan Oprea. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var searchTodoItem: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTodoItem.delegate = self
       // loadData()
        getItems()
    }
    
    @IBAction func addToDo(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add task", message: "", preferredStyle: .alert)
        
        let actionAdd = UIAlertAction(title: "Add", style: .default) {(action) in
            let newItem = Item(context: self.context)
            newItem.title = alert.textFields?.first?.text!
            newItem.done = false
         //   let newItem = ToDoItem(title: (alert.textFields?.first?.text)!)
            if newItem.title != "" {
                self.itemArray.append(newItem)
                self.saveData()
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
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        item.done ? formatCell(cell: cell, completed: true) : formatCell(cell: cell, completed: false)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        saveData()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            saveData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        //    getItems()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
    
    //MARK: CoreData data management
    
    func saveData(){
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func getItems(with request:NSFetchRequest<Item> = Item.fetchRequest()){
        if let tempItems = try? context.fetch(request) as [Item] {
            itemArray = tempItems
        }
        tableView.reloadData()
    }
    
    
//    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest()){
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    func deleteItem(position: Int) {
        let selectedItem = itemArray[position]
        context.delete(selectedItem)
        saveData()
        getItems()
    }
    
//    func loadData(){
//        let decoder = PropertyListDecoder()
//        do {
//            let data = try decoder.decode([ToDoItem].self, from: Data(contentsOf: path!))
//            itemArray = data
//        } catch {
//            print(error.localizedDescription)
//        }
//
//    }
//
//    func saveData(){
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: path!)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
   

//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        
//    }
// 
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
 

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension TodoListViewController: UISearchBarDelegate {
    //MARK: search bar delegate methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> =  Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
      //  request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        searchBar.resignFirstResponder()
        getItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let word = searchBar.text!
        print(word.count)
        if word.count == 0 {
            getItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            let request: NSFetchRequest<Item> =  Item.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", word)
            getItems(with: request)
        }
    }
    
}

