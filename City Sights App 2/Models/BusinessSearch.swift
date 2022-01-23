//
//  BusinessSearch.swift
//  City Sights App 2
//
//  Created by ANGEL RAMIREZ on 1/23/22.
//

import Foundation
struct BusinessSearch: Decodable {
    
    var businesses = [Business]()
    var total = 0
    var region = Region()
    
}
struct Region: Decodable {
    
    var center = Coordinate()
}
