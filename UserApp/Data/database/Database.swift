//
//  Database.swift
//  UserApp
//
//  Created by Nithin Sasankan on 01/12/22.
//

import Foundation
import UIKit
import CoreData

class DBTableNames {
    static let user = "User"
}

class Database {
    static let shared = Database()
    
    /// To save user list
    /// - Parameters:
    ///   - array: Array of users
    ///   - onFinished: Completion hamdler called when the save operation is finished
    func saveUserList(_ array: [[String: AnyObject]], onFinished: @escaping(_ finished: Bool) -> Void) {
        // using child-parent context to save user list concurrently
        let mainContext = getMainObjectContext()
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = mainContext

        privateContext.perform {
            for userDict in array {
                let user = User(context: privateContext)
                user.id = userDict["id"] as? Int32 ?? 0
                user.userId = userDict["userId"] as? Int32 ?? 0
                user.title = userDict["title"] as? String ?? "missing title"
                user.body = userDict["body"] as? String ?? "missing body"
            }
            do {
                // saving child context
                try privateContext.save()
                mainContext?.performAndWait {
                    do {
                        // saving main context
                        try mainContext?.save()
                        onFinished(true)
                    } catch {
                        onFinished(false)
                    }
                }
            } catch {
                onFinished(false)
            }
        }
    }
    
    /// To fetch the user list from coredata
    /// - Parameters:
    ///   - onSuccess: Completion block called once user fetch is completed
    ///   - onError: Optional completion block called then user fetch fails
    func fetchUserList(onSuccess: (_ users: [User]) -> Void,
                       onError: ((_ errorText: String) -> Void)? = nil
    ) {
        let mainContext = getMainObjectContext()
        let userFetchRequest = NSFetchRequest<User>(entityName: DBTableNames.user)
        userFetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let fetchResult = try mainContext?.fetch(userFetchRequest)
            onSuccess(fetchResult!)
        } catch {
            if let onError = onError {
                onError(error.localizedDescription)
            }
        }
    }
    
    /// To clear user data
    /// - Returns: Returns true/false based on the result of user data deletion
    func clearData() -> Bool {
        do {
            let mainContext = getMainObjectContext()
            let userFetchRequest = NSFetchRequest<User>(entityName: DBTableNames.user)
            do {
                let objects  = try mainContext?.fetch(userFetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{mainContext?.delete($0)}}
                try mainContext?.save()
                return true
            } catch let error {
                print("Error in deleting user: \(error)")
                return false
            }
        }
    }
    
    /// To get the managed object context
    /// - Returns: Returns the main managed object context
    private func getMainObjectContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
}
