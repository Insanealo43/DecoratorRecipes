//
//  ViewController.swift
//  DecoratorRecipes
//
//  Created by Andrew Lopez-Vass on 1/18/17.
//  Copyright © 2017 Andrew Lopez-Vass. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController {
    internal enum Constants {
        static let ingredientCellId = "ingredientCollectionViewCell"
        static let recipeCellId = "recipeTableViewCell"
    }
    
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    var ingredients:[StringObject] {
        get { return RecipesManager.sharedInstance.ingredients }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityView.startAnimating()
    }
    
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ingredientCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ingredientCellId, for: indexPath) as! IngredientCollectionViewCell
        ingredientCell.ingredient = self.ingredients[indexPath.row]
        return ingredientCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipeCell = tableView.dequeueReusableCell(withIdentifier: Constants.recipeCellId, for: indexPath) as! RecipeTableViewCell
        
        return recipeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
