//
//  UITextField+ReplaceText.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/10/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import UIKit

extension UITextView {
    func setTextWithExistingAttributes(text: String) {
        guard let attributedText = self.attributedText else { return }
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        attributedString.replaceCharactersInRange(NSRange(location: 0, length: attributedText.length), withString: text)
        self.attributedText = attributedString
    }
}
