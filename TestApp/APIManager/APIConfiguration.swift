//
//  APIConfiguration.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 14.10.2022.
//

import Foundation

struct APIConfiguration {
    let mainURL: URL = URL(string: "https://api.unsplash.com/")!
    let clientID = "eIemwH6Pcoxa-yortjFO5fxsKaLdqVYqycPCfwxNNmw"
    
    static var shared = APIConfiguration()
    private init() {}
}
