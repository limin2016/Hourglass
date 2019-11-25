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

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories : Results<Category>!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
//        let category = categories[indexPath.row]
//        cell.textLabel?.text = category.name
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //cell.textLabel?.text = categories[indexPath.row].name   use this code will throw wrong message. Don't know why.
        //let item = categories[indexPath.row]
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories addded yet!"
        //cell.textLabel?.text = item?.name ?? "No categories added yet!"
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
    
    //MARK: - Add New Categories
    
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
            //when you click "Add Item", what happens
            let action = UIAlertAction(title: "Add category", style: .default) { (action) in
                if textField.text != "" {
                    let newCategory = Category()
                    newCategory.name = textField.text!
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
