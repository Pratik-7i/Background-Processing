//
//  Constants.swift
//  AQI
//
//  Created by Pratik on 13/12/21.
//

import Foundation

let VideosDirectory = "VideosDirectory"

struct API
{
    static let getWeatherForecast = "https://weatherdbi.herokuapp.com/data/weather/london"
    static let getDrinksMenu      = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita"
    static let getExchangeRates   = "https://open.er-api.com/v6/latest/USD"
}

struct FirebaseTopic
{
    static let prefix = "proximity_backgrounds"
    static let backgroundNotification = prefix + "_" + "backgroundNotification"
}

struct Key
{
    static let fcmServerKey = "AAAAL12Izt8:APA91bED6Rd7FSvqUsKo_tgJ9j2f6ZIILyrGfhlzFikfj7P8JirnTcJZDCCEIaHrsyqt1Rj977vX2u7bGKkV8O2LpsxWxpGIGK0FgbI4t1_itk0m8T-Ast0mAJU7AW_PRAwKfqYOdqea"
    
    // Background Fetch
    static let weatherInfo = "weatherInfo"
    static let lastUpdatedDateWeather = "lastUpdatedDateWeather"

    // Background Processing
    static let photosCount = "photosCount"
    static let videoCount = "videoCount"
    static let lastUpdatedDatePhotoCount = "lastUpdatedDatePhotoCount"
    
    // Background Notification
    static let drinks = "drinks"
    static let lastArrivedDateBgNotification = "lastArrivedDateBgNotification"
    static let lastBgNotificationUserInfo    = "lastBgNotificationUserInfo"
    static let lastUpdatedDateBgNotification = "lastUpdatedDateBgNotification"
    
    // Background Extension
    static let currencyRates = "dicRates"
    static let lastUpdatedDateRates = "lastUpdatedDateRates"
    
    // Others
    static let isDarkMode = "isDarkMode"
}

let arrURLs: [Dictionary] = {
    return [["title": "Big Buck Bunny",                     "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"],
            ["title": "Elephants dream",                    "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"],
            ["title": "For bigger fun",                     "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4"],
            ["title": "Sintel",                             "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4"],
            ["title": "Tears of steel",                     "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"],
            ["title": "We are going on bullrun",            "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4"],
            ["title": "Subaru out back on street and dirt", "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4"]]
}()

//---------------------------------------------------------------------------------------------------------------------------------------------//

// https://httpbin.org/get"
// http://dummy.restapiexample.com/api/v1/employees"
// https://jsonplaceholder.typicode.com/todos/1"
// https://v2.jokeapi.dev/joke/Any?safe-mode"
// https://mixedanalytics.com/blog/list-actually-free-open-no-auth-needed-apis/
