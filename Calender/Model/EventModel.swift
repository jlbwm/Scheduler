//
//  EventModel.swift
//  Calender
//
//  Created by Jesse Li on 11/28/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import Foundation
import RealmSwift

class User {
    var weekdayStartTime: Date?
    var weekdayEndTime: Date?
    var weekendStartTime: Date?
    var weekendEndTime: Date?
    var isMorningPerson: Bool = false
    var advanceDate: Int = 0
    var isSplit: Bool = false
    var isDifficult: Bool = false
}

class Event: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var category: String? //get the raw string value from Category
    @objc dynamic var notificationTime: String? //get the raw string value from NotificationEnum
    @objc dynamic var eventType: String? //get the raw string value from EventType
    var parentCategory = LinkingObjects(fromType: DateModel.self, property: "events")
    
    
    //task part (we check the eventType when fetching the event from Datebase)
    @objc dynamic var deadline: Date?
    @objc dynamic var isSplittable: Bool = false
    
    @objc dynamic var Priority: Int = 0
    @objc dynamic var Difficult: Int = 0
    
    //Event Part
    //set the standAloneEvent's endDate equals to startDate
    @objc dynamic var startDate: Date?
    @objc dynamic var StartTime: Date?
    @objc dynamic var endDate: Date?
    @objc dynamic var endTime: Date?
    
    //recurringEvent part
    var week: [Week]?
}

enum Week: Int{
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

enum Frequence {
    case Daily
    case Weekly
    case Monthly
    case None
}

enum Category: String {
    case school = "School"
    case work = "Work"
    case social = "Social"
    case fitness = "Fitness"
    case other = "Other"
}

enum NotificationEnum: String{
    case Fifteen = "15 Minutes Prior"
    case Thirty = "30 Minutes Prior"
    case FortyFive = "45 Minutes Prior"
    case Hour = "1 Hour Prior"
}

enum EventType: String{
    case Task = "Task";
    case StandAlone = "StandAlone";
    case Recurring = "Recurring";
}

