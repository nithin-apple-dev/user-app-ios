//
//  UserRepo.swift
//  UserApp
//
//  Created by Nithin Sasankan on 01/12/22.
//

import Foundation

/// Fetch user protocal
@objc protocol FetchUserListDelegate {
    @objc optional func onFetchUserListSucceeded()
    @objc optional func onFetchUserListFailed(error: String?)
}

class UserRepo {
    static var shared = UserRepo()
    private var api = API.shared
    
    // Fetch the user list using a network call
    func fetchUserList(witDelegate delegate: FetchUserListDelegate?) {
        api.fetchUserList { userList in
            DispatchQueue.main.async {
                // clearing data before saving fetched data to coredata
                if Database.shared.clearData() {
                    Database.shared.saveUserList(userList) { finished in
                        if finished {
                            // Inform fetching user succeeded
                            delegate?.onFetchUserListSucceeded?()
                        } else {
                            // Inform fetching user failed
                            delegate?.onFetchUserListFailed?(error: "Unknown error")
                        }
                    }
                }
            }
        } onError: { error in
            delegate?.onFetchUserListFailed?(error: error.error?.localizedDescription ?? "Unknown error")
        }
    }
    
    // Get the user list from core data
    func getAllUsers(onSuccess: (_ users: [User]) -> Void,
                     onFailure: ((_ errorText: String) -> Void)? = nil
    ) {
        Database.shared.fetchUserList(onSuccess: onSuccess, onError: onFailure)
    }
}
