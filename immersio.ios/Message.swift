//
//  Message.swift
//  immersio.ios
//
//  Created by Rohan Garg on 2020-08-23.
//  Copyright © 2020 Immersio. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct Message {
var id: String
var content: String
var created: TimeInterval
var senderID: String
var senderName: String
var dictionary: [String: Any] {
return [
"id": id,
"content": content,
"created": created,
"senderID": senderID,
"senderName":senderName]
    }
}

extension Message {
init?(dictionary: [String: Any]) {
guard let id = dictionary["id"] as? String,
let content = dictionary["content"] as? String,
let created = dictionary["created"] as? TimeInterval,
let senderID = dictionary["senderID"] as? String,
let senderName = dictionary["senderName"] as? String
else {return nil}
self.init(id: id, content: content, created: created, senderID: senderID, senderName:senderName)
    }
}

extension Message: MessageType {
var sender: SenderType {
return Sender(id: senderID, displayName: senderName)
    }
var messageId: String {
return id
    }
var sentDate: Date {
    return Date.init(timeIntervalSinceNow: self.created)
    }
var kind: MessageKind {
return .text(content)
    }
}
