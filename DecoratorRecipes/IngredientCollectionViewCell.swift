//
//  IngredientCollectionViewCell.swift
//  DecoratorRecipes
//
//  Created by Andrew Lopez-Vass on 1/18/17.
//  Copyright © 2017 Andrew Lopez-Vass. All rights reserved.
//

import UIKit

class IngredientCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var ingredient:StringObject? {
        willSet {
            self.nameLabel.text = newValue?[IngredientKeys.name]
            self.imageView.fetchImageForUrl(urlString: newValue?[IngredientKeys.imageUrl], callback: nil)
        }
    }
}
