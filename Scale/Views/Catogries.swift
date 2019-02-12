//
//  Catogries.swift
//  Scale
//
//  Created by ramez adnan on 11/02/2019.
//  Copyright © 2019 ibrahim M. samak. All rights reserved.
//

import Foundation

struct Catogries: Codable {
    let status: Bool?
    let code: Int?
    let message: String?
    let categories: [itemdata]?
}

struct itemdata: Codable {
    let id: Int?
    let logo: String?
    let orderBy: String?
    let maxSelected: String?
    let allMeals: [AllMeal]?
    let countMeal: Int?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case id, logo
        case orderBy = "order_by"
        case maxSelected, allMeals
        case countMeal = "count_meal"
        case title
    }
}

struct AllMeal: Codable {
    let id: Int?
    let categoryID: String?
    let logo: String?
    let orderBy: String?
    let selected: Int?
    let type: TypeEnum?
    let name, description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case logo
        case orderBy = "order_by"
        case selected, type, name, description
    }
}

enum TypeEnum: String, Codable {
    case meal = "Meal"
}
