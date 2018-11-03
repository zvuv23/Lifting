//
//  ExerciseBuilder.swift
//  Lifting
//
//  Created by Shani Levinkind on 27/10/2018.
//  Copyright © 2018 Shani. All rights reserved.
//

import Foundation
import os.log

class ExerciseBuilder{
    
    static func getHttpWgerJSON<T: Codable>(url: URL, completion: ((HTTPCalls.Result<[T]>) -> Void)?){
        HTTPCalls.makeGetCall(url: url, decodableType: WgerJSON<T>.self, completionHandler: { (result) in
            switch result {
            case .success(let parsedWgerJson):
                if let nextUrlStr = parsedWgerJson.next{
                    if let nextUrl = URL(string: nextUrlStr){
                        self.getHttpWgerJSON(url: nextUrl, completion: completion)
                    }
                }
                completion?(.success(parsedWgerJson.results))
            case .failure(let error):
                fatalError("error: \(error.localizedDescription)")
            }
        })
    }
    
    static func getExercises(completion: ((HTTPCalls.Result<[ExerciseInfo]>) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "wger.de"
        urlComponents.path = "/api/v2/exercise/"
        //confirmed exercises
        let statusItem = URLQueryItem(name: "status", value: "2")
        //english = 2 , german = 1
        let languageItem = URLQueryItem(name: "language", value: "2")
        urlComponents.queryItems = [statusItem, languageItem]
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        getHttpWgerJSON(url: url, completion: completion)
    }
  
}
