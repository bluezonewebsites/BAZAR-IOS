//
//  AppSettings.swift
//  NewBazar
//
//  Created by iOSayed on 21/12/2023.
//

import Foundation

class AppSettings {
    static let shared = AppSettings()
    var currentCountry: Country 

    private init() {
        currentCountry = Country()
    } 
}
