//
//  Itinerary.swift
//  travelcookbook
//
//  Created by Kitty Wu on 9/8/15.
//  Copyright (c) 2015 Kitty Wu. All rights reserved.
//

import Foundation

class Itinerary {
    var itineraryId = ""
    var name = ""
    var userId = ""
    var origin = ""
    var destination = ""
    var startDate = ""
    var endDate = ""
    var image:UIImage = UIImage(named: "luggage.png")!
    
    
    var eventIndex = 0
    var dbObject = PFObject(className: "Itinerary")

}