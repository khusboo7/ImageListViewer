//
//  CountryDetail.swift
//  ImageListViewer
//
//  Created by khusboo on 27/10/18.
//  Copyright © 2018 Khusboo. All rights reserved.
//

import UIKit

struct CountryDetail : Codable{
    let title : String?
    let description : String?
    let imageHref :String?
}

struct Country : Codable{
    let title : String
    let rows : [CountryDetail]?
}
