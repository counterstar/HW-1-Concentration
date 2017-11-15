//
//  Card.swift
//  HW-1-Concentration
//
//  Created by Vyacheslav Bratukhin on 14.11.2017.
//  Copyright © 2017 Vyacheslav Bratukhin. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    
    var wasSeen = false //keeping track of cards being seen to the player
    
    private var identifier: Int
    
    private static var identifierFactory = 0
   
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
