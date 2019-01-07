//
//  Card.swift
//  Set
//
//  Created by class on 2019/1/3.
//  Copyright © 2019 study. All rights reserved.
//

import Foundation

struct Card:Equatable{
    var number:Int
    var color:Int
    var shading:Int
    var striping:Int
    
    var isSelected = false
    var isMatched =  false
    var isFaceUp = false
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.number == rhs.number && lhs.color == rhs.color && lhs.shading == rhs.shading && lhs.striping == rhs.striping
    }
    
    init(number:Int, color:Int, shading:Int, striping:Int) {
        self.number = number
        self.color = color
        self.shading = shading
        self.striping = striping
        
        
    }
    
}
