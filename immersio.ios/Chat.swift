//
//  Chat.swift
//  immersio.ios
//
//  Created by Rohan Garg on 2020-08-23.
//  Copyright © 2020 Immersio. All rights reserved.
//

import Foundation
import UIKit

struct Chat {
var users: [String]
var dictionary: [String: Any] {
return ["users": users]
   }
}
extension Chat {
init?(dictionary: [String:Any]) {
guard let chatUsers = dictionary["users"] as? [String] else {return nil}
self.init(users: chatUsers)
}
}
