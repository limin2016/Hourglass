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
import ChameleonFramework

//At the begining, viewDidLoad+number times numberOfRowsInSection + number times cellForRowAt indexPath
//tableView.reloadData(): one time numberOfRowsInSection + number times cellForRowAt indexPath
class ReadListViewController: SwipeTableViewController{
    
    var searchPaperName : String = ""
    let realm = try! Realm()
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var PaperRead : Results<Paper>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65.0
        loadItems()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PaperRead?.count ?? 1
    }
    
    //each item will load only one time at the begining
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = PaperRead?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.accessoryType = item.done ? .checkmark : .none
//            if let color = UIColor(hexString: selectedCategory!.color)?.lighten(byPercentage: CGFloat(indexPath.row) / CGFloat(todoLtems!.count)) {
//                cell.backgroundColor = color
//                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
//            }
        }
        else {
            cell.textLabel?.text = "No paper added!"
        }
        return cell
    }

    //MARK: - TabelView Delegate Methods
    //When user click the row, what happens
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let item = PaperRead?[indexPath.row] {
//            do {
//                try realm.write {
//                    item.done = !item.done
//                }
//            }catch {
//                print("Error saving done status, \(error)")
//            }
//        }
//
//        tableView.deselectRow(at: indexPath, animated: true)
//        self.tableView.reloadData()
//    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "readToSearch", sender: self)
//        if let item = PaperRead?[indexPath.row] {
//            self.searchPaperName = item.name
//        }
//        else {
//            self.searchPaperName = ""
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            if let item = PaperRead?[indexPath.row] {
                destinationVC.textPapername = item.name
            }
//            else {
//                self.searchPaperName = ""
//            }
        }
    }
    

    //MARK: - Delte data from swipe
    override func deleteModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.PaperRead?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
            }
                } catch {
                    print("Error deleting category, \(error)")
                }
                //tableView.reloadData()
        }
    }
    
    //MARK: - add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add A New Paper", message: "", preferredStyle: .alert)
        //when you click "Add Item", what happens
        let action = UIAlertAction(title: "Add the Paper", style: .default) { (action) in
            if textField.text != "" {
                do {
                    try self.realm.write {
                        let newItem = Paper()
                        newItem.name = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        self.realm.add(newItem)
                    }
                } catch {
                    print("Error saving new Paper!, \(error)")
                }
                self.tableView.reloadData()
            }
            
        }
        
        //when you click the + button, what happens
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add a new paper"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
    func loadItems() {
        //PaperRead.sorted(byKeyPath: "dateCreated", ascending: true)
        PaperRead = realm.objects(Paper.self)
        self.tableView.reloadData()
    }
}

extension ReadListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else {
            PaperRead = PaperRead?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            self.tableView.reloadData()
        }
        
        
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

