//
//  ViewController.swift
//  Hourglass
//
//  Created by 吴利民 on 2019/10/9.
//  Copyright © 2019 wulimin. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

//At the begining, viewDidLoad+number times numberOfRowsInSection + number times cellForRowAt indexPath
//tableView.reloadData(): one time numberOfRowsInSection + number times cellForRowAt indexPath
class TodoListViewController: UITableViewController{
    
    let realm = try! Realm()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todoLtems : Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(File Manager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoLtems?.count ?? 1
    }
    
    //each item will load only one time at the begining
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "toDoListCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoLtems?[indexPath.row] {
            cell.textLabel?.text = item.title
        
            //ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added!"
        }
        return cell
    }

    //MARK: - TabelView Delegate Methods
    //When user click the row, what happens
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoLtems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }catch {
                print("Error saving done status, \(error)")
            }
        }
        //print(todoLtems[indexPath.row].title!)
        //need frist delete the items from coredata because we in the second code, we use the indexPath.row
//        self.context.delete(todoLtems[indexPath.row])
//        todoLtems.remove(at: indexPath.row)
        
        //todoLtems[indexPath.row].setValue("hello", forKey: "title")
//        todoLtems[indexPath.row].done = !todoLtems[indexPath.row].done
//        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }
    
    

    //MARK: - add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        //when you click "Add Item", what happens
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != "" {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.done = false
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new items!, \(error)")
                    }
                    self.tableView.reloadData()
                }
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
    // MARK: - TableView 
//    func saveItems() {
////        do {
////            try self.context.save()
////        } catch {
////            print("Error saving message, \(error)")
////        }
//        self.tableView.reloadData()
//    }
    
    func loadItems() {
        todoLtems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoLtems = todoLtems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            } 
        }
    }
}

