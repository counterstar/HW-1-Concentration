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
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        //new game resets .game variable, and replaces emojiThemes with a new random one from Themes
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        setupRandomEmojiTheme()
        updateViewFromModel()
    }
    
    //MARK: public variables
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    //MARK: private variables

    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    typealias emojiTheme = (name: String, emojis: [String], backgroundColor: UIColor, cardBackColor: UIColor)
    
    private var emojiThemes: [emojiTheme] = [
        ("Fruits", ["🍏", "🍊", "🍍", "🥥", "🍉", "🍇", "🍒", "🍌", "🥝", "🍆"], #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)),
        ("Faces", ["😀", "😎", "😡", "😰", "😍", "🤣", "😬", "😈", "😳", "😜"], #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
        ("Activity", ["⚽️", "🏄‍♂️", "🏑", "🏓", "🚴‍♂️", "🧘‍♀️", "🥋", "🎸", "🎯", "🎮"], #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)),
        ("Animals", ["🐶", "🐱", "🐭", "🦊", "🦋", "🐢", "🐸", "🐵", "🐞", "🐠"], #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)),
        ("Inventory", ["⌚️", "💾", "📡", "📞", "🎥", "⚒", "🔦", "📷", "📱", "💻"], #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
        ("Clothes", ["👚", "👕", "👖", "👔", "👗", "👓", "👠", "🎩", "🧣", "🧤"], #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
    ]
    
    private var currentTheme: emojiTheme = ("", [], UIColor.black, UIColor.black)
        //initialazing starting theme for convinience purposes. It is never used.
    {
        didSet {
            self.topLabel.text = "Current theme: \(currentTheme.name)"
            self.view.backgroundColor = currentTheme.backgroundColor
            self.topLabel.textColor = currentTheme.cardBackColor
            self.scoreLabel.textColor = currentTheme.cardBackColor
            self.flipCountLabel.textColor = currentTheme.cardBackColor
        }
    }
    
    private var emoji = [Card:String]()
    
    //MARK: funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRandomEmojiTheme()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : currentTheme.cardBackColor
            }
        }
        flipCountLabel.text = "Flips: \(game.numberOfFlips)" //updating flipCountLabel as a part of syncing with model
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, currentTheme.emojis.count > 0 {
            emoji[card] = currentTheme.emojis.remove(at: currentTheme.emojis.count.arc4random())
        }
        return emoji[card] ?? "?"
    }
    
    //helper function to get random emoji theme
    private func setupRandomEmojiTheme() {
        self.currentTheme = emojiThemes[emojiThemes.count.arc4random()]
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

