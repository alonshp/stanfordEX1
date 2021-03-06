//  ViewController.swift
//  Concentration
//
//  Created by CS193p Instructor  on 09/25/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    private var faceUpCardsNumbers = [Int]()
    
    private var currTheme = "Halloween"
	
	var numberOfPairsOfCards: Int {
		return (cardButtons.count + 1) / 2
	}
	
	@IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var gameScoreLable: UILabel!
    
	@IBOutlet private var cardButtons: [UIButton]!
	
    @IBOutlet weak var newGameButton: UIButton!
    
    private func showAlertWhenGameFinished() {
        // create the alert
        let alert = UIAlertController(title: "Congratulations!", message: "Your Final Score: \(self.game.gameScore)", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        guard let cardNumber = cardButtons.index(of: sender) else {
            print("choosen card was not in cardButtons")
            return
        }
        game.chooseCard(at: cardNumber)
        if !faceUpCardsNumbers.contains(cardNumber){
            faceUpCardsNumbers.append(cardNumber)
        }
        updateViewFromModel()

        if faceUpCardsNumbers.count == 2 {
            view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                for cardNumber in self.faceUpCardsNumbers {
                    self.game.faceDownCard(at: cardNumber)
                }
                self.faceUpCardsNumbers = [Int]()
                self.updateViewFromModel()
                
                self.view.isUserInteractionEnabled = true
                
                // check if the player finished
                if self.game.matchesLeft == 0 {
                    self.showAlertWhenGameFinished()
                }
            }
        }
	}
    
    @IBAction func startNewGame(_ sender: UIButton) {
        game.startNewGame()
        emoji = [Int: String]()
        updateEmojiTheme()
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
				button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : ThemeCardsBackgroundColors[currTheme]
			}
		}
        
        let currGameScore = game.gameScore
        gameScoreLable.text = "Score: \(currGameScore)"
        
        let currFlipsCount = game.flipCount
        flipCountLabel.text = "Flips: \(currFlipsCount)"
    }
	
    private let emojiThemes = ["Animals": ["🐶","🐭","🐤","🐒","🐝","🐞","🐠","🦔"],
                              "Faces": ["😀","🤣","😛","😖","😬","🤩","😭","😡"],
                              "Sports": ["⚽️","🏀","🏈","🎾","🎱","🏒","🥊","🏄‍♂️"],
                              "Halloween": ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"]]
    
    private let ThemeBackgroudColors = ["Animals": #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), "Faces":#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), "Sports": #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), "Halloween":#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
    private let ThemeCardsBackgroundColors = ["Animals": #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), "Faces":#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), "Sports": #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), "Halloween":#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)]
    
    private var emojiNames: [String]{
        return [String](emojiThemes.keys)
    }
    
    private var emojiChoices = ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"]
    
    private var emoji = [Int: String]()
    
	private func emoji(for card: Card) -> String {
        // pick emoji for card
		if emoji[card.identifier] == nil, emojiChoices.count > 0 {
			emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
		}
		return emoji[card.identifier] ?? "?"
	}
    
    
    private func updateEmojiTheme(){
        let choosedEmojiThemeNumber = emojiNames.count.arc4random
        if let choosedEmojies = emojiThemes[emojiNames[choosedEmojiThemeNumber]]{
            currTheme = emojiNames[choosedEmojiThemeNumber]
            emojiChoices = choosedEmojies
            changeGameTheme()
        }
    }
    
    private func changeGameTheme(){
        view.backgroundColor = ThemeBackgroudColors[currTheme]
        flipCountLabel.textColor = ThemeCardsBackgroundColors[currTheme]
        gameScoreLable.textColor = ThemeCardsBackgroundColors[currTheme]
        newGameButton.backgroundColor = ThemeCardsBackgroundColors[currTheme]
        changeCardsBackgroundColor(color: ThemeCardsBackgroundColors[currTheme]!)
    }
    
    private func changeCardsBackgroundColor(color: UIColor){
        
        for button in cardButtons {
            button.backgroundColor = color
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self))) }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}














