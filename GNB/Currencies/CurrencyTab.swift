//
//  CurrencyTab.swift
//  GNB
//
//  Created by Adi Veliman on 07/01/2019.
//  Copyright © 2019 Adi Veliman. All rights reserved.
//

import UIKit

class CurrencyTab: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var netService = NetworkServices()
    var currencies = [Currency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        netService.getCurrencies { (currencies) in
            self.currencies = currencies
            self.tableView.reloadData()
        }
    }

}

extension CurrencyTab : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyCell
        cell.fromLabel.text = currencies[indexPath.row].from
        cell.rateLabel.text = currencies[indexPath.row].rate
        cell.toLabel.text = currencies[indexPath.row].to
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
}
