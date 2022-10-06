//
//  BaseEnpointType.swift
//  Network
//
//  Created by Egehan KARAKOSE on 27.03.2022.
//

import Foundation

open class BaseEndpointType: EndpointType {
    
    public var endpoint: Endpoint {
        return mEndpoint
    }
    
    public var mEndpoint: Endpoint!
    
    public init() {}
    
    public init(endpoint: Endpoint) {
        self.mEndpoint = endpoint
    }
    
    public func getBodyParametersWithRequest(_ request: Codable?) -> Parameters {
        guard let request = request else { return [:] }
        return request.getParameters()
    }
    
}

public extension Encodable {
    
    var utf8String: String? {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(self) else { return nil }
        let text = String(data: data, encoding: .utf8)
        return text
    }
    
    func getParameters() -> [String: Any] {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(AnyEncodable(self))
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? Parameters
            if let jsonValue = json {
                return jsonValue
            }
        } catch { }
        
        return [String: Any]()
        
    }
    
}

extension Encodable {
    
    fileprivate func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
    
}

struct AnyEncodable: Encodable {
    
    var value: Encodable
    
    init(_ value: Encodable) {
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try value.encode(to: &container)
    }
    
}

