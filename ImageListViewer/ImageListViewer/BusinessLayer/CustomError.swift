//
//  CustomError.swift
//  ImageListViewer
//
//  Created by khusboo on 29/10/18.
//  Copyright © 2018 Khusboo. All rights reserved.
//

import Foundation

struct CustomError : LocalizedError {
    var title : String
    var code : Int
    var description : String
    
    init(with code : Int, title : String, desc : String ) {
        self.title = title
        self.code = code
        self.description = desc
    }
    
    var localizedDescription: String {
        return description
    }
}
