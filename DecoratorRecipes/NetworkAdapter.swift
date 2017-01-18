//
//  NetworkAdapter.swift
//  DecoratorRecipes
//
//  Created by Andrew Lopez-Vass on 1/18/17.
//  Copyright © 2017 Andrew Lopez-Vass. All rights reserved.
//

import Foundation
import Alamofire

typealias JSONObject = [String:AnyObject]

public enum Urls:String {
    case RecipePuppyAPI = "http://www.recipepuppy.com/api/"
}

class NetworkAdapter {
    static let sharedInstance = NetworkAdapter()
    
    // Default HTTP method is 'Get'
    func request(url:String, method:HTTPMethod? = .get, parameters:JSONObject? = [:], handler: ((JSONObject) -> Void)? = nil) {
        Alamofire.request(url, method: method!, parameters: parameters).validate().responseJSON { response in
            let JSON = (response.result.value as? JSONObject ?? [:])
            switch response.result {
            case .failure(let error):
                print("NetworkManager: Request Error: \(error)")
                handler?([:])
            case .success:
                handler?(JSON)
            }
        }
    }
    
    func getRecipes(query:String? = nil, ingredients:[String]? = nil, page:Int? = nil,
                    handler: (JSONObject) -> Void) {
        var params = JSONObject()
        if let q = query {
            params["q"] = q as AnyObject
        }
        if let i = ingredients?.joined(separator: ",") {
            params["i"] = i as AnyObject
        }
        if let p = page {
            params["p"] = p as AnyObject
        }
        
        let url = Urls.RecipePuppyAPI.rawValue
        self.request(url: url, method: .post, parameters: params){ response in
            print("Recipes Response: \(response)")
        }
    }
}
