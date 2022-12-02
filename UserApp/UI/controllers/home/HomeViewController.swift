//
//  HomeViewController.swift
//  UserApp
//
//  Created by Nithin Sasankan on 01/12/22.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var emailErrorlabel: UILabel!
    @IBOutlet var checkBox: CheckBoxButton!
    @IBOutlet var checkBoxLabel: UILabel!
    @IBOutlet var dropDownSelectionView: UIView!
    @IBOutlet var dropDownLabel: UILabel!
    @IBOutlet var dropDownImage: UIImageView!
    @IBOutlet var userTextView: UITextView!
    @IBOutlet var getUserButton: RegularButton!
    @IBOutlet var userFetchErrorLabel: UILabel!

    var dropdownView: DropdownView?
    let dropdownItems = CountryRepo.shared.getCountries()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildContentView()
    }
    
    // build the content view
    func buildContentView() {
        self.title = "Home"
//        self.view.backgroundColor = .systemGray6
        
        emailTextField.showEmailKeyboard()
        emailTextField.delegate = self
        emailErrorlabel.text = ""
        
        checkBox.isSelected = false
        checkBox.onTap = {
            self.endEditing()
            self.checkBox.isSelected = !self.checkBox.isSelected
            self.checkBoxLabel.text = "Checkbox \(self.checkBox.isSelected ? "enabled" : "disabled")"
        }
        
        dropDownSelectionView.roundCorners(corners: .allCorners, radius: 4)
        dropDownSelectionView.borderColor(color: .systemGray5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDropdown))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        dropDownSelectionView.addGestureRecognizer(tapGesture)
        dropDownSelectionView.isUserInteractionEnabled = true
        dropDownLabel.text = "Choose country"
        dropDownLabel.textColor = .lightGray
        
        userTextView.roundCorners(corners: .allCorners, radius: 4)
        userTextView.borderColor(color: .systemGray5)
        userTextView.delegate = self
        
        getUserButton.setTitle("Get Users", for: .normal)
        getUserButton.isEnabled = true
        getUserButton.roundCorners(corners: .allCorners, radius: 25)
        getUserButton.onTap = {
            self.getUserButton.showLoading()
            self.userFetchErrorLabel.text = ""
            self.endEditing()
            UserRepo.shared.fetchUserList(witDelegate: self)
        }
    }
    
    func endEditing() {
        self.view.endEditing(true)
    }
}

// FetchUserListDelegate functions
extension HomeViewController: FetchUserListDelegate {
    
    /// Called when the fetch user API succeeds
    func onFetchUserListSucceeded() {
        DispatchQueue.main.async {
            self.getUserButton.stopLoading()
            let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
            let userListVC = storyboard.instantiateViewController(withIdentifier: "UserListViewController") as! UserListViewController
            self.navigationController!.pushViewController(userListVC, animated: true)
        }
    }
    
    /// Called when the fetch user API fails
    /// - Parameter error: the error for failure
    func onFetchUserListFailed(error: String?) {
        DispatchQueue.main.async {
            self.getUserButton.stopLoading()
            self.userFetchErrorLabel.text = error
        }
    }
}

// UITextFieldDelegate functions
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text?.isValidEmail() ?? false) {
            emailErrorlabel.text = "Invalid email"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailErrorlabel.text = ""
    }
}

// UITextViewDelegate functions
extension HomeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return !text.hasSpecialCharacters()
    }
}
