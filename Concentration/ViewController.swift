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
	
	var numberOfPairsOfCards: Int {
		return (cardButtons.count + 1) / 2
	}
	
	@IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var gameScoreLable: UILabel!
    
	@IBOutlet private var cardButtons: [UIButton]!
	
	
	@IBAction private func touchCard(_ sender: UIButton) {
		if let cardNumber = cardButtons.index(of: sender) {
			game.chooseCard(at: cardNumber)
            faceUpCardsNumbers.append(cardNumber)
			updateViewFromModel()
		} else {
			print("choosen card was not in cardButtons")
		}
        if faceUpCardsNumbers.count == 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                for cardNumber in self.faceUpCardsNumbers {
                    self.game.faceUpCard(at: cardNumber)
                }
                self.faceUpCardsNumbers = [Int]()
                self.updateViewFromModel()
                
                // check if the player finished
                if self.game.matchesLeft == 0 {
                    // create the alert
                    let alert = UIAlertController(title: "Congratulations!", message: "Your Final Score: \(self.game.gameScore)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
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
				button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
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
            emojiChoices = choosedEmojies
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














