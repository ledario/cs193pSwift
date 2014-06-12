//
//  CardMathingGame.swift
//  Matchismo
//
//  Created by Dario Vincent on 6/10/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

import Foundation

class CardMathingGame: NSObject {
    var score = 0
    var cards = Card[]()
    
    let COST_TO_CHOSE = 1
    let MATCH_BONUS = 4
    let MISMATCH_PENALTY = 2
    
    init(cardCount: Int, usingDeck deck: Deck) {
        super.init()
        for i in 0..cardCount {
            if let card = deck.drawRandomCard() {
                cards += card
            }
        }
    }
    
    func chooseCardAtIndex(index: Int) {
        if let card = cardAtIndex(index) {
            chooseCard(card)
        }
    }
    
    func cardAtIndex(index: Int) -> Card? {
        return (index < cards.count) ? cards[index] : nil
    }
    
    func chooseCard(card: Card?) {
        if card && !card!.matched { // Work only on cards not yet matched
            
            if card!.chosen { // If this card is already chosen
                if listOfChosenCards().count == 1 && listOfChosenCards()[0] === card {
                    card!.chosen = false // Flip card down
                }
            } else { // This card is not yet chosen
                
                card!.chosen = true // Flip card up
                score -= COST_TO_CHOSE // Decrease the score by COST_TO_CHOSE
                
                // Match attempt
                if listOfChosenCards().count == card!.matchCount() - 1 {
                    // Match cards
                    let matchScore = card!.match(listOfChosenCards())
                    if matchScore != 0 {
                        // Match successful - increase score - update play status
                        score += matchScore * MATCH_BONUS
                        // Mark all cards matched out of game
                        card!.matched = true
                        for otherCard in listOfChosenCards() {
                            otherCard.matched = true
                        }
                    } else {
                        // Match failed - decrease score - update play status
                        score -= MISMATCH_PENALTY
                        for otherCard in listOfChosenCards() {
                            // Remove other cards from list of cards chosen for match
                            otherCard.chosen = false
                        }
                    }
                }
                /*
                if let playScore = Card.match(self.listOfChosenCards()) { // Match successful
                    score += playScore // Increase game score
                } else if listOfChosenCards().count > 1 { // Match failed in group larger than 1
                    for otherCard in listOfChosenCards() { // Flip other cards down
                        if otherCard !== card! {
                            otherCard.isChosen = false
                        }
                    }
                    score -= MISMATCH_PENALTY // Decrease game score
                }
                */
            }
            
        }
    }
    
    func listOfChosenCards() -> Card[] {
        var listOfChosenCards = Card[]()
        for card in cards {
            if card.chosen && !card.matched {
                listOfChosenCards += card
            }
        }
        return listOfChosenCards
    }
}