//
//  ExerciseInfo.swift
//  Lifting
//
//  Created by Shani Levinkind on 27/10/2018.
//  Copyright © 2018 Shani. All rights reserved.
//

import Foundation

class ExerciseVars {
    
    //MARK: properties
    var categoriesMap : [Int: NameIdCodable]
    var musclesMap : [Int: NameIdCodable]
    var equipmentMap : [Int: NameIdCodable]
    
    static let instance = ExerciseVars()
    
    //MARK: public functions
    func getExercises(completion: ((HTTPCalls.Result<[ExerciseInfo]>) -> Void)?) {
        ExerciseBuilder.getExercises(completion: completion)
    }

    //MARK: private functions
    private init() {
        categoriesMap = [Int: NameIdCodable]()
        musclesMap = [Int: NameIdCodable]()
        equipmentMap = [Int: NameIdCodable]()
        
        ExerciseBuilder.getHttpWgerJSON(url: URL(string: "https://wger.de/api/v2/exercisecategory/")!,completion: getCategories)
        ExerciseBuilder.getHttpWgerJSON(url: URL(string: "https://wger.de/api/v2/equipment/")!, completion: getEquipment)
        ExerciseBuilder.getHttpWgerJSON(url: URL(string: "https://wger.de/api/v2/equipment/")!, completion: getEquipment)
        ExerciseBuilder.getHttpWgerJSON(url: URL(string: "https://wger.de/api/v2/muscle/")!, completion: getMuscles)
    }
    
    private func getNameIdMap (result: HTTPCalls.Result<[NameIdCodable]>) ->[Int: NameIdCodable]{
        switch result {
        case .success(let array):
            return array.reduce(into: [Int: NameIdCodable]()) {
                $0[$1.id] = $1
            }
        case .failure(let error):
            fatalError("error: \(error.localizedDescription)")
        }
    }

    private func getCategories (result: HTTPCalls.Result<[NameIdCodable]>) ->Void{
        categoriesMap = getNameIdMap(result: result);
    }
    
    private func getMuscles (result: HTTPCalls.Result<[NameIdCodable]>) ->Void{
        musclesMap = getNameIdMap(result: result);
    }
    
    private func getEquipment (result: HTTPCalls.Result<[NameIdCodable]>) ->Void{
        equipmentMap = getNameIdMap(result: result);
    }
}

//MARK: codable structs
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
    let category: NameIdCodable
    let id: Int
    let description : String
    var muscles : [NameIdCodable]
    var secondaryMuscles : [NameIdCodable]
    var equipment : [NameIdCodable]
    

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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)

        let categoryId = try container.decode(Int.self, forKey: .category)
        category = ExerciseVars.instance.categoriesMap[categoryId]!
        muscles = [NameIdCodable]()
        secondaryMuscles = [NameIdCodable]()
        equipment = [NameIdCodable]()

        let muscleIds = try container.decode([Int].self, forKey: .muscles)
        muscleIds.forEach { id in
            self.muscles.append(ExerciseVars.instance.musclesMap[id]!)
        }
        
        let secMuscleIds = try container.decode([Int].self, forKey: .secondaryMuscles)
        secMuscleIds.forEach { id in
            self.secondaryMuscles.append(ExerciseVars.instance.musclesMap[id]!)
        }
        
        let equipmentIds = try container.decode([Int].self, forKey: .equipment)
        equipmentIds.forEach { id in
            self.equipment.append(ExerciseVars.instance.equipmentMap[id]!)
        }
    }
}

struct NameIdCodable: Codable {
    let name: String
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case name
        case id
    }
}


