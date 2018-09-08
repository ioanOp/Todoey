//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Ioan Oprea on 07/09/2018.
//  Copyright © 2018 Ioan Oprea. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [ToDoItem]()
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemArray.append(ToDoItem(title: "do this"))
        itemArray.append(ToDoItem(title: "do that"))
        itemArray.append(ToDoItem(title: "stop helping"))
        itemArray.append(ToDoItem(title: "repeat after me"))
        
        }
    
    @IBAction func addToDo(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add task", message: "", preferredStyle: .alert)
        
        let actionAdd = UIAlertAction(title: "Add", style: .default) {(action) in
            let newItem = ToDoItem(title: (alert.textFields?.first?.text)!)
            if newItem.title != "" {
                self.itemArray.append(newItem)
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
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            itemArray.remove(at: indexPath.row)
            defaults.set(itemArray, forKey: "TodoListArray")
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
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
    
   
    //  currentCell?.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.strikethroughStyle: 0])

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
