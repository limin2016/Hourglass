//
//  Paper.swift
//  Hourglass
//
//  Created by 吴利民 on 2019/11/25.
//  Copyright © 2019 wulimin. All rights reserved.
//

import Foundation
import RealmSwift

class Paper: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
}
