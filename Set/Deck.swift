//
//  Deck.swift
//  Set
//
//  Created by class on 2019/1/3.
//  Copyright © 2019 study. All rights reserved.
//

import Foundation

class Deck{
    var cards = [Card]()
    var faceUpCardIndex = [Int?]()
    var points:Int
    let propertyNumber = 3
    
    var isDealEnable = true
    
    var faceUpIndex:Int {
        return cards.filter{$0.isFaceUp}.count
    
    }
    var selectedCards:[Card]{
        return cards.filter{$0.isSelected}
    }

    init() {
        for numberIndex in 0..<propertyNumber{
            for colorIndex in 0..<propertyNumber{
                for shadingIndex in 0..<propertyNumber{
                    for stripingIndex in 0..<propertyNumber{
                        let card = Card(number: numberIndex, color: colorIndex, shading: shadingIndex, striping: stripingIndex)
                        cards.append(card)
                    }
                }
            }
        }
        cards.shuffle()
        
        points = 0
        isDealEnable = true
        faceUpCardIndex = []
    }
    
    func selectCard(at faceUpIndex:Int){
        let cardIndex = faceUpCardIndex[faceUpIndex]
        if cardIndex != nil {
//            let selectedCards = cards.filter{$0.isSelected}
            if selectedCards.count == 3 {
                if checkSelectedResult() {
                    replaceCard()
                }else{
                    points -= 5
                }
                for index in cards.indices {
                    cards[index].isSelected = false
                }
                 let currentIndex = faceUpCardIndex[faceUpIndex]
                if currentIndex != nil {
                    cards[currentIndex!].isSelected = true
                }
            }else{
                if cards[cardIndex!].isSelected {
                    points -= 1
                }
               cards[cardIndex!].isSelected = !cards[cardIndex!].isSelected
                
            }
        }
    }

    func checkSelectedResult() -> Bool{
        
//        let checkCards = cards.filter{$0.isSelected}
        return checkSetResult(checkCards: selectedCards)
     
    }
    
    func addMoreCards(moreCardsNumber:Int){
        for _ in 0 ..< moreCardsNumber {
            if faceUpIndex < cards.count{
                faceUpCardIndex.append(faceUpIndex)
                cards[faceUpIndex].isFaceUp = true
            }
        }
    }
    
    func ifAddCards(moreCardsNumber:Int) -> Bool{
        let  checkResult = checkSelectedResult()
        if  checkResult {
            replaceCard()
        }else{
            addMoreCards(moreCardsNumber: moreCardsNumber)
        }
        isDealEnable = !(faceUpIndex == cards.count)
        return checkResult
    }
    
    func replaceCard(){
        for index in faceUpCardIndex.indices {
            if faceUpCardIndex[index] != nil &&  cards[faceUpCardIndex[index]!].isSelected {
                cards[faceUpCardIndex[index]!].isMatched = true
                cards[faceUpCardIndex[index]!].isSelected = false
                if faceUpIndex < cards.count {
                    faceUpCardIndex[index] = faceUpIndex
                    cards[faceUpIndex].isFaceUp = true
                }else{
                    faceUpCardIndex[index] = nil
                }
            }
        }
        points += 3
    }
    
    func cheat() {
        for  index in faceUpCardIndex {
            if index != nil {
                cards[index!].isSelected = false
            }
        }
        for i in 0 ..< faceUpCardIndex.count{
            for j in i+1 ..< faceUpCardIndex.count {
                for k in j+1 ..< faceUpCardIndex.count {
                    if faceUpCardIndex[i] != nil && faceUpCardIndex[j] != nil && faceUpCardIndex[k] != nil {
                        if checkSetResult(checkCards: [cards[faceUpCardIndex[i]!],cards[faceUpCardIndex[j]!],cards[faceUpCardIndex[k]!]]){
                          
                            cards[faceUpCardIndex[i]!].isSelected = true
                            cards[faceUpCardIndex[j]!].isSelected = true
                             cards[faceUpCardIndex[k]!].isSelected = true
                            return
                        }
                    }
                }
            }
        }
    }
    
    func checkSetResult(checkCards:[Card]) -> Bool {
        if checkCards.count != 3 {
            return false
        }
        
        var numberCount = 0
        var colorCount = 0
        var shadingCount = 0
        var stripingCount = 0
        for card in checkCards {
            numberCount += card.number
            colorCount += card.color
            shadingCount += card.shading
            stripingCount += card.striping
        }
        let result = numberCount % 3 + colorCount % 3 + shadingCount % 3 + stripingCount % 3
        return result == 0
    }
    
}
