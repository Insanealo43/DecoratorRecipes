//
//  Extensions.swift
//  DecoratorRecipes
//
//  Created by Andrew Lopez-Vass on 1/18/17.
//  Copyright © 2017 Andrew Lopez-Vass. All rights reserved.
//

import Foundation

func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    var result = lhs
    rhs.forEach{ result[$0] = $1 }
    return result
}

func subArray<T>(array: [T], range: NSRange) -> [T] {
    if range.location > array.count {
        return []
    }
    return Array(array[range.location..<min(range.length, array.count)])
}
