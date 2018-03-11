//
//  Concentration.swift
//
//  Created by CS193p Instructor  on 09/25/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import Foundation

class Concentration {
	
	private(set) var cards = [Card]()
    var gameScore = 0
    var flipCount = 0
    private var seenIds = [Int]()
    
	private var indexOfOneAndOnlyFaceUpCard: Int? {
		get {
			var foundIndex: Int?
			for index in cards.indices {
				if cards[index].isFaceUp  {
					guard foundIndex == nil else { return nil }
					foundIndex = index
				}
			}
			return foundIndex
		}
		set {
			for index in cards.indices {
				cards[index].isFaceUp = (index == newValue)
			}
		}
	}
	
	func chooseCard(at index: Int) {
		assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)) : Choosen index out of range")
		if !cards[index].isMatched {
            flipCount += 1
			if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
				// check if cards match
				if cards[matchIndex].identifier == cards[index].identifier {
					cards[matchIndex].isMatched = true
					cards[index].isMatched = true
                    gameScore += 2
                } else {
                    if seenIds.contains(cards[index].identifier){
                        gameScore -= 1
                    }
                    if seenIds.contains(cards[matchIndex].identifier){
                        gameScore -= 1
                    }
                }
                seenIds.append(cards[index].identifier)
				cards[index].isFaceUp = true
			} else {
				indexOfOneAndOnlyFaceUpCard = index
            }
		}
	}
	
	init(numberOfPairsOfCards: Int) {
		assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)) : You must have at least one pair of cards")
		for _ in 1...numberOfPairsOfCards {
			let card = Card()
			cards += [card, card]
		}
        // Shuffle the cards
        shuffleCards()
	}
    
    func shuffleCards(){
        var shuffeled = [Card]()
        while !cards.isEmpty {
            shuffeled.append(cards.remove(at: cards.count.arc4random))
        }
        cards = shuffeled
    }
    
    func startNewGame(){
        for cardIndex in cards.indices {
            cards[cardIndex].isFaceUp = false
            cards[cardIndex].isMatched = false
        }
        gameScore = 0
        flipCount = 0
        seenIds = [Int]()
        shuffleCards()
    }
}


