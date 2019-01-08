//
//  NetworkServices.swift
//  GNB
//
//  Created by Adi Veliman on 07/01/2019.
//  Copyright © 2019 Adi Veliman. All rights reserved.
//

import Foundation
import Alamofire

class NetworkServices{

func getCurrencies(completion: @escaping ([Currency]) -> ()){
    
    let URL = "http://gnb.dev.airtouchmedia.com/rates.json"
    
    let headers: HTTPHeaders = [
        "Content-Type":"application/json",
        "Accept": "application/json"
    ]
    
    //accept header specifies the content type of the request
    
    Alamofire.request(URL, method: HTTPMethod.get, headers: headers).validate(statusCode: 200..<300).responseData { (response) in
   
        let json = response.data
        var currencies = [Currency]()
        
        do{
            let decoder = JSONDecoder()
            currencies = try decoder.decode([Currency].self, from: json!)
            completion(currencies)
        }catch let err{
            print(err)
        }
    }
    
}
    
    func getTransaction(completion: @escaping ([Transaction]) -> ()){
        
        let URL = "http://gnb.dev.airtouchmedia.com/transactions.json"
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        
        Alamofire.request(URL, method: HTTPMethod.get, headers: headers).validate(statusCode: 200..<300).responseData { (response) in
            let json = response.data
            var transactions = [Transaction]()
            
            do{
                let decoder = JSONDecoder()
                transactions = try decoder.decode([Transaction].self, from: json!)
                completion(transactions)
            }catch let err{
                print(err)
            }
        }
        
    }

}
