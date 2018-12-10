//
//  DateDetailsViewController.swift
//  Calender
//
//  Created by Jesse Li on 12/2/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import UIKit
import RealmSwift

class DateDetailsViewController: UIViewController {
    
    var selectedDate: Date?
    
    let realm = try! Realm()
    
    @IBOutlet weak var dateDetailsTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    func getDateModal(for selectedDate: Date) -> DateModel?{
        let currentDateModal: DateModel?
        
        let dateModals = realm.objects(DateModel.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.timeZone = TimeZone.current
        
        let dateString = dateFormatter.string(from: selectedDate)
        
        let current = dateFormatter.date(from: dateString)
        
        currentDateModal = dateModals.filter("currentDate = %@", current).first
        
        return currentDateModal
        
    }
    
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



extension DateDetailsViewController: UITableViewDelegate {
    
}

extension DateDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let date = selectedDate {
            return getDateModal(for: date)?.events.count ?? 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dateDetailsTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TimeCustomCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm"
        dateFormatter.timeZone = TimeZone.current
        
        if let date = selectedDate {
            if let events = getDateModal(for: date)?.events {
                let sortedEvents = events.sorted(byKeyPath: "StartTime", ascending: false)
                if let time = sortedEvents[indexPath.row].StartTime {
                    let startString = dateFormatter.string(from: time)
                    cell.startTime.text = startString
                    cell.Title.text = sortedEvents[indexPath.row].title
                    cell.location.text = sortedEvents[indexPath.row].location
                    
                }
            }
        }
        
        return cell
       
        
        
        
    }
    
}

//// set the task start
//extension DateDetailsViewController: UIViewController {
//    
//    
//    
//    //get event list from dateModal
//    
//    //1.get all the event's start time and end time
//    //2.callcate the avaliable time space
//    //3.
//    
//    
//}
