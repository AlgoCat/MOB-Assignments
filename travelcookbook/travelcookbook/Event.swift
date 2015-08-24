//
//  Event.swift
//  travelcookbook
//
//  Created by Kitty Wu on 22/8/15.
//  Copyright (c) 2015 Kitty Wu. All rights reserved.
//

import Foundation


class Event {
    var eventId = ""
    var eventName = ""
    var eventType = ""
    var eventIndex:Int = 0
    
    var origin = ""
    var originGooglePlaceId = ""
    var originLatitude:Double = 0.0
    var originLongitude:Double = 0.0
    var destination = ""
    var destinationGooglePlace = ""
    var destinationLatitude:Double = 0.0
    var destinationLongitude:Double = 0.0
    
    var startDate = ""
    var endDate = ""
    
    var image:UIImage
    
    var dbObject = PFObject(className:"Event")
    
    init(type:String) {
        eventType = type
        image = getImage(eventType)
    }
}

func getImage(eventType:String) -> UIImage {
    switch eventType {
        case EventType.SightSeeing.rawValue:
            return UIImage(named: "image.png")!
        case EventType.Flight.rawValue:
            return UIImage(named: "plane.png")!
        case EventType.Train.rawValue:
            return UIImage(named: "train.png")!
        default:
            return UIImage(named: "calendar.png")!
    }
}


enum EventType:String {
    case SightSeeing = "Sight-seeing"
    case Flight = "Flight"
    case Train = "Train"
    case Other = "Other"
    case None = "None"
    
    static let allTypes:[String] = [SightSeeing.rawValue, Flight.rawValue, Train.rawValue, Other.rawValue]

    // More types later
}