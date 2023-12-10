//
//  Constants.swift
//  Sla
//
//  Created by Amal Elgalant on 3/25/20.
//  Copyright © 2020 Amal Elgalant. All rights reserved.
//

import Foundation
import UIKit
import Alamofire



//STORYBOARD
let Auth_STORYBOARD = "Auth"
let MAIN_STORYBOARD = "Main"
let ADVS_STORYBOARD = "Advs"
let PROFILE_STORYBOARD = "Profile"
let CATEGORRY_STORYBOARD = "Category"
let PRODUCT_STORYBOARD = "Product"
let MENU_STORYBOARD = "Menu"
let SEARCH_STORYBOARD = "Search"

//Auth Controllers
let LOGIN_VCID = "login"
let SIGNUP_VCID = "register"
let SIGNUP_CODE_VCID = "verify_email"
let FORGET_PASSWORD_VCID = "forget_passworrd"
let FORGET_VERIFY_CODE_VCID = "verify_phone"
let RESET_PASSWORD_VCID = "reset_password"



//Home Controllers
let TYPE_VCID = "type"
let SORT_VCID = "sort"
let COUNTRY_VCIID = "country_list"
let CITIES_VCIID = "city_list"
let CITY_VCIID = "cities"
let STATE_VCID = "state_list"
let CREDIT_VCID = "CreditVC"
let CATEGORY_VCID = "category_list"
let SUB_CATEGORY_VCID = "subcategory_list"

//

//Product Controllers
let PRODUCT_VCID = "product_details"
let REPLY_VCID = "reply"
let FLAG_VCID = "flage"
let COMMENT_VCID = "comment"
let REPORT_COMMENT_VCID = "report_comment"
let COMMENT_REPLY_VCID = "comment_replies"
let REPORT_REPLY_VCID = "report_reply"

//Category Controllers
let CATEGORIES_VCID = "categories"
let ASK_CITY_VCID = "asks_city"
let ASK_ADD_VCID = "add_ask"
let ASK_IMAGE_PICKER_VCID = "ask_image_picker"

//Search Controllers
let SEARCH_VCID = "search"

//utilities
let NO_INTERNET_CONNECTION = "No internet connection".localize
let SERVER_ERROR = "server error ... try again later".localize

//Advs Controllers
let ADDADVS_VCID = "AddAdvsVC"
let PICKUP_MEDIA_POPUP_VCID = "PickupMediaPopupVC"
let PICKUP_MEDIA_POPUP_EDIT_VCID = "PickupMediaPopupEditAdsVC"
let SUCCESS_ADDING_VCID = "SuccessAddingVC"

//Edit Ads Controllers
let EDITAD_VCID = "EditAdVC"

// menu Cntrollers

let MENU_VCID = "MenuVC"
let MYADS_VCID  = "MyAdsVC"

//Profile Controllers

let OTHER_USER_PROFILE_VCID = "OtherUserProfileVC"
let PROFILE_VCID = "ProfileVC"



enum UserType {
    case store, regular
}
enum AdType {
    case featured, normal
}

//Constants

class Constants {
    static let MAIN_DOMAIN = "https://bazar.bluezone-web.com/"
    static var API_KEY:String = "AIzaSyDrkcLvUTdoNRekyjFnGrDyD8D9XMJggpI"

    static let DOMAIN = MAIN_DOMAIN + "api/"
    static let IMAGE_URL = MAIN_DOMAIN + "image/"
    
    //Home
    static let HOME_PRODUCTS_URL = DOMAIN + "prods_by_filter"
    static let HOME_STORES_URL = DOMAIN + "stores"
    static let HOME_FEATURE_PRODUCTS_URL = DOMAIN + "feature_prods"
    static let GET_CATEGORIES_URL = DOMAIN + "categories"
    static let GET_SUB_CATEGORIES_URL = DOMAIN + "sub_category"
    static let GET_SLIDERS_URL = DOMAIN + "sliders"
    static let SETTINGS_URL = DOMAIN + "settings"


    //Product
    static let PRODUCT_URL = DOMAIN + "prods_by_id"
    static let ADD_COMMENT_URL = DOMAIN + "comment_on_prods"
    static let ADD_REPLY_URL = DOMAIN + "replay_on_comment"
    static let FLAGE_COMMENT_URL = DOMAIN + "comment_reports"
    static let LIKE_COMMENT_URL = DOMAIN + "like_prods"
    static let LIKE_AD_URL = DOMAIN + "fav_prod"
    static let REPORT_AD_URL = DOMAIN + "report_on_prods"
    static let REPORT_USER_URL = DOMAIN + "report_user"
    static let COMMENT_REPLY_URL = DOMAIN + "prods_comments_replay"
    static let REPORT_REPLY_URL = DOMAIN + "reply_reports"
    static let DELETE_REPLY_URL = DOMAIN + "delete_comment_on_rates"
    static let PAYING_FEATURED_AD_URL = DOMAIN + "prods/pay/"
    static let PAYING_FEATURED_AD_CALLBACK_URL = DOMAIN + "prods/callback"
    static let PAYING_PLAN_SUBSCRIPE_URL = DOMAIN + "plans/subscribe"
    static let PAYING_PLAN_CALLBACK_URL = DOMAIN + "plans/callback"
    static let REPOST_PRODUCT_URL = DOMAIN + "prods_repost"


//delete_comment_on_rates
    
