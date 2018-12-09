//
//  DateModel.swift
//  Calender
//
//  Created by Jesse Li on 12/6/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import Foundation
import RealmSwift

class DateModel: Object
{
    @objc dynamic var currentDate: Date?
    let events = List<Event>()

}
