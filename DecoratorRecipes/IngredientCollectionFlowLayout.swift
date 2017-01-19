//
//  IngredientCollectionFlowLayout.swift
//  DecoratorRecipes
//
//  Created by Andrew Lopez-Vass on 1/18/17.
//  Copyright © 2017 Andrew Lopez-Vass. All rights reserved.
//

import UIKit

@IBDesignable
class IngredientCollectionFlowLayout: UICollectionViewFlowLayout {
    @IBInspectable dynamic var numCols: Int = 2 {
        willSet {
            self.collectionView?.reloadData()
        }
    }
    
    @IBInspectable dynamic var itemSpacing: Int = 4 {
        willSet {
            minimumInteritemSpacing = CGFloat(newValue)
            minimumLineSpacing = CGFloat(newValue)
            
            self.collectionView?.reloadData()
        }
    }
    
    override var itemSize: CGSize {
        set { }
        get {
            if let collection = self.collectionView {
                let itemWidth = (collection.frame.size.width - (CGFloat(numCols) - 1)*(CGFloat(itemSpacing))) / CGFloat(numCols)
                return CGSize.init(width: itemWidth, height: collection.frame.size.height)
            }
            return CGSize.zero
        }
    }

}
