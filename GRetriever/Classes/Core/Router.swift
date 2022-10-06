//
//  Router.swift
//  Network
//
//  Created by Egehan KARAKOSE on 27.03.2022.
//

import Foundation

// swiftlint:disable type_name
public typealias completionHandler<T> = (Result<T, BError>) -> Void
// swiftlint:enable type_name

public protocol NetworkRouter: AnyObject {
    associatedtype Endpoint: EndpointType
    func request<T: Codable>(_ route: Endpoint, completion: @escaping completionHandler<T>)
    func request(_ route: Endpoint)
    func cancel()
}

public class URLSessionManager {
    
    static var shared: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60.0
        sessionConfig.timeoutIntervalForResource = 60.0
        
        let session = URLSession(configuration: .default)
        return session
    }()
    
}

public class Router<Endpoint: EndpointType>: NetworkRouter {
    
    public init() { }
    
    private var task: URLSessionTask?
    
    public func request(_ route: Endpoint) {
        
        guard let request = try? route.buildRequest() else { return }
        Logger.log(request: request)
        
        NetworkActivityManager.shared.start()
        
        task = URLSessionManager.shared.dataTask(with: request, completionHandler: {  data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    NetworkActivityManager.shared.stop()
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = response.filterStatusCode()
                    switch result {
                    case .success:
                        guard data != nil else {
                            NetworkActivityManager.shared.stop()
                            return
                        }
                        Logger.log(response: response, bodyData: data)
                        NetworkActivityManager.shared.stop()
                    case .failure:
                        NetworkActivityManager.shared.stop()
                    }
                }
            }
        })
        
        task?.resume()
    }
    
    public func request<T: Codable>(_ route: Endpoint, completion: @escaping completionHandler<T>) {
        
        guard let request = try? route.buildRequest() else {
            completion(.failure(.requestCannotBeBuilt))
            return
        }
        
        Logger.log(request: request)
        
        NetworkActivityManager.shared.start()
        
        task = URLSessionManager.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.connection))
                    NetworkActivityManager.shared.stop()
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = response.filterStatusCode()
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(.failure(.noData))
                            NetworkActivityManager.shared.stop()
                            return
                        }
                        do {
                            Logger.log(response: response, bodyData: data)
                            let apiResponse = try JSONDecoder().decode(T.self, from: responseData)
                            completion(.success(apiResponse))
                            NetworkActivityManager.shared.stop()
                        } catch {
                            debugPrint(error)
                            completion(.failure(.unableToDecode))
                            NetworkActivityManager.shared.stop()
                        }
                    case .failure(let error):
                        completion(.failure(error))
                        NetworkActivityManager.shared.stop()
                    }
                }
            }
        })
        
        task?.resume()
    }
    
    public func cancel() {
        task?.cancel()
    }

}

private extension HTTPURLResponse {
    
    func filterStatusCode() -> Result<Codable?, BError> {
        if statusCode != 200 {
            Logger.log(response: self, bodyData: nil)
        }
        
        switch self.statusCode {
        case 200: return .success(nil)
        case 400: return .failure(.badRequest)
        case 401: return .failure(.authentication)
        case 404: return .failure(.notFound)
        case 500: return .failure(.internalError)
        default: return .failure(.undefined)
        }
    }
    
}
