//
//  MarsData.swift
//  NASAapi
//
//  Created by Tiffany Sakaguchi on 5/5/21.
//

import Foundation

struct MarsTopLevelObject: Codable {
    let photos: [MarsSecondLevelObject]
}

struct MarsSecondLevelObject: Codable {
    let img_src: String
    let earth_date: String
    let rover: RoverNextLevel
}

struct RoverNextLevel: Codable {
    let name: String
}
