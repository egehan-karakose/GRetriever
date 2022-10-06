//
//  EndpointType.swift
//  Network
//
//  Created by Egehan KARAKOSE on 27.03.2022.
//
import Foundation
import UIKit

public typealias Parameters = [String: Any]

public class Endpoint {
    var path: String
    var parameters: Parameters
    var httpMethod: HTTPMethod
    var httpTask: HTTPTask
    var httpHeaders: HTTPHeaders
    
    public init(path: String,
                parameters: Parameters = [:],
                httpMethod: HTTPMethod,
                httpTask: HTTPTask,
                httpHeaders: HTTPHeaders = .json()) {
        self.path = path
        self.parameters = parameters
        self.httpMethod = httpMethod
        self.httpTask = httpTask
        self.httpHeaders = httpHeaders
    }
}

public protocol Retrieve {
    func retrieve<T: Codable>(_ success: @escaping (T?) -> Void, failure: ((Error?) -> Void)?)
}

public protocol EndpointType: Retrieve {
    var path: String { get }
    var parameters: Parameters { get }
    var httpMethod: HTTPMethod { get }
    var httpTask: HTTPTask { get }
    var httpHeaders: HTTPHeaders { get }
    var endpoint: Endpoint { get }
    func requestCompleted()
}

public extension EndpointType {
    
    func requestCompleted() {}
    
    var endpoint: Endpoint {
        return Endpoint(path: path, parameters: parameters, httpMethod: httpMethod, httpTask: httpTask, httpHeaders: httpHeaders)
    }
    
    var path: String {
        return ""
    }
    
    var parameters: Parameters {
        return [:]
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var httpTask: HTTPTask {
        return .request
    }
    
    // Default HTTPHeader value is json. If you wanna change,
    // please add "var httpHeaders: HTTPHeaders" to your enum which was implemented EndpointType
    var httpHeaders: HTTPHeaders {
        return .json()
    }
    
    func buildRequest() throws -> URLRequest? {
        guard let url = URL(string: endpoint.path) else { return nil }
        
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60.0)
        
        request.allHTTPHeaderFields = endpoint.httpHeaders.value
        request.httpMethod = endpoint.httpMethod.rawValue
        
        do {
            switch endpoint.httpTask {
            case .request: break
            case .requestParameters(let parameters,
                                    let encoding):
                
                try configureParameters(parameters: parameters,
                                        encoding: encoding,
                                        request: &request)
            }
            return request
        } catch {
            throw error
        }
        
    }
    
    private func configureParameters(parameters: Parameters?, encoding: ParameterEncoding, request: inout URLRequest) throws {
        try encoding.encode(urlRequest: &request, parameters: parameters)
    }
    
    // MARK: - Base Request Trigger!!
    
    func retreiveWithoutCallback() {
        let router = Router<Self>()
        router.request(self)
    }
    
    func retrieve<T: Codable>(_ success: @escaping (T?) -> Void, failure: ((Error?) -> Void)? = nil) {
        let router = Router<Self>()

        router.request(self) { (response: Result<T, BError>) in
            self.requestCompleted()
            
            switch response {
            case .success(let successModel):
                success(successModel)
            case .failure(let error):
                failure?(error)
            }
        }
    }

    
}

