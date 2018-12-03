//
//  ViewController.swift
//  Calender
//
//  Created by Jesse Li on 11/26/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    
    @IBAction func addEvent(_ sender: Any) {
        
        createAlert(title: "add an evnet")
    }
    @IBAction func gotoToday(_ sender: Any) {
        
        resetCalenderToToday();
    }
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var itemsView: UICollectionView!
    
    @IBOutlet weak var calenderView: JTAppleCalendarView!
    let formater = DateFormatter()
   
    var startDate = Date();
    
    var dateArray = [Date]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalender();
        
        resetCalenderToToday();
        
        //init the dateArray by that days
        dateArray = generateWeekArrayByDate(Date())
        //weekString = generateWeekStringByDate(dateArray)
        
    }
    func setupCalender() {
        //setup spacing
        calenderView.minimumLineSpacing = 0
        calenderView.minimumInteritemSpacing = 0
        
        //setup labels
        calenderView.visibleDates { (visibleDates) in
            self.setupViewOfCalender(from: visibleDates)
        }
    }
    
    func handleCellSelected(_ cell: JTAppleCell?, _ cellState: CellState) {
        
        guard let cell = cell as? CustomCell else {return}
        let today = Date()
        formater.dateFormat = "yyyy MM dd"
        let todayString = formater.string(from: today)
        let currentString = formater.string(from: cellState.date)
        
        if todayString == currentString {
            cell.selectedView.isHidden = false
            cell.selectedView.backgroundColor = UIColor.red
            cell.dateLabel.textColor = UIColor.white
            
        } else {
            cell.selectedView.backgroundColor = UIColor(red:0.39, green:0.81, blue:0.95, alpha:1.0)
            if cellState.isSelected {
                cell.selectedView.isHidden = false
                cell.dateLabel.textColor = UIColor.white
                
                
                
                
            } else {
                cell.selectedView.isHidden = true
                if cellState.dateBelongsTo == .thisMonth {
                    cell.dateLabel.textColor = UIColor(red:0.54, green:0.59, blue:0.68, alpha:1.0)
                } else {
                    cell.dateLabel.textColor = UIColor(red:0.88, green:0.89, blue:0.91, alpha:1.0)
                    //don't allow click
                    
                }
                
            }
        }
        
    }
    
    //get the current month and year
    func setupViewOfCalender(from visibleDates: DateSegmentInfo)  {
        let date = visibleDates.monthDates.first!.date
        self.formater.dateFormat = "yyyy"
        self.yearLabel.text = self.formater.string(from: date)
        self.formater.dateFormat = "MMMM"
        self.monthLabel.text = self.formater.string(from: date)
    }
    
    func handleDateList(at cellState: CellState) {
        dateArray = generateWeekArrayByDate(cellState.date)
        itemsView.reloadData()
    }
    
    
    
}

extension ViewController: JTAppleCalendarViewDataSource {
    
    //set the start and end time
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formater.dateFormat = "yyyy MM dd"
        formater.timeZone = Calendar.current.timeZone
        formater.locale = Calendar.current.locale
        
        let startDate = formater.date(from: "1997 01 01")!
        let endDate = formater.date(from: "2050 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, generateInDates: .forAllMonths, generateOutDates: .tillEndOfRow)
        return parameters
    }
    
}

extension ViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CustomCell
        cell.dateLabel.text = cellState.text
        handleCellSelected(cell, cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewOfCalender(from: visibleDates)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let vaildCell = cell as? CustomCell else {return}
        if (cellState.dateBelongsTo == .thisMonth) {
            handleCellSelected(vaildCell, cellState)
            handleDateList(at: cellState)
            
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let vaildCell = cell as? CustomCell else {return}
        handleCellSelected(vaildCell, cellState)
    }
    
}

extension ViewController: UICollectionViewDelegate {

    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemsView.dequeueReusableCell(withReuseIdentifier: "itemCustomCell", for: indexPath) as! ItemViewCell
        collectionView.backgroundColor = UIColor(red:0.94, green:0.95, blue:0.95, alpha:1.0)
        cell.contentView.backgroundColor = UIColor.white
        
        modifyCollectionViewCell(for: cell);
        
        formater.timeZone = TimeZone.current
        formater.dateFormat = "dd"
        
        let date = formater.string(from: dateArray[indexPath.row])
        cell.dateLabel.text = date
        
        let currentWeekOfDay = generateWeekStringByDate(form: dateArray[indexPath.row])
        cell.weekLabel.text = currentWeekOfDay
        if currentWeekOfDay == "Saturday" || currentWeekOfDay == "Sunday" {
            cell.contentView.backgroundColor = UIColor(red:0.02, green:0.81, blue:1.00, alpha:1.0)
        }
       
        
        //get it later from the addEvent page
        cell.itemsLabel.text = "11"
        
        return cell
    }
}

// infrastructure
extension ViewController {
    func generateWeekArray(_ cellState: CellState?, _ cell: JTAppleCell?) -> [Date]{
        
        let currentDay = cellState?.date
        var dateArray = [Date]();
        
        for i in 0...6 {
            //add i days from today
            dateArray[i] = currentDay!.add(years: 0, months: 0, days: i, hours: 0, minutes: 0, seconds: 0)!
        }
        
        return dateArray
    }
    
    func generateWeekArrayByDate(_ today: Date) -> [Date]{
        let currentDay = today
        var dateArray: [Date] = [currentDay, currentDay, currentDay, currentDay, currentDay, currentDay, currentDay]
        
        for i in 0...6 {
            //add i days from today
            dateArray[i] = currentDay.add(years: 0, months: 0, days: i, hours: 0, minutes: 0, seconds: 0)!
        }
        
        return dateArray
    }
    
    func generateWeekStringByDate(form date: Date) -> String {
        
        formater.dateFormat = "EEEE"
        formater.timeZone = TimeZone.current
        return formater.string(from: date)
        
    }
    
    func modifyCollectionViewCell(for cell: ItemViewCell) {
        cell.contentView.layer.cornerRadius = 5
    }
    
    func createAlert(title: String) {
        let alert = UIAlertController(title: title, message:"", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "add a task", style: .default) { (action) in
            self.performSegue(withIdentifier: "gotoTask", sender: nil)
        }
        let action2 = UIAlertAction(title: "add an event", style: .default) { (action) in
            
            self.performSegue(withIdentifier: "gotoEvent", sender: nil)
        }
        let action3 = UIAlertAction(title: "Never Mind", style: .default, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        present(alert, animated: true);
        
    }
    func resetCalenderToToday() {
        calenderView.scrollToDate(Date())
        let dates = [Date()]
        calenderView.selectDates(dates)
    }
}


extension Date {
    
    /// Returns a Date with the specified amount of components added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    /// Returns a Date with the specified amount of components subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
    
    var currentUTCTimeZoneDate: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: self)
    }

    
}

