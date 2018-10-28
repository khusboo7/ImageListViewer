//
//  NetworkManager.swift
//  ImageListViewer
//
//  Created by Khusboo on 28/10/18.
//  Copyright © 2018 Khusboo. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager{
    
    class func shared() -> NetworkManager {
        return sharedManager
    }
    
    static var sharedManager : NetworkManager = {
        let manager = NetworkManager()
        return manager
    }()
    
    private init() {
        
    }
    
    let requestURL : String = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    
    
    func processRequest(completion handler: @escaping ((Country?,URLResponse?,CustomError?) -> ())){
        
        if isInternetAvailable(){
        guard let url = URL(string: requestURL) else {
            let customError = CustomError(with: -1, title: "Error", desc: "Invalid URL")
            handler(nil,nil,customError)
            return
            
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data else {
                handler(nil,nil,error as? CustomError)
                return
                
            }
            
            let responseStrInISOLatin = String(data: dataResponse, encoding: String.Encoding.isoLatin1)
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                let customError = CustomError(with: -1, title: "Error", desc: "Improper data format")
                handler(nil,nil,customError)
                return
            }
            do {
                let countryData = try JSONDecoder().decode(Country.self, from: modifiedDataInUTF8Format)
                handler(countryData,response,error as? CustomError)
                
                
            } catch {
                handler(nil,response,error as? CustomError)
                print(error)
            }
            
            }.resume()
        }
        else{
            let customError = CustomError(with: -1, title: "Error", desc: "The internet connection appears to be offline")
            handler(nil,nil,customError)
        }
    }
    
    func downloadImage(with imageUrl : String, onCompletion handler : @escaping ((Data?)->(Void))) {
        
        
            if let url = URL(string: imageUrl) {
                Alamofire.request(url).response(completionHandler: {
                    response in
                    if response.response?.statusCode == 200 {
                            let responseData = response.data
                           handler(responseData)
                    }
                    else{
                        handler(nil)
                    }
                    
                })
            }
        
        
    }
    
    private func isInternetAvailable() -> Bool {
        guard let nwReachabilityMgr = NetworkReachabilityManager() else {
            return false
        }
        return nwReachabilityMgr.isReachable
    }
    
    
    
    
}
