//
//  Constants.swift
//  AQI
//
//  Created by Pratik on 13/12/21.
//

import Foundation

let serverURL = "https://open.er-api.com/v6/latest/USD"
let VideosDirectory =  "VideosDirectory"

struct FirebaseTopic
{
    // proximity_backgrounds_backgroundNotification
    static let prefix = "proximity_backgrounds"
    static let backgroundNotification = prefix + "_" + "backgroundNotification"
}

struct Key
{
    static let fcmServerKey = "AAAAL12Izt8:APA91bED6Rd7FSvqUsKo_tgJ9j2f6ZIILyrGfhlzFikfj7P8JirnTcJZDCCEIaHrsyqt1Rj977vX2u7bGKkV8O2LpsxWxpGIGK0FgbI4t1_itk0m8T-Ast0mAJU7AW_PRAwKfqYOdqea"
    
    static let currencyRates = "dicRates"
    static let lastUpdatedDateRates = "lastUpdatedDateRates"
    
    static let photosCount = "photosCount"
    static let videoCount = "videoCount"
    static let lastUpdatedDatePhotoCount = "lastUpdatedDatePhotoCount"
    
    static let lastUpdatedDateBgNotification = "lastUpdatedDateBgNotification"
}

let arrURLs: [Dictionary] = {
    return [
        ["title": "Big Buck Bunny",                     "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"],
        ["title": "Elephants dream",                    "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"],
        ["title": "For bigger fun",                     "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4"],
        ["title": "Sintel",                             "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4"],
        ["title": "Tears of steel",                     "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"],
        ["title": "We are going on bullrun",            "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4"],
        ["title": "Subaru out back on street and dirt", "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4"]
    ]
}()

//---------------------------------------------------------------------------------------------------------------------------------------------//

//let serverURL = "https://httpbin.org/get"
//let serverURL = "http://dummy.restapiexample.com/api/v1/employees"
//let serverURL = "https://jsonplaceholder.typicode.com/todos/1"
//let serverURL = "https://v2.jokeapi.dev/joke/Any?safe-mode"
// Reference: https://mixedanalytics.com/blog/list-actually-free-open-no-auth-needed-apis/

// TaskModel.init(title: "Background Notification", description: "Deliver notifications that wake your App and update it in the background", segueId: "listToBGNotification"),
