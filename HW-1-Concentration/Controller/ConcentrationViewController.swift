//
//  ViewController.swift
//  HW-1-Concentration
//
//  Created by Vyacheslav Bratukhin on 14.11.2017.
//  Copyright © 2017 Vyacheslav Bratukhin. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var topLabel: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
//        game.numberOfFlips += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        //new game resets .game variable, and replaces emojiChoises with a new random one from Themes
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        emojiChoices = emojiThemes[randomEmojiTheme()]! //can safely unwrap optional, randomEmojiTheme guarantees to return proper String key
        updateViewFromModel()
    }
    
    //MARK: public variables
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    //MARK: private variables

    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    private var emojiThemes: [String: [String]] = [
        "Fruits": ["🍏", "🍊", "🍍", "🥥", "🍉", "🍇", "🍒", "🍌", "🥝", "🍆"],
        "Faces" : ["😀", "😎", "😡", "😰", "😍", "🤣", "😬", "😈", "😳", "😜"],
        "Activity": ["⚽️", "🏄‍♂️", "🏑", "🏓", "🚴‍♂️", "🧘‍♀️", "🥋", "🎸", "🎯", "🎮"],
        "Animals": ["🐶", "🐱", "🐭", "🦊", "🦋", "🐢", "🐸", "🐵", "🐞", "🐠"],
        "Inventory": ["⌚️", "💾", "📡", "📞", "🎥", "⚒", "🔦", "📷", "📱", "💻"],
        "Clothes": ["👚", "👕", "👖", "👔", "👗", "👓", "👠", "🎩", "🧣", "🧤"]
    ]
    
    private lazy var emojiChoices: [String] = emojiThemes[self.randomEmojiTheme()]! //can safely unwrap optional, randomEmojiTheme guarantees to return proper String key
    //this array  is used to fill emoji var down below with emojis from randomly choosen theme
    
    private var emoji = [Card:String]()
    
    
    //MARK: funcs
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.7034695745, blue: 0.117319949, alpha: 1)
            }
        }
        flipCountLabel.text = "Flips: \(game.numberOfFlips)" //updating flipCountLabel as a part of syncing with model
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random())
        }
        return emoji[card] ?? "?"
    }
    
    //helper function to get random emoji theme and display its name as the topLabel text
    private func randomEmojiTheme() -> String {
        let emojiThemeKeys = Array(emojiThemes.keys)
        let randomEmojiTheme = emojiThemeKeys[emojiThemeKeys.count.arc4random()]
        self.topLabel.text = "Current theme: \(randomEmojiTheme)"
        return randomEmojiTheme
    }
}

// MARK: extensions

extension Int {
    func arc4random() -> Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

