//
//  CategoryTableViewController.swift
//  Hourglass
//
//  Created by 吴利民 on 2019/11/23.
//  Copyright © 2019 wulimin. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework
 
class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories : Results<Category>!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 65.0
        tableView.separatorStyle = .none
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    } 
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories addded yet!"
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6")
        
        if let color = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6") {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving message, \(error)")
        }
        self.tableView.reloadData()
     }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        //        do{
//            categories = try context.fetch(request)
//        } catch {
//            print("Error fetching data from contex, \(error)")
//        }
        self.tableView.reloadData()
    }
    
    //MARK: - Delte data from swipe
    override func deleteModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
            }
                } catch {
                    print("Error deleting category, \(error)")
                }
                //tableView.reloadData()
        }
    }
    
    //MARK: - Add New Categories
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
            //when you click "Add Item", what happens
            let action = UIAlertAction(title: "Add category", style: .default) { (action) in
                if textField.text != "" {
                    let newCategory = Category()
                    newCategory.name = textField.text!
                    newCategory.color = UIColor.randomFlat().hexValue()
                    //self.categories.append(newCategory)
                    self.save(category: newCategory)
                }
            }
            
            //when you click the + button, what happens
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "create a new category"
                textField = alertTextField
                
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
}

