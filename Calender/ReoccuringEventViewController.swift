//
//  ReoccuringEventViewController.swift
//  Calender
//
//  Created by Dylan Mouser on 12/4/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import UIKit
import RealmSwift

class ReoccuringEventViewController: UIViewController {

    let realm = try! Realm()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet var NotificationButtons: [UIButton]!
    @IBOutlet var CategoryButtons: [UIButton]!
    @IBOutlet var WeekdayButtons: [UIButton]!
    @IBOutlet weak var WeekdayButtonBar: UIStackView!
    
    private var StartDatePicker: UIDatePicker?
    private var StartTimePicker: UIDatePicker?
    private var EndTimePicker: UIDatePicker?
    private var EndDatePicker: UIDatePicker?
    
    private var category: Category?
    private var notificationSelection: NotificationEnum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Reoccuring Event"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        SetUpDatePickers()
        SetTextFieldViews()
        SetInitialStartDates()
        // Do any additional setup after loading the view.
    }
    
    func SetUpDatePickers(){
        StartDatePicker = UIDatePicker();
        StartDatePicker?.datePickerMode = .date
        
        StartTimePicker = UIDatePicker();
        StartTimePicker?.datePickerMode = .time
        
        EndTimePicker = UIDatePicker();
        EndTimePicker?.datePickerMode = .time
        
        EndDatePicker = UIDatePicker();
        EndDatePicker?.datePickerMode = .date
    }
    
    func SetTextFieldViews(){
        startDateTextField.inputView = StartDatePicker
        StartDatePicker?.addTarget(self, action: #selector(ReoccuringEventViewController.startDateChanged(StartDatePicker:)), for: .valueChanged)
        
        startTimeTextField.inputView = StartTimePicker
        StartTimePicker?.addTarget(self, action: #selector(ReoccuringEventViewController.startTimeChanged(StartTimePicker:)), for: .valueChanged)
        
        endTimeTextField.inputView = EndTimePicker
        EndTimePicker?.addTarget(self, action: #selector(ReoccuringEventViewController.endTimeChanged(EndTimePicker:)), for: .valueChanged)
        
        endDateTextField.inputView = EndDatePicker
        EndDatePicker?.addTarget(self, action: #selector(ReoccuringEventViewController.endDateChanged(EndDatePicker:)), for: .valueChanged)
    }
    
    func SetInitialStartDates(){
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "MM/dd/yyyy"
        let dateString = formatter.string(from: now)
        
        startDateTextField.text = dateString
        
        formatter.dateFormat = "h:mm a"
        let timeString = formatter.string(from: now)
        
        startTimeTextField.text = timeString
    }
    
    @objc func startTimeChanged(StartTimePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        startTimeTextField.text = dateFormatter.string(from: StartTimePicker.date)
    }
    
    @objc func startDateChanged(StartDatePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        startDateTextField.text = dateFormatter.string(from: StartDatePicker.date)
    }
    
    @objc func endTimeChanged(EndTimePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        endTimeTextField.text = dateFormatter.string(from: EndTimePicker.date)
    }
    
    @objc func endDateChanged(EndDatePicker: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        endDateTextField.text = dateformatter.string(from: EndDatePicker.date)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func handleNotificationAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations:
            {
                if(!self.WeekdayButtonBar.isHidden){
                    self.WeekdayButtonBar.isHidden = true;
                }
        })
        
        CategoryButtons.forEach{(button) in
            UIView.animate(withDuration: 0.3, animations:{
                if(!button.isHidden){
                    button.isHidden = true;
                }
            })
        }
        
        NotificationButtons.forEach{(button) in
            UIView.animate(withDuration: 0.3, animations:{
                button.isHidden = !button.isHidden;
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func handleCategoryAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations:
        {
            if(!self.WeekdayButtonBar.isHidden){
                self.WeekdayButtonBar.isHidden = true;
            }
        })
        
        NotificationButtons.forEach{(button) in
            UIView.animate(withDuration: 0.3, animations:{
                if(!button.isHidden){
                    button.isHidden = true;
                }
            })
        }
        
        CategoryButtons.forEach{(button) in
            UIView.animate(withDuration: 0.3, animations:{
                button.isHidden = !button.isHidden;
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func handleWeekdaysAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations:
        {
            self.WeekdayButtonBar.isHidden = !self.WeekdayButtonBar.isHidden;
            self.view.layoutIfNeeded()
        })
        
        NotificationButtons.forEach{(button) in
            UIView.animate(withDuration: 0.3, animations:{
                if(!button.isHidden){
                    button.isHidden = true;
                }
            })
        }
        
        CategoryButtons.forEach{(button) in
            UIView.animate(withDuration: 0.3, animations:{
                if(!button.isHidden){
                    button.isHidden = true;
                }
            })
        }
    }
    
    @IBAction func HandleNotificationSelected(_ sender: UIButton) {
        guard let title = sender.currentTitle else{
            return;
        }
        
        NotificationButtons.forEach{(button) in
            button.isSelected = false;
        }
        
        sender.isSelected = true;
        
        notificationSelection = NotificationEnum(rawValue: title)!
    }
    
    @IBAction func HandleCategorySelected(_ sender: UIButton) {
        guard let title = sender.currentTitle else{
            return;
        }
        
        CategoryButtons.forEach{(button) in
            button.isSelected = false;
        }
        
        sender.isSelected = true;
        category = Category(rawValue: title)!
    }
    
    @IBAction func HandleWeekdaySelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Data section
    
    @IBAction func onCreateButtonClicked(_ sender: UIButton) {
        saveMultipleEvents()
        navigationController?.popViewController(animated: true)
    }
    
    func saveMultipleEvents(){
        
        var selectedWeekdays: [Int] = []
        var count = 1
        
        WeekdayButtons.forEach{(button) in
            if(button.isSelected){
                selectedWeekdays.append(count)
            }
            count = count + 1
        }
        
        let calendar = Calendar.current
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        let startdate = dateformatter.date(from: startDateTextField.text!)
        let dateEnding = dateformatter.date(from: endDateTextField.text!)
        
        // Finding matching dates at midnight - adjust as needed
        let components = DateComponents(hour: 0, minute: 0) // midnight
        calendar.enumerateDates(startingAfter: startdate!, matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
            if let date = date {
                if date <= dateEnding! {
                    let weekDay = calendar.component(.weekday, from: date)
                    if selectedWeekdays.contains(weekDay) {
                        saveCurrentEvent()
                        print(date)
                    }
                } else {
                    stop = true
                }
            }
        }
        
    }
    
    func saveCurrentEvent() {
        do{
            try realm.write {
                createEvent()
            }
        } catch {
            print("Error saving new event \(error)")
        }
    }
    
    func createEvent() {
        
        let event = Event()
        
        //basic
        if let title = titleTextField.text,
            let location = locationTextField.text {
            event.title = title
            event.location = location
        }
        event.eventType = EventType.StandAlone
        
        //just test it as work, can you find where the Category enum selected
        switch category {
        case .school?:
            event.category = Category.school
        case .work?:
            event.category = Category.work
        case .social?:
            event.category = Category.social
        case .fitness?:
            event.category = Category.fitness
        case .other?:
            event.category = Category.other
        default:
            event.category = Category.school
        }
        
        switch notificationSelection {
        case .Fifteen?:
            event.notificationTime = NotificationEnum.Fifteen
        case .Thirty?:
            event.notificationTime = NotificationEnum.Thirty
        case .FortyFive?:
            event.notificationTime = NotificationEnum.FortyFive
        case .Hour?:
            event.notificationTime = NotificationEnum.Hour
        default:
            event.notificationTime = NotificationEnum.Fifteen
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "h:mm a"
        
        if let startDate = startDateTextField.text,
            let startTime = startTimeTextField.text,
            let endTime = endTimeTextField.text,
            let endDate = endDateTextField.text {
            event.startDate = dateFormatter.date(from: startDate)
            event.StartTime = timeFormatter.date(from: startTime)
            event.endDate = dateFormatter.date(from: endDate)
            event.endTime = timeFormatter.date(from: endTime)
        }
        
        //if current date not exist, creat it
        if getDateModal() == nil {
            createDateModal()
        }
        
        if let dateModal = getDateModal() {
            dateModal.events.append(event)
        }
    }
    
    func createDateModal() {
        //check whether that day's dateModal created, if not, create it
        
        let date = DateModel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.timeZone = TimeZone.current
        if let dateString = startDateTextField.text {
            date.currentDate = dateFormatter.date(from: dateString)
        }
        saveDateModal(dateModal: date)
    }
    
    func saveDateModal(dateModal: DateModel) {
        
        realm.add(dateModal)
    }
    
    
    func getDateModal() -> DateModel?{
        let currentDateModal: DateModel?
        
        let dateModals = realm.objects(DateModel.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.timeZone = TimeZone.current
        if let dateString = startDateTextField.text,
            let currentDate = dateFormatter.date(from: dateString){
            currentDateModal = dateModals.filter("currentDate = %@", currentDate).first
            return currentDateModal
        }
        return nil
        
    }
}
