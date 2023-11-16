//
//  User.swift
//  Bazar
//
//  Created by Amal Elgalant on 29/04/2023.
//


import Foundation


struct UserArrayPaging: Codable{
    var data: UserArray!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}

struct UserArray: Codable{
    var data: [User]!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}
struct UserLoginObject: Codable{
    var data: User!
    var code: Int!
    var msg: String!
    var token: String!
    var success:Bool!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
        case token = "accessToken"
        case success = "success"
    }
    
    
}
struct UserTokenObject: Codable{
    var data: UserObject!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    init() {
    }
    
}


struct UserObject: Codable{
    var data: User!
   
    var token: String!
   
    
    enum CodingKeys: String, CodingKey {
        case data = "user"
        case token = "token"
    }
    
    init(){}
}



//struct User: Codable {
//    var id: Int?
//    var name, lastName, username, pass: String?
//    var loginMethod, uid, bio, phone: String?
//    var email: String?
//    var countryId, cityId, regionId: Int?
//    var pic: String?
//    var cover, regid: String?
//    var  verified, blocked: Int?
//    var typeMob:String?
//    var notification, deactivate: Int?
//    var note, passV: String?
//    var isAdvertiser: Int?
//    var countriesNameAr, countriesNameEn, citiesNameAr, citiesNameEn: String?
//    var regionsNameAr, regionsNameEn: String?
//    var numberOfProds, following, followers, userRate: Int?
//    var searchIsFollow, isFollow, activeNotification: Int?
//    var toke: String?
//    var codeVerify:Int?
//    var isStore: Bool?
//    var store: Store?
//    var availableAdsCountUserInCurrentMonth, availableAdsCountStoreInCurrentMonth: Int?
//    var plan: Plan?
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case lastName = "last_name"
//        case username, pass
//        case loginMethod = "login_method"
//        case uid, bio, email
//        case  phone = "mobile"
//        case countryId = "country_id"
//        case cityId = "city_id"
//        case regionId = "region_id"
//        case pic, cover, regid
//        case typeMob = "type_mob"
//        case verified, blocked
//        case codeVerify = "code_verify"
//        case notification, deactivate, note
//        case passV = "pass_v"
//        case isAdvertiser = "is_advertiser"
//        case countriesNameAr = "countries_name_ar"
//        case countriesNameEn = "countries_name_en"
//        case citiesNameAr = "cities_name_ar"
//        case citiesNameEn = "cities_name_en"
//        case regionsNameAr = "regions_name_ar"
//        case regionsNameEn = "regions_name_en"
//        case numberOfProds
//        case following = "Following"
//        case followers = "Followers"
//        case userRate = "UserRate"
//        case searchIsFollow = "follow"
//        case isFollow = "is_follow"
//        case activeNotification = "active_notification"
//        case isStore = "is_store"
//        case store
//        case availableAdsCountUserInCurrentMonth = "available_ads_count_user_in_current_month"
//        case availableAdsCountStoreInCurrentMonth = "available_ads_count_store_in_current_month"
//        case plan
//    }
//}
struct User: Codable {
    var id: Int?
    var name, lastName, username, pass: String?
    var loginMethod, uid, bio, phone: String?
    var email: String?
    var countryId, cityId, regionId: Int?
    var pic: String?
    var cover, regid: String?
    var verified, blocked: Int?
    var typeMob: String?
    var notification, deactivate: Int?
    var note, passV: String?
    var isAdvertiser: Int?
    var countriesNameAr, countriesNameEn, citiesNameAr, citiesNameEn: String?
    var regionsNameAr, regionsNameEn: String?
    var numberOfProds, following, followers, userRate: Int?
    var searchIsFollow, isFollow, activeNotification: Int?
    var toke: String?
    var codeVerify: Int?
    var isStore: Bool?
    var store: Store?
    var availableAdsCountUserInCurrentMonth, availableAdsCountStoreInCurrentMonth: Int?
    var plan: Plan?
    
