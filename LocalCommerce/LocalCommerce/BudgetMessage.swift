//
//  BudgetMessage.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 03/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import Foundation

class BudgetMessage {
    public var id:Int
    public var message: String
    public var replyToId: Int?
    
    init(id:Int, message:String, replyToId: Int) {
        self.id = id
        self.message = message
        self.replyToId = replyToId
    }
    
    convenience init(id:Int, message:String) {
        self.init(id: id, message: message, replyToId: 0)
    }
    
}
