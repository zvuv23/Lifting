//
//  ExerciseInfo.swift
//  Lifting
//
//  Created by Shani Levinkind on 27/10/2018.
//  Copyright © 2018 Shani. All rights reserved.
//

import Foundation

struct WgerJSON<T : Codable> : Codable {
    let results : [T]
    let next : String?
    
    private enum CodingKeys: String, CodingKey{
        case results
        case next
    }
}

struct ExerciseInfo: Codable {
    let name: String
    let category: Int
    let id: Int
    let muscles : [Int]
    let secondaryMuscles : [Int]
    let description : String
    let equipment : [Int]
    

    //In order to solve camel case problem, we can declare Coding Keys enum and tell to use snake case for Swift constant and camel case for JSON.
    private enum CodingKeys: String, CodingKey {
        case name
        case category
        case id
        case muscles
        case secondaryMuscles = "muscles_secondary"
        case description
        case equipment
    }
    
    func getCategoryName() -> String{
        return ExerciseBuilder.builder.getMuscleCategory(number: category).name
    }
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//        //try container.encode(muscle, forKey: .category)
//    }

//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decode(String.self, forKey: .name)
//        id = try container.decode(Int.self, forKey: .id)
//        category = try container.decode(Int.self, forKey: .category)
////        category = ExerciseBuilder.builder.getMuscleCategory(number: categoryID)
//        muscles = [NameIdCodable]()
//        secondaryMuscles = [NameIdCodable]()
//    }
}

struct NameIdCodable: Codable {
    let name: String
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case name
        case id
    }
}
