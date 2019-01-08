//
//  TransactionCell.swift
//  GNB
//
//  Created by Adi Veliman on 07/01/2019.
//  Copyright © 2019 Adi Veliman. All rights reserved.
//

import UIKit

//this protocol is used for keeping track of the pressed item in table view

protocol TransactionCellDelegate : class{
    func transactionTapped(_ sender: TransactionCell, value: String)
}

class TransactionCell: UITableViewCell {

    @IBOutlet weak var transactionNameLabel: UILabel!
    weak var delegate : TransactionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //added tap gesture for selection of item
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        delegate?.transactionTapped(self, value: transactionNameLabel.text ?? "Error")
    }


}
