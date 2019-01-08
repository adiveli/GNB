//
//  Transaction.swift
//  GNB
//
//  Created by Adi Veliman on 07/01/2019.
//  Copyright © 2019 Adi Veliman. All rights reserved.
//

import Foundation

struct Transaction: Codable{
    
    var sku: String
    var amount: String
    var currency: String
    
    init(sku: String, amount: Double, currency: String) {
        self.sku = sku
        self.amount = String(format:"%.f", amount) //no decimals for easy reading
        self.currency = currency
    }
    
}
