//
//  EventViewController.swift
//  Calender
//
//  Created by Jesse Li on 12/2/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import UIKit
import RealmSwift

class EventViewController: UIViewController {
    
    let realm = try! Realm()
    
    
    @IBAction func onCreatButtonClicked(_ sender: Any) {
        saveCurrentEvent()
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet var NotificationButtons: [UIButton]!
    
    @IBOutlet var CategoryButtons: [UIButton]!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTImeTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    private var StartTimePicker: UIDatePicker?
    private var EndTimePicker: UIDatePicker?
    
    private var category: Category?
    private var notificationSelection: NotificationEnum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Standalone Event"

        datePicker = UIDatePicker();
        datePicker?.datePickerMode = .date
        
        StartTimePicker = UIDatePicker();
        StartTimePicker?.datePickerMode = .time
        
        EndTimePicker = UIDatePicker();
        EndTimePicker?.datePickerMode = .time
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        startDateTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(EventViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        startTimeTextField.inputView = StartTimePicker
        StartTimePicker?.addTarget(self, action: #selector(EventViewController.timeChanged(StartTimePicker:)), for: .valueChanged)
        
        endTImeTextField.inputView = EndTimePicker
        EndTimePicker?.addTarget(self, action: #selector(EventViewController.endTimeChanged(EndTimePicker:)), for: .valueChanged)
        // Do any additional setup after loading the view.
        
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
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func timeChanged(StartTimePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        startTimeTextField.text = dateFormatter.string(from: StartTimePicker.date)
    }
    
    @objc func endTimeChanged(EndTimePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        endTImeTextField.text = dateFormatter.string(from: EndTimePicker.date)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        startDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func handleNotificationSelection(_ sender: UIButton) {
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
    
    @IBAction func ChooseNotificationAction(_ sender: UIButton) {
        guard let title = sender.currentTitle else{
            return;
        }
        
        NotificationButtons.forEach{(button) in
            button.isSelected = false;
        }
        
        sender.isSelected = true;
        
        notificationSelection = NotificationEnum(rawValue: title)!
    }
    
    @IBAction func handleCategorySelection(_ sender: UIButton) {
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
    
    @IBAction func ChooseCategoryAction(_ sender: UIButton) {
        guard let title = sender.currentTitle else{
            return;
        }
        
        CategoryButtons.forEach{(button) in
            button.isSelected = false;
        }
        
        sender.isSelected = true;
        category = Category(rawValue: title)!
    }
    
    
    //Data Persistence part
    
    //get the currentDate from Realm, if don't have that date, create one else load it
    //createButton click, create the standAloneEvent
    //store it in Realm
    
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
            let endTime = endTImeTextField.text {
            event.startDate = dateFormatter.date(from: startDate)
            event.StartTime = timeFormatter.date(from: startTime)
            event.endDate = dateFormatter.date(from: startDate)
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
