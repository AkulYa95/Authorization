//
//  NetworkManager.swift
//  Authorization
//
//  Created by Ярослав Акулов on 12.09.2022.
//

import Foundation
import KeychainSwift

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    
//    private var accessToken: String? {
//        return UserDefaults.standard.string(forKey: "accessToken")
//    }
    
    private let accessToken = KeychainSwift()
    private let tokenKey = "accessToken"
    
    func signInWith(username: String, password: String, completion: @escaping ((SessionDataTaskError?) -> Void)) {
        guard let url = URL(string: "https://smart.eltex-co.ru:8273/api/v1/oauth/token"),
              let authData = "ios-client:password".data(using: .utf8)?.base64EncodedString()
        else {
            completion(.invalidURL)
            return
        }
        let parameters = "grant_type=password&username=\(username)&password=\(password)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        request.setValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failErr(error))
                    return
                }
                if let response = response as? HTTPURLResponse {
                    guard 200 ..< 300 ~= response.statusCode else {
                        completion(.responseStatusCodeErr(response.statusCode))
                        return
                    }
                }
                guard let data = data else {
                    completion(.dataIsNil)
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let dict = json as? [String: Any],
                          let token = dict["access_token"] as? String else {
                              completion(.noToken)
                        return
                    }
                    self.accessToken.set(token, forKey: self.tokenKey)
                    completion(nil)
                } catch {
                    completion(.jsonError(error))
                }
            }
        }.resume()
    }
    
    func getUserInfo(completion: @escaping ((UserInfo?, SessionDataTaskError?) -> Void)) {
        guard let url = URL(string: "https://smart.eltex-co.ru:8273/api/v1/user") else {
            completion(nil, .invalidURL)
            return
        }
        guard let accessToken = accessToken.get(tokenKey) else {
            completion(nil, .noToken)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, .failErr(error))
                    return
                }
                if let response = response as? HTTPURLResponse {
                    guard 200 ..< 300 ~= response.statusCode else {
                        self.accessToken.delete(self.tokenKey)
                        completion(nil, .responseStatusCodeErr(response.statusCode))
                        return
                    }
                }
                guard let data = data else {
                    completion(nil, .dataIsNil)
                    return
                }
                do {
                    let info = try JSONDecoder().decode(UserInfo.self, from: data)
                    completion(info, nil)
                } catch {
                    completion(nil, .jsonError(error))
                }
            }
        }.resume()
    }
}

extension NetworkManager: URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let trust = challenge.protectionSpace.serverTrust else { return }
        let urlCredential = URLCredential(trust: trust)
        completionHandler(.useCredential, urlCredential)
    }
}
