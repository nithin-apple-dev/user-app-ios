//
//  CountryRepo.swift
//  UserApp
//
//  Created by Nithin Sasankan on 02/12/22.
//

import Foundation

class CountryRepo {
    static var shared = CountryRepo()

    func getCountries() -> [String] {
        return ["Russia", "Germany", "United Kingdom", "France", "Italy", "Spain", "Ukraine", "Poland", "Romania", "Netherlands", "Belgium", "Greece"]
    }
}
