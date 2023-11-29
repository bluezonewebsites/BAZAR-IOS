//
//  CustomLanguageManager.swift
//  NewBazar
//
//  Created by iOSayed on 28/11/2023.
//

import MOLH



open class CustomLanguageManager {
    
static let shared = CustomLanguageManager()
    
    func isArabic() -> Bool {
        if MOLHLanguage.isArabic() {
            return true
        }else {
            return false
        }
    }
    
}
