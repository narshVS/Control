//
//  UILabel.swift
//  ControlApp
//
//  Created by Влад Овсюк on 30.10.2020.
//

import UIKit

extension UILabel {
    func strikeThrough(_ squareButtonIsEnable:Bool) {
        if squareButtonIsEnable {
            if let labelText = self.text {
                let attributeString =  NSMutableAttributedString(string: labelText)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.thick.rawValue, range: NSMakeRange(0,attributeString.length))
                self.attributedText = attributeString
            }
        } else {
            if let labelText = self.text {
                let attributeString =  NSMutableAttributedString(string: labelText)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0,attributeString.length))
                self.attributedText = attributeString
            }
        }
    }
}
