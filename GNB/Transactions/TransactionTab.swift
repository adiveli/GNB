//
//  TransactionTab.swift
//  GNB
//
//  Created by Adi Veliman on 07/01/2019.
//  Copyright © 2019 Adi Veliman. All rights reserved.
//

import UIKit

//protocol for setting the content of the custom container

protocol ContainerDelegate : class{
    func setTransaction(value: String, transactions: [Transaction])
}

class TransactionTab: UIViewController, ContainerDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    //custom container which can hold multiple view controllers
    //used this instead of usual segues to keep a nice ux
    
    var container : ContainerViewController!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let transactionController = self.container.currentViewController as? TransactionListController{
            transactionController.containerDelegate = self
        }
        backBtn.isHidden = true
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        
        //function for setting the content in container
        container.segueIdentifierReceivedFromParent("transactions")
        backBtn.isHidden = true
    }
    
    
    func setTransaction(value: String, transactions: [Transaction]) {
        container.segueIdentifierReceivedFromParent("specificTransaction")
        backBtn.isHidden = false
        var specificTransactions = [Transaction]()
        
        //keep transactions of a specified type
        for item in transactions{
            if item.sku == value{
                specificTransactions.append(item)
            }
        }
        
        //send data to controller
        if let specificTransactionController = self.container.currentViewController as? SpecificTransactionController{
            specificTransactionController.nameLabel.text = value
            specificTransactionController.specificTransactions = specificTransactions
            specificTransactionController.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container"{
            container = segue.destination as! ContainerViewController
            container.animationDurationWithOptions = (0.5, .transitionCrossDissolve)
        }
    }
    
    

}
