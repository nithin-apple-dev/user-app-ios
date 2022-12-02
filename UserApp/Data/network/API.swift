//
//  API.swift
//  UserApp
//
//  Created by Nithin Sasankan on 01/12/22.
//

import Foundation

enum ApiEndpoint: String {
    case userList = "https://jsonplaceholder.typicode.com/posts"
}

struct APIError {
    var error: Error?
    var rawResponse: String?

    init(error: Error?) {
        self.error = error
    }

    init(rawResponse: String?) {
        self.rawResponse = rawResponse
    }
}

class API {
    private var session = URLSession.shared
    static var shared = API()

    func fetchUserList(onSuccess: ((_ userList: [[String: AnyObject]]) -> Void)?,
                       onError: ((_ error: APIError) -> Void)?) {
        executeGetRequest(endpoint: .userList,
                          onSuccess: onSuccess,
                          onError: onError)
    }

    private func executeGetRequest (
        endpoint: ApiEndpoint,
        onSuccess: ((_ record: [[String: AnyObject]]) -> Void)?,
        onError: ((_ error: APIError) -> Void)?
    ) {
        if let url = URL(string: endpoint.rawValue) {
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error, let onError = onError {
                    onError(APIError(error: error))
                }
                if let data = data {
                    do {
                        if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: AnyObject]], let onSuccess = onSuccess {
                            onSuccess(jsonData)
                        }
                    }
                    catch let error as NSError {
                        if let onError = onError {
                            onError(APIError(error: error))
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
