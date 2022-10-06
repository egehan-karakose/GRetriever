//
//  BError.swift
//  Network
//
//  Created by Egehan KARAKOSE on 27.03.2022.
//

import Foundation

public enum BError: Error {
    case undefined
    case authentication
    case badRequest
    case notFound
    case internalError
    case noData
    case connection
    case unableToDecode
    case requestCannotBeBuilt
}

extension BError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .authentication:
            return "authentication error"
        case .badRequest:
            return "badRequest error"
        case .notFound:
            return "notFound error"
        case .internalError:
            return "internalError error"
        case .noData:
            return "noData"
        case .connection:
            return "connection error"
        case .unableToDecode:
            return "unableToDecode error"
        case .requestCannotBeBuilt:
            return "requestCannotBeBuilt error"
        default:
            return "Unknown error."
        }
    }
}
