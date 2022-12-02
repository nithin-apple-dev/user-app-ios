//
//  Extensions.swift
//  UserApp
//
//  Created by Nithin Sasankan on 01/12/22.
//

import Foundation
import UIKit

extension UITextField {
    
    /// To show email keyboard 
    func showEmailKeyboard() {
        self.keyboardAppearance = .default
        self.autocorrectionType = .yes
        self.enablesReturnKeyAutomatically = false
        self.returnKeyType = .done
        self.keyboardType = .emailAddress
        self.textContentType = .emailAddress
    }
}

extension String {
    
    /// To check whether string is a email
    /// - Returns: Returns true/false
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    
    /// To find whether string contains Special characters
    /// - Returns: Returns true/false
    func hasSpecialCharacters() -> Bool {
        let specialCharactersSet = CharacterSet(charactersIn: "!@#$%^&*()_+{}[]|\"<>,~`/:;?-=\\¥'£•¢")
        let inverted = specialCharactersSet.inverted
        let filtered = self.components(separatedBy: inverted).joined(separator: "")
        return filtered.count > 0
    }
}

extension UIView {
    
    /// To set corner radious of a view
    /// - Parameters:
    ///   - corners: Array of corners to be rounded
    ///   - radius: The value of radius needed
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        var masked = CACornerMask()
        if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
        if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
        if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
        if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
        self.layer.maskedCorners = masked
    }
    
    /// To set border of a view
    /// - Parameter color: The color of border
    func borderColor(color: UIColor) {
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
    }
}

