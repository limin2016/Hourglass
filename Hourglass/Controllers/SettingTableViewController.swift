//
//  SettingTableViewController.swift
//  Hourglass
//
//  Created by 吴利民 on 2019/11/25.
//  Copyright © 2019 wulimin. All rights reserved.
//

import UIKit
import Firebase
class SettingTableViewController: UITableViewController {

    var functions : [String] = ["Log out"]
    override func viewDidLoad() {
        tableView.separatorStyle = .none
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return functions.count
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "goToItems", sender: self)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! WelcomeViewController
//        if let indexPath = tableView.indexPathForSelectedRow {
//            
//        }
//    }
}
