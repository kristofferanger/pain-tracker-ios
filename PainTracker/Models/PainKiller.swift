//
//  PainKiller.swift
//  PainTracker
//
//  Created by Kristoffer Anger on 2019-11-11.
//  Copyright © 2019 Kriang. All rights reserved.

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let painKillers = try? newJSONDecoder().decode(PainKillers.self, from: jsonData)

import Foundation

typealias PainKillers = [PainKiller]

// MARK: - PainKiller
struct PainKiller: Codable, Identifiable {

    let brand: String
    let summary: String
    let ean: Int
    let category: Category
    let activeSubstances: [String]
    let prescription: Bool
    let imageURL: String
    
    // use ean as id, since it's unique for the product
    var id: Int { return ean }

    enum CodingKeys: String, CodingKey {
        case brand
        case summary
        case ean
        case category
        case activeSubstances = "active_substances"
        case prescription
        case imageURL = "image_url"
    }
}

enum Category: String, Codable {
    case feberVark = "feber-vark"
}

