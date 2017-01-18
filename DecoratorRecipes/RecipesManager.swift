//
//  RecipesManager.swift
//  DecoratorRecipes
//
//  Created by Andrew Lopez-Vass on 1/18/17.
//  Copyright © 2017 Andrew Lopez-Vass. All rights reserved.
//

import Foundation

typealias IngredientObject = [String:String]

public enum JSONFiles:String {
    case Ingredients = "Ingredients"
}

public enum IngredientKeys {
    static let name = "name"
    static let imageUrl = "imageUrl"
}

class RecipesManager {
    static let sharedInstance = RecipesManager()
    var ingredients = [IngredientObject]()
    
    internal enum Constants {
        static let Ingredients = "Ingredients"
        static let jsonExt = "json"
    }
    
    func loadJson(forFilename fileName: String) -> JSONObject? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: Constants.jsonExt) {
            if let data = NSData(contentsOf: url) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? JSONObject
                    return json
                    
                } catch {
                    print("Error: Unable to parse \(fileName).json")
                }
            }
            print("Error: Unable to load \(fileName).json")
        }
        
        return nil
    }
    
    // MARK - Ingredients
    func loadIngredients() -> [IngredientObject] {
        if let loadedJSON = self.loadJson(forFilename: JSONFiles.Ingredients.rawValue),
            let ingredientsJSON = loadedJSON[Constants.Ingredients] as? [IngredientObject] {
            self.ingredients = ingredientsJSON
        }
        
        return self.ingredients
    }
    
    // MARK - Recipes
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
    
    func fetchRecipes(forIngredient name:String, handler: ([JSONObject]) -> Void) {
        self.getRecipes(ingredients: [name]){ response in
            
        }
    }
}
