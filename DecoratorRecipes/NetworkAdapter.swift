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
    func request(url:String, method:HTTPMethod? = .get, parameters:JSONObject? = [:], handler: ((JSONObject?) -> Void)? = nil) {
        Alamofire.request(url, method: method!, parameters: parameters).validate().responseJSON { response in
            let JSON = (response.result.value as? JSONObject ?? [:])
            switch response.result {
            case .failure(let error):
                print("NetworkManager: Request Error: \(error)")
                handler?(nil)
            case .success:
                handler?(JSON)
            }
        }
    }
}
