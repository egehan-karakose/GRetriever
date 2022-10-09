//
//  EndpointType.swift
//  Network
//
//  Created by Egehan KARAKOSE on 27.03.2022.
//
import Foundation
import UIKit

public typealias Parameters = [String: Any]

public struct Query {
    let key: String
    let value: String
    
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}

public class Endpoint {
    var baseURL: URL
    var path: String
    var parameters: Parameters
    var httpMethod: HTTPMethod
    var httpTask: HTTPTask
    var httpHeaders: HTTPHeaders
    var queries: [Query]
    
    public init(baseURL: URL,
                path: String,
                parameters: Parameters = [:],
                httpMethod: HTTPMethod,
                httpTask: HTTPTask,
                httpHeaders: HTTPHeaders = .json(),
                queries: [Query] = []) {
        self.baseURL = baseURL
        self.path = path
        self.parameters = parameters
        self.httpMethod = httpMethod
        self.httpTask = httpTask
        self.httpHeaders = httpHeaders
        self.queries = queries
    }
}

public protocol Retrieve {
    func retrieve<T: Codable>(_ success: @escaping (T?) -> Void, failure: ((Error?) -> Void)?)
}

public protocol EndpointType: Retrieve {
    var baseURL: URL { get }
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
        return Endpoint(baseURL: baseURL, path: path, parameters: parameters, httpMethod: httpMethod, httpTask: httpTask, httpHeaders: httpHeaders, queries: queries)
    }
    
    var baseURL: URL {
        return URL(string: "")!
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
    
    var queries: [Query] {
        return []
    }
    
    var httpHeaders: HTTPHeaders {
        return .json()
    }
    
    func buildRequest() throws -> URLRequest {
        var url = URLComponents(url: endpoint.baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false)
        if !endpoint.queries.isEmpty {
            url?.queryItems = endpoint.queries.compactMap({ item in
                return URLQueryItem(name: item.key, value: item.value)
            })
        }
        
        var request = URLRequest(url: (url?.url) ?? endpoint.baseURL.appendingPathComponent(endpoint.path),
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

