//
//  UserSearchResult.swift
//  iMingle
//
//  Created by Justine Paul Sanchez Vitan on 16/10/2018.
//  Copyright © 2018 CGJ. All rights reserved.
//

import Foundation

class UserSearchResult{
    
    var name: String
    var location: String
    var sex: String
    var dateOfBirth: String
    var age: Int
    
    init(name: String, location: String, sex: String, dateOfBirth: String){
        self.name = name
        self.location = location
        self.sex = sex
        self.dateOfBirth = dateOfBirth
        age = 0
        age = getAge(dateOfBirth: dateOfBirth)
    }
    
    func getAge(dateOfBirth: String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let dateOfBirthInDate = dateFormatter.date(from: dateOfBirth) else{
            return -1
        }
        
        let date = Date()
        
        guard let yearDifference = Calendar.current.dateComponents([.year], from: dateOfBirthInDate, to: date).year else{
            return -1
        }
        return yearDifference
    }
}
