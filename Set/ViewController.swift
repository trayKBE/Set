//
//  ViewController.swift
//  Set
//
//  Created by class on 2019/1/3.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var faceUpCardCount = 12
    
    let moreButtonNumber = 3
    
    var pointRate:Float {
        get {
            return Float(setCards.count)/Float(faceUpButtonIndexs.count)
        }
    }

    @IBOutlet weak var moreCardsButton: UIButton!
    
    @IBAction func newGame(_ sender: Any) {
        faceUpButtonIndexs = []
        game = Deck()
        //moreCardsButton.isEnabled = true
        initMoreButton()
        showMoreButtons(moreButtonsNum: faceUpCardCount)
        game.addMoreCards(moreCardsNumber: faceUpCardCount)
        updateViewWithModel()
        
    }
    @IBOutlet weak var pointLabel: UILabel!{
        didSet{
            
            
            showMoreButtons(moreButtonsNum: faceUpCardCount)
            game.addMoreCards(moreCardsNumber: faceUpCardCount)
            updateViewWithModel()
        }
    }
    var faceUpButtonIndexs = [Int]()
    var leftButtonIndexs:[Int]{
        get {
            var indexs = [Int]()
            for index in 0 ..< setCards.count {
                if !faceUpButtonIndexs.contains(index){
                    indexs.append(index)
                }
            }
            return indexs
        }
    }
    var cardNumbers = [0,1,2]
    var cardColors = [UIColor.green, UIColor.brown,UIColor.red]
    var cardShadings = ["▲","●","■"]
    var cardStripings:[(lineWidth:Int,alphaComponent:CGFloat)] = [(-1,CGFloat(0.15)), (-1,CGFloat(1)), (15,CGFloat(1))]
    
    lazy var game = Deck()
   
    
    @IBOutlet  var setCards: [UIButton]!
    
    
    
    @IBAction func setCardAction(_ sender: UIButton) {
        if let buttonIndex = setCards.index(of:sender){
            if let index = faceUpButtonIndexs.index(of : buttonIndex){
                game.selectCard(at: index)
                updateViewWithModel()
            }
        }
    }
    @IBAction func dealButton(_ sender: UIButton) {
        let isReplace = game.ifAddCards(moreCardsNumber: moreButtonNumber)
        if !isReplace {
            showMoreButtons(moreButtonsNum: moreButtonNumber)
        }
        updateViewWithModel()
    }
    
    @IBAction func checkAction(_ sender: UIButton) {
        game.cheat()
        updateViewWithModel()
        
    }
    
    func updateViewWithModel(){
        for  index in setCards.indices {
            let cardButton = setCards[index]
            if let faceUpIndex  = faceUpButtonIndexs.index(of:index) {
                cardButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cardButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                let cardIndex = game.faceUpCardIndex[faceUpIndex]
                if cardIndex != nil {
                    let card = game.cards[cardIndex!]
                    drawCard(card: card,cardButton: cardButton)
                }else{
                    drawBlankCard(cardButton: cardButton)
                }
            }else{
                cardButton.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                cardButton.setAttributedTitle(nil, for: UIControl.State.normal)
            }
        }
        pointLabel.text = "Point:\(Int(pointRate * Float(game.points)))"
        if !game.isDealEnable || leftButtonIndexs.count == 0 {
            moreButtonUnabled()
        }
    }
    
    func moreButtonUnabled(){
        moreCardsButton.isEnabled = false
        moreCardsButton.setTitle("No More", for: UIControl.State.normal)
    }
    
    func initMoreButton() {
        moreCardsButton.isEnabled = true
        moreCardsButton.setTitle("More", for: UIControl.State.normal)
    }
    
    func showMoreButtons(moreButtonsNum:Int){
        for _ in 0 ..< moreButtonsNum {
                let randomIndex = Int(arc4random_uniform(UInt32(leftButtonIndexs.count)))
                let randomValue = leftButtonIndexs[randomIndex]
                faceUpButtonIndexs.append(randomValue)
        }
       
    }
    
    func drawCard(card:Card, cardButton:UIButton){
       
        let attributeKey:[NSAttributedString.Key:Any] = [
            .strokeWidth: cardStripings[card.striping].lineWidth,
            .foregroundColor:cardColors[card.color].withAlphaComponent(cardStripings[card.striping].alphaComponent)
            
        ]
        
        
        var cardString = ""
        for _ in 0...cardNumbers[card.number]{
            cardString.append(cardShadings[card.shading])
        }
        
        let attributeString = NSAttributedString(string: cardString, attributes: attributeKey)
        cardButton.setAttributedTitle(attributeString, for: UIControl.State.normal)
        
        if card.isSelected {
            cardButton.layer.borderWidth = 3.0
            cardButton.layer.borderColor = UIColor.blue.cgColor
            cardButton.layer.cornerRadius = 8.0
        }else{
            cardButton.layer.borderWidth = 0
            cardButton.layer.borderColor = UIColor.clear.cgColor
            cardButton.layer.cornerRadius = 0
        }
    }
    
    func drawBlankCard(cardButton:UIButton) {
        cardButton.backgroundColor = UIColor.clear
        cardButton.setAttributedTitle(nil, for: UIControl.State.normal)
        cardButton.layer.borderWidth = 0
        cardButton.layer.borderColor = UIColor.clear.cgColor
        cardButton.layer.cornerRadius = 0
    }
    
}

