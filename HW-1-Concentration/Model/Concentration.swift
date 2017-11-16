//
//  File.swift
//  HW-1-Concentration
//
//  Created by Vyacheslav Bratukhin on 14.11.2017.
//  Copyright © 2017 Vyacheslav Bratukhin. All rights reserved.
//

import Foundation

struct Concentration
{
    
    //MARK: public vars
    var numberOfFlips: Int = 0
    
    //MARK: private(set) vars
    private(set) var score: Int = 0
    
    private(set) var cards = [Card]()
    
    //MARK: private vars
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    //MARK: funcs
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.choosesCard(at: \(index)): choosen index not in the cards")
        if !cards[index].isMatched {
            numberOfFlips += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    //if cards match, we are good
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2 // + 2 to the score when cards match, no penalty, good job!
                } else {
                    //otherwise, if 2 cards are not matched, score penalty to player
                    var penalty = 0
                    
                    if (cards.filter{$0 == cards[matchIndex]}.filter{$0.wasSeen}.count) > 0 {penalty += 1}
                    //extract all cards similar to first of 2 flipped, then see if any was seen before
                    //penalty increased by 1 if first flipped card or a card similar to it was seen before
                    if cards[index].wasSeen {penalty += 1}
                    //penalty increased by 1 if second flipped card was seen before (no checks for similarity)
                    
                    print("penalty is", penalty)
                    score -= penalty
                }
                print("score is", score)
                
                cards[index].wasSeen = true
                cards[matchIndex].wasSeen = true //2 flipped are setted to .wasSeen state
                
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    //MARK: inits
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
        //now just simple shuffle method using extension to Array<ELement>
    }
}


    //MARK: extensions

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}


//extension Array {
//    mutating func shuffle() {
//        var shuffledArray: [Element] = []
//        while self.count > 0 {
//            shuffledArray += [self.remove(at: self.count.arc4random())]
//        }
//        self = shuffledArray
//    }
//}

// moved .shuffle method to an extension of array (probably belongs here)
// uses Int.arc4random() func declared elsewhere
extension Array {
    public mutating func shuffle() {
        for i in stride(from: count - 1, through: 1, by: -1) {
            let j = (i + 1).arc4random()
            if i != j {
                self.swapAt(i, j)
            }
        }
        print(self)
    }
}
