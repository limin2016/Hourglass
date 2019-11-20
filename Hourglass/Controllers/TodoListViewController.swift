//
//  ViewController.swift
//  Hourglass
//
//  Created by 吴利民 on 2019/10/9.
//  Copyright © 2019 wulimin. All rights reserved.
//

import UIKit
//At the begining, viewDidLoad+number times numberOfRowsInSection + number times cellForRowAt indexPath
//tableView.reloadData(): one time numberOfRowsInSection + number times cellForRowAt indexPath
class TodoListViewController: UITableViewController {
 
    var itemArray = [Item]()
//    var itemArray=["Find Milk", "Buy eggs", "Buy Fruits"]
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        let newItem = Item()
        newItem.title = "Find Milk"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Buy Fruits"
        itemArray.append(newItem3)
        
         
        
        // Do any additional setup after loading the view.
        
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        print("viewDidLoad")
    }
    
    //MARK Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of row ",itemArray.count)
        return itemArray.count
    }
    
    //each item will load only one time at the begining
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "toDoListCell")
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        print("clock row")
        return cell
    }

    //MARK - TabelView Delegate Methods
    //When user click the row, what happens
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row].title)

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        //when you click "Add Item", what happens
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != "" {
                
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                self.saveItems()
                
                
                //self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
            }
            
        }
        
        //when you click the + button, what happens
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create a new todo item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        self.tableView.reloadData()
    }
}

