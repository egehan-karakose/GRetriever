//
//  NetworkActivityManager.swift
//  Network
//
//  Created by Egehan KARAKOSE on 27.03.2022.
//

import Foundation
import UIKit

class NetworkActivityManager {
    
    static let shared = NetworkActivityManager()
    
    init() {}
    
    private var requestCount = 0
    
    func start() {
        requestCount += 1
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func stop() {
        if requestCount > 0 {
            requestCount -= 1
        }
        if requestCount == 0 {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
}
