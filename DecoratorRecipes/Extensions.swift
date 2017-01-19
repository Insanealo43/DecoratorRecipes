//
//  Extensions.swift
//  DecoratorRecipes
//
//  Created by Andrew Lopez-Vass on 1/18/17.
//  Copyright © 2017 Andrew Lopez-Vass. All rights reserved.
//

import UIKit
import SDWebImage

// MARK - Dictionary Helpers
func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    var result = lhs
    rhs.forEach{ result[$0] = $1 }
    return result
}

extension UIImageView {
    func fetchImageForUrl(urlString: String?, callback: ((UIImage?) -> Void)?) {
        if let imageUrl = urlString {
            self.sd_setImage(with: URL.init(string: imageUrl), placeholderImage: nil,
                             options: [.continueInBackground, .lowPriority])
            { (image, error, cacheType, url) in
                self.image = image
                callback?(image)
            }
            
        } else {
            callback?(nil)
        }
    }
}
