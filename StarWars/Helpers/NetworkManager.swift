//
//  NetworkManager.swift
//  StarWars
//
//  Created by Mubin Khan on 4/26/24.
//

import Foundation
//import Alamofire

class NetWorkManager : NSObject {
    static let shared = NetWorkManager()
    
//    let reachabilityManager = NetworkReachabilityManager()
    
    func isNetworkReachable() -> Bool {
        return true
//        return reachabilityManager?.isReachable ?? false
    }
    
    private override init() {}
}
