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
        static let animationDuration = 0.5
    }
    
    internal enum Visibility {
        case OntoScreen
        case OffScreen
    }
    
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    internal var selectedIndexPath:IndexPath? {
        didSet {
            if let indexPath = selectedIndexPath {
                if oldValue != nil {
                    // Tableview already showing
                    self.fetchRecipes(forIndexPath: indexPath)
                    
                } else {
                    // Animate tableview onto screen
                    self.fetchRecipes(forIndexPath: indexPath)
                    self.animateRecipesTable(state: .OntoScreen)
                }
                
            } else {
                if oldValue != nil {
                    // Animate tableview off the screen
                    self.animateRecipesTable(state: .OffScreen) {
                        self.currentRecipes = []
                    }
                }
            }
        }
    }
    
    var ingredients:[StringObject] {
        get { return RecipesManager.sharedInstance.ingredients }
    }
    
    var currentRecipes = [StringObject]() {
        didSet {
            DispatchQueue.main.async {
                self.recipesTableView.setContentOffset(CGPoint.zero, animated: false)
                self.recipesTableView.reloadData()
            }
        }
    }

    /*override func viewDidLoad() {
        super.viewDidLoad()
        self.activityView.color = UIColor.black
    }*/
    
    internal func fetchRecipes(forIndexPath indexPath:IndexPath) {
        if let selectedIngredient = self.ingredients[indexPath.row][IngredientKeys.name] {
            self.activityView.startAnimating()
            RecipesManager.sharedInstance.fetchRecipes(forIngredient: selectedIngredient){ recipes in
                self.activityView.stopAnimating()
                self.currentRecipes = recipes
            }
        }
    }
    
    internal func animateRecipesTable(state:Visibility, finished: ((Void) -> Void)? = nil) {
        switch state {
        case Visibility.OntoScreen:
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                self.tableHeightConstraint.constant = self.containerView.frame.size.height
                self.view.layoutIfNeeded()
                
            }, completion:{ completed in
                finished?()
            })
            break
        case Visibility.OffScreen:
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                self.tableHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
                
            }, completion:{ completed in
                finished?()
            })
            break
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ingredientCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ingredientCellId, for: indexPath) as! IngredientCollectionViewCell
        ingredientCell.ingredient = self.ingredients[indexPath.row]
        ingredientCell.isSelected = indexPath == self.selectedIndexPath
        return ingredientCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var updateIndexPaths = [indexPath]
        if let previousIndexPath = self.selectedIndexPath {
            // Deselect previously selected ingredient
            if previousIndexPath == indexPath {
                self.selectedIndexPath = nil
                
            } else {
                // Highlight newly selected ingredient
                updateIndexPaths.append(previousIndexPath)
                self.selectedIndexPath = indexPath
            }
            
        } else {
            // Highlight newly selected ingredient
            self.selectedIndexPath = indexPath
        }
        
        collectionView.reloadItems(at: updateIndexPaths)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipeCell = tableView.dequeueReusableCell(withIdentifier: Constants.recipeCellId, for: indexPath) as! RecipeTableViewCell
        recipeCell.recipe = self.currentRecipes[indexPath.row]
        return recipeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
