//
//  Follower.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/9/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Genome

struct Follower: MappableObject {
    
    let numberOfFollowers: Int
    
    init(map: Map) throws {
        numberOfFollowers = try map.extract("total")
    }
    
    func sequence(map: Map) throws {
        try numberOfFollowers ~> map["total"]
    }
}
