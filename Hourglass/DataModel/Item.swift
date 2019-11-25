//
//  Item.swift
//  Hourglass
//
//  Created by 吴利民 on 2019/11/24.
//  Copyright © 2019 wulimin. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") 
}
