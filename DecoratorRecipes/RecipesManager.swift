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
    func loadIngredients() {
        if let loadedJSON = self.loadJson(forFilename: JSONFiles.Ingredients.rawValue),
            let ingredientsJSON = loadedJSON[Constants.Ingredients] as? [StringObject] {
            self.ingredients = ingredientsJSON
        }
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
        // Normalize the ingredient name
        let nameLowercased = name.lowercased()
        
        // Check if the ingredient already has associated recipes
        if let cachedRecipes = self.ingredientRecipes[nameLowercased] {
            handler(cachedRecipes)
            return
        }
        
        // Fetch recipes for the ingredient
        self.getRecipes(ingredients: [nameLowercased]){ response in
            if let fetchedRecipes = response {
                // Find the most similar recipes
                self.findSimilarRecipes(ingredient: nameLowercased, recipes: fetchedRecipes)
                
                // Cache the fetched recipes
                self.ingredientRecipes[name] = fetchedRecipes
            }
            handler(response ?? [StringObject]())
        }
    }
    
    internal func findSimilarRecipes(ingredient:String, recipes:[StringObject]) {
        var combinatoryWeightMap = [String:Int]()
        for (curIndex, curRecipe) in recipes.enumerated() {
            // Get the subarray for the recipes after the current one
            let nextIndex = curIndex + 1
            let lastIndex = recipes.count - 1
            let remainingRecipes = nextIndex < lastIndex ? Array(recipes[nextIndex...lastIndex]) : []
            
            // Grab the combinatory weights for the recipes
            combinatoryWeightMap = combinatoryWeightMap + self.sharedIngredientWeights(baseIngredient: ingredient, offsetIndex: curIndex, recipe: curRecipe, otherRecipes: remainingRecipes)
        }
        
        // TODO: Print to console
        print("Combinatory Weight Map: \(combinatoryWeightMap)")
    }
    
    internal func sharedIngredientWeights(baseIngredient:String, offsetIndex:Int, recipe:StringObject, otherRecipes:[StringObject]) -> [String:Int] {
        // No other recipes to compare against, or invalid mapping index
        if otherRecipes.count == 0 || offsetIndex < 0 {
            return [:]
        }
        
        // No Ingredients to compare, or doesn't contain base ingredient
        let ingredientString = recipe[RecipeKeys.ingredients] ?? ""
        let comparisonIngredients = ingredientString.components(separatedBy: ", ")
        if comparisonIngredients.count == 0 || !ingredientString.contains(baseIngredient) {
            return [:]
        }
        
        // Map the inclusive ingredient combinations
        var combinatoryRecipeWeightMap = [String:Int]()
        for (relativeIndex, recipeCounterpart) in otherRecipes.enumerated() {
            
            // Ensure the counterpart recipe contains the base ingredient
            let recipeCounterpartString = recipeCounterpart[RecipeKeys.ingredients] ?? ""
            if recipeCounterpartString.contains(baseIngredient) {
                
                // Keep track of the matched ingredients' count
                var matchWeight = 0
                comparisonIngredients.forEach({ ingredient in
                    if recipeCounterpartString.contains(ingredient) {
                        // Increment the weight for every matched ingredient
                        matchWeight += 1
                    }
                })
                
                // Encode the occurrence weight for the recipe combination
                let mappingIndex = offsetIndex + relativeIndex + 1
                let indiciesKey = "\(offsetIndex):\(mappingIndex)"
                combinatoryRecipeWeightMap[indiciesKey] = matchWeight
            }
        }
        
        return combinatoryRecipeWeightMap
    }
}
