//
//  ButtonFactory.swift
//  UserApp
//
//  Created by Nithin Sasankan on 01/12/22.
//

import Foundation
import UIKit

typealias TapAction =  () -> Void

class ButtonFactory {
    static let shared = ButtonFactory()
    
    func accentButton(withTitle title: String) -> RegularButton {
        let button = RegularButton()
        button.backgroundColor = UIColor.systemIndigo
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.roundCorners(corners: .allCorners, radius: 25)
        button.isUserInteractionEnabled = true
        return button
    }
}

class CheckBoxButton: UIButton {
    var onTap: TapAction? {
        didSet {
            self.removeTarget(self, action: #selector(invokeButtonAction), for: .touchUpInside)
            self.addTarget(self, action: #selector(invokeButtonAction), for: .touchUpInside)
        }
    }
    
    convenience init(isSelected: Bool) {
        self.init()
        self.isSelected = isSelected
    }
    
    override open var isSelected: Bool {
        didSet {
            self.setImage(self.isSelected ? UIImage(named: "checkbox-enabled") : UIImage(named: "checkbox-disabled"), for: .normal)
        }
    }
    
    @objc func invokeButtonAction() {
        self.onTap?()
    }
}

class RegularButton: UIButton {
    var normalColor = UIColor.systemIndigo
    var disabledColor = UIColor.systemGray5
    var activityIndicator: UIActivityIndicatorView?
    var originalButtonText: String?
    var onTap: TapAction? {
        didSet {
            self.removeTarget(self, action: #selector(invokeButtonAction), for: .touchUpInside)
            self.addTarget(self, action: #selector(invokeButtonAction), for: .touchUpInside)
        }
    }

    convenience init(normalColor: UIColor) {
        self.init()
        self.normalColor = normalColor
    }

    override open var isEnabled: Bool {
        didSet {
            self.backgroundColor = self.isEnabled ? self.normalColor : self.disabledColor
        }
    }

    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        self.isEnabled = false
        self.activityIndicator = UIActivityIndicatorView()
        self.activityIndicator?.hidesWhenStopped = true
        self.activityIndicator?.color = UIColor.blue.withAlphaComponent(0.5)
        self.addSubview(self.activityIndicator!)
        self.activityIndicator!.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        self.activityIndicator!.startAnimating()
    }

    func stopLoading() {
        self.setTitle(originalButtonText, for: .normal)
        self.isEnabled = true
        self.backgroundColor = normalColor
        self.activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
    }

    @objc func invokeButtonAction() {
        self.onTap?()
    }
}
