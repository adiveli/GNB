//
//  SpecificTransactionController.swift
//  GNB
//
//  Created by Adi Veliman on 07/01/2019.
//  Copyright © 2019 Adi Veliman. All rights reserved.
//

import UIKit

class SpecificTransactionController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    var specificTransactions = [Transaction]()
    var currencies = [Currency]()
    var netService = NetworkServices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        totalAmountLabel.isHidden = true
        targetCurrencyLabel.isHidden = true
        textLabel.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        netService.getCurrencies { (currencies) in
            self.currencies = currencies
        }
    }
    
    //lazy move
    func removeDuplicates(array: [Transaction]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value.currency) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value.currency)
                // ... Append the value.
                result.append(value.currency)
            }
        }
        return result
    }
    
    
    //function which transforms currency to targeted one by multiple executions
    func transformCurrency(name: String, amount: Double, from: String, to: String) -> Transaction{
        var result : Transaction?

        switch from{
        case "AUD":
            for transform in currencies{
                if transform.from == from && transform.to == to{
                    result = Transaction(sku: name, amount: amount * Double(transform.rate)!, currency: transform.to)
                }
            }
        case "USD":
            for transform in currencies{
                if transform.from == from && transform.to == "AUD"{
                    result = Transaction(sku: name, amount: amount * Double(transform.rate)!, currency: transform.to)
                }
            }
        case "CAD":
            for transform in currencies{
                if transform.from == from && transform.to == "USD"{
                    result = Transaction(sku: name, amount: amount * Double(transform.rate)!, currency: transform.to)
                }
            }
        default:
        print("Currency not found")
        }
        
        return result!
    }
    
    func getTotalAmountEuro(array: [Transaction]){
        var euroTransaction = [Transaction]()
        var refinedTransaction : Transaction
        for transaction in array{
            if transaction.currency == "EUR"{
                euroTransaction.append(transaction)
            }
            if transaction.currency == "AUD"{
                //1 execution from AUD to EUR
                refinedTransaction = transformCurrency(name: transaction.sku, amount: Double(transaction.amount)!, from: transaction.currency, to: "EUR")
                euroTransaction.append(refinedTransaction)
            }
            if transaction.currency == "USD"{
                //2 executions from AUD to EUR
                refinedTransaction = transformCurrency(name: transaction.sku, amount: Double(transaction.amount)!, from: transaction.currency, to: "AUD")
                refinedTransaction = transformCurrency(name: transaction.sku, amount: Double(refinedTransaction.amount)!, from: refinedTransaction.currency, to: "EUR")
                euroTransaction.append(refinedTransaction)
            }
            if transaction.currency == "CAD"{
                //3 executions from AUD to EUR
                refinedTransaction = transformCurrency(name: transaction.sku, amount: Double(transaction.amount)!, from: transaction.currency, to: "USD")
                refinedTransaction = transformCurrency(name: transaction.sku, amount: Double(refinedTransaction.amount)!, from: refinedTransaction.currency, to: "AUD")
                refinedTransaction = transformCurrency(name: transaction.sku, amount: Double(refinedTransaction.amount)!, from: refinedTransaction.currency, to: "EUR")
                euroTransaction.append(refinedTransaction)
            }
        }
        
        //total sum of transactions in one currency
        var sum:Double = 0
        for transaction in euroTransaction{
            sum = sum + Double(transaction.amount)!
        }
        totalAmountLabel.text = "\(sum)"
        targetCurrencyLabel.text = "EUR"
        
    }
    
    //function which gets the sum of transactions by currency
    func getSumofSales() -> [Transaction]{
        
        let specificCurrencies = removeDuplicates(array: specificTransactions)
        var sumOfSales = [Transaction]()
        for currency in specificCurrencies{
            var newAmount : Double = 0
            for item in specificTransactions{
                if item.currency == currency{
                    newAmount += Double(item.amount)!
                }
            }
            sumOfSales.append(Transaction(sku: nameLabel.text!, amount: newAmount.rounded(FloatingPointRoundingRule.toNearestOrEven), currency: currency)) //Bankers’ Rounding rule
        }
        return sumOfSales
    }
    
    @IBAction func showOverviewClicked(_ sender: Any) {
        totalAmountLabel.isHidden = false
        targetCurrencyLabel.isHidden = false
        textLabel.isHidden = false
        getTotalAmountEuro(array: getSumofSales())
    }
    @IBAction func sumOfSalesClicked(_ sender: Any) {
        
        specificTransactions = getSumofSales()
        tableView.reloadData()
    }
    
}



extension SpecificTransactionController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "specificTransaction", for: indexPath) as! SpecificTransactionCell
        cell.amountLabel.text = specificTransactions[indexPath.row].amount
        cell.currencyLabel.text = specificTransactions[indexPath.row].currency
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specificTransactions.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
