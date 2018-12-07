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
    var category: Category?
    var eventType: EventType?
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

enum Week: String {
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

enum EventType {
    case Task;
    case StandAlone;
    case Recurring;
}

