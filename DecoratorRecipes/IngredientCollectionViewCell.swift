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
    @IBOutlet weak var selectionOverlay: UIView!
    
    var ingredient:StringObject? {
        willSet {
            self.nameLabel.text = newValue?[IngredientKeys.name]
            self.imageView.fetchImageForUrl(urlString: newValue?[IngredientKeys.imageUrl], callback: nil)
        }
    }
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                super.isSelected = true
                self.selectionOverlay.isHidden = false
                print("selected")
            } else if newValue == false {
                super.isSelected = false
                self.selectionOverlay.isHidden = true
                print("deselected")
            }
        }
    }
}
