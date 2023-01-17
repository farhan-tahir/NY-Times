//
//  Environment.swift
//  NY Times
//
//  Created by Farhan on 17/01/2023.
//

import Foundation

enum Environment {
    case development
    case staging
    case production
    
    static var current: Environment { return .development }

    func baseURL() -> String {
        switch self {
        case .development: return "http://api.nytimes.com/svc/"
        case .staging: return ""
        case .production: return ""
        }
    }
}
