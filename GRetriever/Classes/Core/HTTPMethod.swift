//
//  HTTPMethod.swift
//  Network
//
//  Created by Egehan KARAKOSE on 27.03.2022.
//

import Foundation

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

public enum HTTPTask {

    case request
    case requestParameters(parameters: Parameters? = [:], encoding: ParameterEncoding)
    
}

public struct HeaderModel {
    let key: String
    let value: String
    
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}

public enum HTTPHeaders {
    
    case empty
    case json([HeaderModel]? = nil)

    var value: [String: String] {
        switch self {
        case .empty:
            return [:]
        case .json(let headerElements):
            var header = HeaderBuilder.build()
            for headerElement in headerElements ?? [] {
                header[headerElement.key] = headerElement.value
            }
            return header
            
        }
    }
}

public class HeaderBuilder {
    
    struct Platform {
        
        static private let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
            isSim = true
            #endif
            return isSim
        }()
        
        static func isSimulatorText() -> String {
            return Platform.isSimulator ? "true" : "false"
        }
    
    }
    
    // swiftlint:disable force_cast
    public class func build() -> [String: String] {
        let header = [String: String]()
        return header
    }
    // swiftlint:enable force_cast
    
    public var launchedTimestampValue: Int = 0
}
