//
//  NSAttributedStringExtension.swift
//  ADTCodeChallenge
//
//  Created by Jamie McDaniel on 9/8/20.
//  Copyright © 2020 Jamie McDaniel. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    
    convenience init(string: String, font: UIFont, color: UIColor) {
        self.init(string: string, font: font, color: color, textAlignment: .left, underline: false, underlineColor: .black)
    }
    
    convenience init(string: String, font: UIFont, color: UIColor, textAlignment: NSTextAlignment = .left, underline: Bool = false, underlineColor: UIColor = .black) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        let underlineStyle: NSUnderlineStyle = underline ? .thick : []
        let attributes: [NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
            .underlineStyle: underlineStyle.rawValue,
            .underlineColor: underlineColor ]
        
        self.init(string: string, attributes: attributes)
    }
    
    
    convenience init(string: String, font: UIFont, color: UIColor, substrings: [String], substringFont: UIFont, substringColor: UIColor) {
        guard var pattern = substrings.first else {
            self.init(string: string, font: font, color: color)
            return
        }
        
        for index in 1..<substrings.endIndex {
            pattern.append("|\(substrings[index])")
        }
        let regularExpression = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regularExpression.matches(in: string, options: [], range: NSMakeRange(0, string.count))
        if matches.count == 0 {
            self.init(string: string, font: font, color: color)
            return
        }
        
        let attributedString = NSMutableAttributedString()
        for index in matches.startIndex..<matches.endIndex {
            var previousMatchEndIndex = string.startIndex
            if index != matches.startIndex {
                let previousIndex = matches.index(before: index)
                let previousMatch = matches[previousIndex]
                previousMatchEndIndex = string.index(string.startIndex, offsetBy: previousMatch.range.location + previousMatch.range.length)
            }
            let match = matches[index]
            let matchStartIndex = string.index(string.startIndex, offsetBy: match.range.location)
            let matchEndIndex = string.index(matchStartIndex, offsetBy: match.range.length)
            
            // Add the text up to the match
            attributedString.append(NSAttributedString(string: String(string[previousMatchEndIndex..<matchStartIndex]), font: font, color: color))
            
            // Add the matched substring
            attributedString.append(NSAttributedString(string: String(string[matchStartIndex..<matchEndIndex]), font: substringFont, color: substringColor))
        }
        
        // Add the text after the final match
        if let match = matches.last {
            let matchStartIndex = string.index(string.startIndex, offsetBy: match.range.location)
            let matchEndIndex = string.index(matchStartIndex, offsetBy: match.range.length)
            let substring = String(string[matchEndIndex...])
            attributedString.append(NSAttributedString(string: substring, font: font, color: color))
        }
        
        self.init(attributedString: attributedString)
    }
    
}