    //reply_reports
    //Search
    static let SEARCH_ADS_URL = DOMAIN + "prods_search"
    static let SEARCH_PERSONS_URL = DOMAIN + "users_search"
    static let SEARCH_QUESTIONS_URL = DOMAIN + "questions_search"

    
    //Auth
    static let LOGIN_URL = DOMAIN + "login"
    static let SIGN_UP_URL = DOMAIN + "signup"
    static let SIGN_UP_VERIFY_URL = DOMAIN + "verification"
    static let SIGN_UP_RESEND_CODE_URL = DOMAIN + "resend_code"
    static let CHECK_USER_URL = DOMAIN + "check-user"
    static let RESET_PASSWORD_URL = DOMAIN + "forgot-password"

    //UTILITIES
    static let COUNTRIES_URL = DOMAIN + "countries"
    static let CITIES_URL = DOMAIN + "cities_by_country_id"
    static let STATE_URL = DOMAIN + "region_by_city_id"

    //Add-Advs
    static let ADDADVS_URL = DOMAIN + "prods_add"
    
    //Profile
    static let PROFILE_URL = DOMAIN + "profile"
    static let PRODUCTS_BY_USER_URL = DOMAIN + "prods_by_user"
    static let EDIT_USER_URL = DOMAIN + "user_edit"
    static let EDIT_STORE_URL = DOMAIN + "stores/"
    static let FOLLOW_USER = DOMAIN + "make_follow"
    static let BLOCK_USER = DOMAIN + "blocked"
    static let GET_BLOCKED_USERS = DOMAIN + "getBlockedUsersForUser"
    static let CHECK_USERR_PENDING = DOMAIN + "check_user_pending"
    
    //Notifications
    static let SAVE_TOKEN_URL = DOMAIN + "notifications/save_token"
    static let GET_NOTIFICATIONS_URL = DOMAIN + "notifications"
    static let GET_NOTIFICATIONS_COUNT_URL = DOMAIN + "notifications/count"
    static let DELETE_NOTIFICATIONS_URL = DOMAIN + "notifications/delete_all"
    
    //Asks
    //question_by_city_id
    static let ASKS_CITY_URL = DOMAIN + "question_by_city_id"
    static let ASKS_USER_URL = DOMAIN + "question_by_user_id"
    static let ASK_ADD_URL = DOMAIN + "questions_add"
    static let ASK_DELETE_URL = DOMAIN + "questions_delete"
    static let GET_ASK_REPLY_URL = DOMAIN + "question_comments"

    static let DELETE_ASK_REPLY_URL = DOMAIN + "delete_comment_on_questions"
    static let ASK_REPLY_URL = DOMAIN + "comment_on_questions"
    static let ASK_REPLY_REPORT_URL = DOMAIN + "questions_reports"
    static let ASK_LIKE_REPLY_URL = DOMAIN + "like_on_questions"
    
    //FOLLOWERS & FOLLOWINGS
    static let FOLLOWERS_URL = DOMAIN + "followers"
    static let FOLLOWINGS_URL = DOMAIN + "following"
    
    //Chat
    static let CREATE_CHAT_ROOM = DOMAIN + "create_room"

    //packages
    static let GET_PLANS_URL = DOMAIN + "plans"
    static let GET_PLANS_CATEGORY_URL = DOMAIN + "plan/categories"

    
    static var COUNTRIES = [Country]()
    static var CITIES = [Country]()
    static var STATUS = [Country]()
    static var countryId = 6
    static var countPaidAds = 0
    
    //NotificationsCount
    
    static var notificationsCount = 0
    
    
    //location
    static var lat:Double = 0
    static var lng:Double = 0
    static var loc:String = "موقعك علي الخريطة"
    
    //location order
    static var orderLoc_represnted = false
    static var orderLat:Double=31
    static var orderLng:Double=31
    static var orderLoc:String="موقعك علي الخريطة"
    static var orderSub_loc:String=""
    static var orderFilePath:URL?
    static var loc_img:String = ""
    static var api_key:String = "AIzaSyDrkcLvUTdoNRekyjFnGrDyD8D9XMJggpI"
    //autocomplete places
    static var tempPlace_id:String = ""
    static var tempPlace_name:String = ""
    
    static var tempLat:Double = 0;
    static var tempLng:Double = 0;
    
    static var otherUserPic = ""
    static var otherUserIsStore = false
    static var otherUserName = ""
    static var userOtherId = ""
    
    //Follow
    static var followIndex = 0
    static var followOtherUserId = 0
    
    //chat
    static var room_id:String = "0"
    static var headerProd:HTTPHeaders = ["Authorization":"Bearer \(AppDelegate.currentUser.toke ?? "")"]
    static var header: HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
}
