//
//  RecipesManager.swift
//  DecoratorRecipes
//
//  Created by Andrew Lopez-Vass on 1/18/17.
//  Copyright © 2017 Andrew Lopez-Vass. All rights reserved.
//

import Foundation

typealias StringObject = [String:String]

public enum JSONFiles:String {
    case Ingredients = "Ingredients"
}

public enum IngredientKeys {
    static let name = "name"
    static let imageUrl = "imageUrl"
}

public enum RecipeKeys {
    static let title = "title"
    static let thumbnail = "thumbnail"
    static let ingredients = "ingredients"
}


class RecipesManager {
    static let sharedInstance = RecipesManager()
    var ingredients = [StringObject]()
    var ingredientRecipes = [String:[StringObject]]()
    
    internal enum Constants {
        static let Ingredients = "Ingredients"
        static let jsonExt = "json"
        static let results = "results"
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
    func loadIngredients() -> [StringObject] {
        if let loadedJSON = self.loadJson(forFilename: JSONFiles.Ingredients.rawValue),
            let ingredientsJSON = loadedJSON[Constants.Ingredients] as? [StringObject] {
            self.ingredients = ingredientsJSON
        }
        
        return self.ingredients
    }
    
    // MARK - Recipes
    func getRecipes(query:String? = nil, ingredients:[String]? = nil, page:Int? = nil,
                    handler: @escaping ([StringObject]?) -> Void) {
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
        NetworkAdapter.sharedInstance.request(url: url, method: .post, parameters: params){ response in
            let recipeObjects = response?[Constants.results] as? [StringObject]
            handler(recipeObjects)
        }
    }
    
    func fetchRecipes(forIngredient name:String, handler: @escaping ([StringObject]) -> Void) {
        // Check if the ingredient already has associated recipes
        if let cachedRecipes = self.ingredientRecipes[name] {
            handler(cachedRecipes)
            return
        }
        
        // Fetch recipes for the ingredient
        self.getRecipes(ingredients: [name]){ response in
            if let fetchedRecipes = response {
                // Cache the fetched recipes
                self.ingredientRecipes[name] = fetchedRecipes
            }
            handler(response ?? [StringObject]())
        }
    }
}
