//
//  TransactionListController.swift
//  GNB
//
//  Created by Adi Veliman on 07/01/2019.
//  Copyright © 2019 Adi Veliman. All rights reserved.
//

import UIKit

class TransactionListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var netService = NetworkServices()
    var transactions = [Transaction]()
    var specificTransactionNames = [String]()
    
    weak var containerDelegate: ContainerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        netService.getTransaction { (transactions) in
            self.transactions = transactions
            self.specificTransactionNames = self.removeDuplicates(array: transactions)
            self.tableView.reloadData()
        }
    }
    
    func removeDuplicates(array: [Transaction]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value.sku) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value.sku)
                // ... Append the value.
                result.append(value.sku)
            }
        }
        return result
    }
    
    
    

}

extension TransactionListController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specificTransactionNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionCell
        cell.transactionNameLabel.text = specificTransactionNames[indexPath.row]
        cell.delegate = self
        return cell
    }

}

extension TransactionListController: TransactionCellDelegate{
    func transactionTapped(_ sender: TransactionCell, value: String) {
        containerDelegate?.setTransaction(value: value, transactions: transactions)
    }
    
}
