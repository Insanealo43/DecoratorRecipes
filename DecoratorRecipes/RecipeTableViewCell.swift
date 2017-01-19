//
//  RecipeTableViewCell.swift
//  DecoratorRecipes
//
//  Created by Andrew Lopez-Vass on 1/18/17.
//  Copyright © 2017 Andrew Lopez-Vass. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    var recipe:StringObject? {
        willSet {
            self.recipeImageView.fetchImageForUrl(urlString: newValue?[RecipeKeys.thumbnail], callback: nil)
            self.nameLabel.text = newValue?[RecipeKeys.title]
            self.ingredientsLabel.text = newValue?[RecipeKeys.ingredients]
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
