//
//  Category.swift
//  Hourglass
//
//  Created by 吴利民 on 2019/11/24.
//  Copyright © 2019 wulimin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
