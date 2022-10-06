//
//  JSONParameterEncoder.swift
//  Network
//
//  Created by Egehan KARAKOSE on 27.03.2022.
//

import Foundation

struct JSONParameterEncoder: ParameterEncoder {
    
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
        } catch {
            throw NetworkError.encodingFailed
        }
    }
    
}


