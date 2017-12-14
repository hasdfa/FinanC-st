//
//  UINumberPad.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 24.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class UINumberPad: UIView {

    public weak var delegate: UINumberPadDelegate?
    
    let colors: [UIColor] = [
//        #colorLiteral(red: 0.8090330958, green: 0.8883366585, blue: 1, alpha: 1),
        #colorLiteral(red: 0.7334416509, green: 0.840385735, blue: 1, alpha: 1),
        #colorLiteral(red: 0.6495530009, green: 0.7921726108, blue: 1, alpha: 1),
        #colorLiteral(red: 0.5493233204, green: 0.7358713746, blue: 1, alpha: 1),
        #colorLiteral(red: 0.4612213373, green: 0.6759732366, blue: 0.9873214364, alpha: 1),
        #colorLiteral(red: 0.3937077522, green: 0.885607779, blue: 0.7678512931, alpha: 1)
    ]
    let buttonsPortraitData: [[String]] = [
//        ["÷", "x", "+", "-"],
        ["7", "8", "9", "C"],
        ["4", "5", "6", "AC"],
        ["1", "2", "3", "="],
        ["0", "00", ".", "="]
    ]
    let buttonsLanscapeData: [[String]] = [
        //        ["÷", "x", "+", "-"],
        ["7", "8", "9", "C"],
        ["4", "5", "6", "AC"],
        ["1", "2", "3", "="],
        ["0", "00", ".", "="]
    ]
    
    var isObserving = false
    var orientation = 0
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = nil
        
        let buttonsData = UIDevice.current.orientation.isPortrait
            ? buttonsPortraitData
            : buttonsLanscapeData
        
        let width = self.bounds.width / CGFloat(buttonsData[0].count)
        let height = self.bounds.height / CGFloat(buttonsData.count)
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
        
        let horizontalStackView = UIStackView(frame: self.bounds)
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.axis = .horizontal
        
        for i in 0..<4 {
            let customFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: rect.height)
            let verticalStackView = UIStackView(frame: customFrame)
            verticalStackView.distribution = .fillEqually
            if i == 3 { verticalStackView.distribution = .fill }
            verticalStackView.axis = .vertical
            
            for j in 0..<buttonsData.count {
                let title = buttonsData[j][i]
                let color = colors[j]
                
                if j == buttonsData.count - 1 && i == buttonsData[j].count - 1 {
                    break
                }
                
                let button: UIButton
                var multipler: CGFloat = 1
                if j == buttonsData.count - 2 && i == buttonsData[j].count - 1 {
                    let customRect = CGRect(origin: CGPoint.zero, size: CGSize(
                        width: width,
                        height: height * 2
                    ))
                    button = UIButton(frame: customRect)
                    button.backgroundColor = colors.last
                    
                    multipler = 2
                } else {
                    button = UIButton(frame: rect)
                    button.backgroundColor = color
                }
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = UIFont.montesrrat(ofSize: 32)
                button.titleLabel?.textColor = UIColor.white
                
                let constraint = NSLayoutConstraint(
                    item: button,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1,
                    constant: height * multipler
                )
                NSLayoutConstraint.activate([constraint])
                
                button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
                verticalStackView.addArrangedSubview(button)
            }
            
            horizontalStackView.addArrangedSubview(verticalStackView)
        }
        
        self.addSubview(horizontalStackView)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        if let text = sender.title(for: .normal) {
            if let number = Int(text), text != "00" {
                delegate?.onNumberSelect(self, number: number)
            } else {
                delegate?.onOperationSelect(self, with: text)
            }
        }
    }

    deinit {
        print("Deinit UINumberPad(_:\(self))")
    }
    
}


protocol UINumberPadDelegate: NSObjectProtocol {
    func onNumberSelect(_ numberPad: UINumberPad, number: Int)
    func onOperationSelect(_ numberPad: UINumberPad, with: String)
}


