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
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet var collection:[UIView]!
    
    @IBOutlet weak var calenderView: JTAppleCalendarView!
    let formater = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalender();
        
        calenderView.scrollToDate(Date())
        let dates = [Date()]
        calenderView.selectDates(dates)
        //initialItemView(currentDate: Date())
    }
    
    //保证选择的日期为圆
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
            if cellState.isSelected {
                cell.selectedView.isHidden = false
                cell.dateLabel.textColor = UIColor.white
            } else {
                cell.selectedView.isHidden = true
                if cellState.dateBelongsTo == .thisMonth {
                    cell.dateLabel.textColor = UIColor(red:0.54, green:0.59, blue:0.68, alpha:1.0)
                } else {
                    cell.dateLabel.textColor = UIColor(red:0.88, green:0.89, blue:0.91, alpha:1.0)
                }
                
            }
        }
        
    }
    
    func setupViewOfCalender(from visibleDates: DateSegmentInfo)  {
        let date = visibleDates.monthDates.first!.date
        self.formater.dateFormat = "yyyy"
        self.yearLabel.text = self.formater.string(from: date)
        self.formater.dateFormat = "MMMM"
        self.monthLabel.text = self.formater.string(from: date)
    }
    
    
}

extension ViewController: JTAppleCalendarViewDataSource {
    
    //设置日历的起止日期
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
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let vaildCell = cell as? CustomCell else {return}
//        vaildCell.selectedView.isHidden = false
//        vaildCell.dateLabel.textColor = UIColor.white
        handleCellSelected(vaildCell, cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let vaildCell = cell as? CustomCell else {return}
//        vaildCell.selectedView.isHidden = true
//        vaildCell.dateLabel.textColor = UIColor(red:0.54, green:0.59, blue:0.68, alpha:1.0)
        handleCellSelected(vaildCell, cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        setupViewOfCalender(from: visibleDates)
        
    }
}

