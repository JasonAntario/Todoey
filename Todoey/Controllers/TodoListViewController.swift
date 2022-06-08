//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [TodoItem(title: "Buy Eggs", done: false),
                     TodoItem(title: "Find Nemo", done: false),
                     TodoItem(title: "Go Fuck Yourself", done: false)]
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("TodoItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let todoItem = itemArray[indexPath.row]
        if #available(iOS 14.0, *) {
            var content = reusableCell.defaultContentConfiguration()
            content.text = todoItem.title
            reusableCell.contentConfiguration = content
        } else {
            reusableCell.textLabel?.text = todoItem.title
        }
        reusableCell.accessoryType = todoItem.done ? .checkmark : .none
        
        return reusableCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            var newItem = TodoItem()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Saving items error \(error)")
        }
        self.tableView.reloadData()
    }
    
    private func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                self.itemArray = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("Loading items error \(error)")
            }
        }
    }
}
