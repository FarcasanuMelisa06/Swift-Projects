//
//  BreedsListResponse.swift
//  StartDogAPI
//
//  Created by Melisa Farcasanu on 29.08.2022.
//

import Foundation

struct BreedsListResponse: Codable{
    let status: String
    let message: [String: [String]]
}
