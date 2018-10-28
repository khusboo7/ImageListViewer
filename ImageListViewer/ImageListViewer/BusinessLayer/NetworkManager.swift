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
    
    
    func processRequest(completion handler: @escaping ((Country?,URLResponse?,Error?) -> ())){
        guard let url = URL(string: requestURL) else {
            return
            
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            
            guard let dataResponse = data else {
                return }
            
            let responseStrInISOLatin = String(data: dataResponse, encoding: String.Encoding.isoLatin1)
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                return
            }
            do {
                let countryData = try JSONDecoder().decode(Country.self, from: modifiedDataInUTF8Format)
                handler(countryData,response,error)
                
                
            } catch {
                 handler(nil,response,error)
                print(error)
            }
            
            }.resume()
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
    
    
    
    
}
