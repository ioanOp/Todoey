//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Ioan Oprea on 07/09/2018.
//  Copyright © 2018 Ioan Oprea. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [String]()
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    @IBAction func addToDo(_ sender: Any) {
        
     //   var tempTextField = UITextField()
        
        let alert = UIAlertController(title: "Add task", message: "", preferredStyle: .alert)
       
        let actionAdd = UIAlertAction(title: "Add", style: .default) {(action) in
      //      let newItem = tempTextField.text!
            let newItem = (alert.textFields?.first?.text)!
            if newItem != "" {
                self.itemArray.append(newItem)
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type here..."
            //      tempTextField = alertTextField
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
        cell.textLabel?.text = itemArray[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)
        let text = (currentCell?.textLabel?.text)!
        if currentCell?.accessoryType == .checkmark {
            currentCell?.accessoryType = .none
            currentCell?.textLabel?.attributedText = strikeTxt(text: text, style: 0)
        }
        else {
            currentCell?.accessoryType = .checkmark
            currentCell?.textLabel?.attributedText = strikeTxt(text: text, style: 2)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
