//
//  NetworkManager.swift
//  NY Times
//
//  Created by Farhan on 17/01/2023.
//

import Foundation
import UIKit

class NetworkManager {
    
    static var shared = NetworkManager()
    private init () {}
    
    private var baseURL: String = Environment.current.baseURL()
    
    func fetchGenericData<T: Decodable>(endPoint: EndPoints, completion: @escaping (T?, _ error: String?) -> ()) {
        guard let url = URL(string: baseURL.appending(endPoint.rawValue)) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, responseError) in
            self.processResponse(data: data,
                                 response: response,
                                 responseError: responseError,
                                 completion: completion)
            }.resume()
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    private func processResponse<T: Decodable>(data: Data?,
                                               response: URLResponse?,
                                               responseError: Error?,
                                               completion: @escaping (T?, _ error: String?) -> ()) {
        
        guard responseError == nil else {
            DispatchQueue.main.async {
                completion(nil, NetworkResponse.failed.rawValue)
            }
            return
        }
        
        if let response = response as? HTTPURLResponse {
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = data else {
                    DispatchQueue.main.async {
                        completion(nil, NetworkResponse.noData.rawValue)
                    }
                    
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    //decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let parsedModel = try decoder.decode(T.self, from: responseData)
                    DispatchQueue.main.async {
                        completion(parsedModel, nil)
                    }
                } catch let DecodingError.dataCorrupted(context) {
                    DispatchQueue.main.async {
                        print(context.debugDescription)
                        completion(nil, NetworkResponse.somethingWrong.rawValue)
                    }
                    
                } catch let DecodingError.keyNotFound(key, context) {
                    DispatchQueue.main.async {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(nil, NetworkResponse.somethingWrong.rawValue)
                    }
                    
                } catch let DecodingError.valueNotFound(value, context) {
                    DispatchQueue.main.async {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(nil, NetworkResponse.somethingWrong.rawValue)
                    }
                    
                } catch let DecodingError.typeMismatch(type, context)  {
                    DispatchQueue.main.async {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(nil, NetworkResponse.somethingWrong.rawValue)
                    }
                    
                    
                } catch let jsonErr {
                    DispatchQueue.main.async {
                        print("Failed to serialize json:", jsonErr)
                        completion(nil, NetworkResponse.somethingWrong.rawValue)
                    }
                    
                }
                
            case .failure:
                DispatchQueue.main.async {
                    completion(nil, NetworkResponse.somethingWrong.rawValue)
                }
                
            }
        }
    }
    
}


enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case somethingWrong = "Something went wrong please try again."
    
}

enum Result<String>{
    case success
    case failure(String)
}