    enum CodingKeys: String, CodingKey {
            case id, name
            case lastName = "last_name"
            case username, pass
            case loginMethod = "login_method"
            case uid, bio, email
            case  phone = "mobile"
            case countryId = "country_id"
            case cityId = "city_id"
            case regionId = "region_id"
            case pic, cover, regid
            case typeMob = "type_mob"
            case verified, blocked
            case codeVerify = "code_verify"
            case notification, deactivate, note
            case passV = "pass_v"
            case isAdvertiser = "is_advertiser"
            case countriesNameAr = "countries_name_ar"
            case countriesNameEn = "countries_name_en"
            case citiesNameAr = "cities_name_ar"
            case citiesNameEn = "cities_name_en"
            case regionsNameAr = "regions_name_ar"
            case regionsNameEn = "regions_name_en"
            case numberOfProds
            case following = "Following"
            case followers = "Followers"
            case userRate = "UserRate"
            case searchIsFollow = "follow"
            case isFollow = "is_follow"
            case activeNotification = "active_notification"
            case isStore = "is_store"
            case store
            case availableAdsCountUserInCurrentMonth = "available_ads_count_user_in_current_month"
            case availableAdsCountStoreInCurrentMonth = "available_ads_count_store_in_current_month"
            case plan
            case toke = "token"
        }
    init(){}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        pass = try container.decodeIfPresent(String.self, forKey: .pass)
        loginMethod = try container.decodeIfPresent(String.self, forKey: .loginMethod)
        uid = try container.decodeIfPresent(String.self, forKey: .uid)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        countryId = try container.decodeCountryID(forKey: .countryId)
        cityId = try container.decodeCountryID(forKey: .cityId)
        regionId = try container.decodeCountryID(forKey: .regionId)
        pic = try container.decodeIfPresent(String.self, forKey: .pic)
        cover = try container.decodeIfPresent(String.self, forKey: .cover)
        regid = try container.decodeIfPresent(String.self, forKey: .regid)
        verified = try container.decodeIfPresent(Int.self, forKey: .verified)
        blocked = try container.decodeIfPresent(Int.self, forKey: .blocked)
        typeMob = try container.decodeIfPresent(String.self, forKey: .typeMob)
        notification = try container.decodeIfPresent(Int.self, forKey: .notification)
        deactivate = try container.decodeIfPresent(Int.self, forKey: .deactivate)
        note = try container.decodeIfPresent(String.self, forKey: .note)
        passV = try container.decodeIfPresent(String.self, forKey: .passV)
        isAdvertiser = try container.decodeIfPresent(Int.self, forKey: .isAdvertiser)
        countriesNameAr = try container.decodeIfPresent(String.self, forKey: .countriesNameAr)
        countriesNameEn = try container.decodeIfPresent(String.self, forKey: .countriesNameEn)
        citiesNameAr = try container.decodeIfPresent(String.self, forKey: .citiesNameAr)
        citiesNameEn = try container.decodeIfPresent(String.self, forKey: .citiesNameEn)
        regionsNameAr = try container.decodeIfPresent(String.self, forKey: .regionsNameAr)
        regionsNameEn = try container.decodeIfPresent(String.self, forKey: .regionsNameEn)
        numberOfProds = try container.decodeIfPresent(Int.self, forKey: .numberOfProds)
        following = try container.decodeIfPresent(Int.self, forKey: .following)
        followers = try container.decodeIfPresent(Int.self, forKey: .followers)
        userRate = try container.decodeIfPresent(Int.self, forKey: .userRate)
        searchIsFollow = try container.decodeIfPresent(Int.self, forKey: .searchIsFollow)
        isFollow = try container.decodeIfPresent(Int.self, forKey: .isFollow)
        activeNotification = try container.decodeIfPresent(Int.self, forKey: .activeNotification)
        toke = try container.decodeIfPresent(String.self, forKey: .toke)
        codeVerify = try container.decodeIfPresent(Int.self, forKey: .codeVerify)
        isStore = try container.decodeIfPresent(Bool.self, forKey: .isStore)
        store = try container.decodeIfPresent(Store.self, forKey: .store)
        availableAdsCountUserInCurrentMonth = try container.decodeIfPresent(Int.self, forKey: .availableAdsCountUserInCurrentMonth)
        availableAdsCountStoreInCurrentMonth = try container.decodeIfPresent(Int.self, forKey: .availableAdsCountStoreInCurrentMonth)
        plan = try container.decodeIfPresent(Plan.self, forKey: .plan)
    }
}



struct Store: Codable {
    var id: Int?
    var companyName, companyActivity, phone, email: String?
    var whatsapp: String?
    var countryNameAr: CountryNameArObject?
    var countryNameEn: CountryNameEnObject?
    var cityNameAr, cityNameEn, regionNameAr, regionNameEn: String?
    var bio, logo, license: String?
    var twitter, instagram, website, googleMap: String?
    var coverPhoto: String?

    enum CodingKeys: String, CodingKey {
        case id
        case companyName = "company_name"
        case companyActivity = "company_activity"
        case phone, email, whatsapp
        case countryNameAr = "country_name_ar"
        case countryNameEn = "country_name_en"
        case cityNameAr = "city_name_ar"
        case cityNameEn = "city_name_en"
        case regionNameAr = "region_name_ar"
        case regionNameEn = "region_name_en"
        case bio, logo, license, twitter, instagram, website
        case googleMap = "google_map"
        case coverPhoto = "cover_photo"
    }
}

// MARK: - Plan
struct Plan: Codable {
    var id: Int?
    var nameEn, nameAr, pricePerMonth, durationPerDay: String?
    var adsCount: Int?
    var bestSeller, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case pricePerMonth = "price_per_month"
        case durationPerDay = "duration_per_day"
        case adsCount = "ads_count"
        case bestSeller = "best_seller"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - CountryNameAr
struct CountryNameArObject: Codable {
    let nameAr, name: String?
    let currency: String?

    enum CodingKeys: String, CodingKey {
        case nameAr = "name_ar"
        case name, currency
    }
}

// MARK: - CountryNameEn
struct CountryNameEnObject: Codable {
    let nameEn: String?
    let name, currency: String?

    enum CodingKeys: String, CodingKey {
        case nameEn = "name_en"
        case name, currency
    }
}


extension KeyedDecodingContainer {
    func decodeCountryID(forKey key: K) throws -> Int? {
        if let intValue = try? decode(Int.self, forKey: key) {
            return intValue
        } else if let stringValue = try? decode(String.self, forKey: key), let intValue = Int(stringValue) {
            return intValue
        } else {
            return nil
        }
    }
}
