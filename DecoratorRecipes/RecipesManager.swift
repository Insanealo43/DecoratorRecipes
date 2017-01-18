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
    
    func loadIngredients() -> [IngredientObject] {
        if let loadedJSON = self.loadJson(forFilename: JSONFiles.Ingredients.rawValue),
            let ingredientsJSON = loadedJSON[Constants.Ingredients] as? [IngredientObject] {
            self.ingredients = ingredientsJSON
        }
        
        return self.ingredients
    }
}
