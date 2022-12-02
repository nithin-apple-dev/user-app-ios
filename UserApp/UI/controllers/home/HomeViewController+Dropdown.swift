//
//  HomeViewController+Dropdown.swift
//  UserApp
//
//  Created by Nithin Sasankan on 01/12/22.
//

import Foundation
import UIKit

extension HomeViewController {
    
    @objc
    func showDropdown() {
        if dropdownView == nil {
            dropdownView = buildDropdown()
            self.view.addSubview(dropdownView!)
            dropdownView?.didSelectDropdownItem = { (item) -> Void in
                self.dropDownLabel.text = item
                self.dropDownLabel.textColor = .black
                self.hideDropdown()
            }
        }
        if dropdownView!.isVisible {
            hideDropdown()
            return
        }
        endEditing()
        dropdownView!.tableView.reloadData()
        dropdownView!.isVisible = true
        dropdownView!.transform = CGAffineTransform(translationX: 0, y: -20)
        dropdownView!.isHidden = false
        self.dropdownView!.alpha = 0
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5, options: [], animations: {
                self.dropDownImage.transform = CGAffineTransform(rotationAngle: .pi)
                self.dropdownView!.transform = CGAffineTransform(translationX: 0, y: 0)
                self.dropdownView!.alpha = 1
            }) { (_: Bool) in

            }
        }
    }

    func hideDropdown() {
        guard dropdownView != nil else {
            return
        }
        dropdownView!.isVisible = false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5, options: [], animations: {
                self.dropDownImage.transform = CGAffineTransform.identity
                self.dropdownView!.transform = CGAffineTransform(translationX: 0, y: -10)
                self.dropdownView!.alpha = 0
            }) { (_: Bool) in
                self.dropdownView!.isHidden = true
            }
        }
    }

    func buildDropdown() -> DropdownView {
        let newDropdownView = DropdownView(items: dropdownItems, frame: CGRect(x: 36, y: dropDownSelectionView.frame.origin.y + dropDownSelectionView.bounds.height + 4, width: self.view.bounds.width - (36*2), height: 40*4))
        return newDropdownView
    }
}
