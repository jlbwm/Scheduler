//
//  TaskViewController.swift
//  Calender
//
//  Created by Jesse Li on 12/2/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import UIKit
import RealmSwift

class TaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let realm = try! Realm()

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var dueDateTimeText: UITextField!
    @IBOutlet weak var estimatedTimeText: UITextField!
    @IBOutlet weak var sessionsText: UITextField!
    @IBOutlet weak var sessionsPicker: UIPickerView!
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet var notifactionButtons: [UIButton]!
    
    
    private var datePicker: UIDatePicker?
    private var dueDateTimePicker: UIDatePicker?
    private var estimatedTimePicker: UIDatePicker?
    
    private var category: Category?
    private var notification: NotificationEnum?
    
    let pickerDataSource = ["1","2","3","4","5","6","7","8","9"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a task"
        
        sessionsPicker.dataSource = self
        sessionsPicker.delegate = self
        sessionsPicker.isHidden = true
        
        datePicker = UIDatePicker();
        datePicker?.datePickerMode = .date
        
        dueDateTimePicker = UIDatePicker();
        dueDateTimePicker?.datePickerMode = .time
        
        estimatedTimePicker = UIDatePicker();
        estimatedTimePicker?.datePickerMode = .time
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateText.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(TaskViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        dueDateTimeText.inputView = dueDateTimePicker
        dueDateTimePicker?.addTarget(self, action: #selector(TaskViewController.dueDateTimeChanged(dueDateTimePicker:)), for: .valueChanged)
        
        estimatedTimeText.inputView = estimatedTimePicker
        estimatedTimePicker?.addTarget(self, action: #selector(TaskViewController.estimatedTimeChanged(estimatedTimePicker:)), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        sessionsText.text = pickerDataSource[row]
    }
    @IBAction func displayPicker(_ sender: Any) {
        sessionsPicker.isHidden = false;
    }
    
    @IBAction func hidePickerOnFinish(_ sender: Any) {
        sessionsPicker.isHidden = true;
    }
    
    @objc func estimatedTimeChanged(estimatedTimePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        estimatedTimeText.text = dateFormatter.string(from: estimatedTimePicker.date)
    }
    
    @objc func dueDateTimeChanged(dueDateTimePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dueDateTimeText.text = dateFormatter.string(from: dueDateTimePicker.date)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateText.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func onCreateButtonClicked(_ sender: Any) {
        saveCurrentEvent()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleCategorySelection(_ sender: UIButton) {
        categoryButtons.forEach{(button) in
            UIView.animate(withDuration: 0.3, animations:{
                button.isHidden = !button.isHidden;
                self.view.layoutIfNeeded()
            })
        }
        notifactionButtons.forEach{(button) in
            UIView.animate(withDuration: 0.3, animations:{
                if(!button.isHidden){
                    button.isHidden = true;
                }
            })
        }
    }
    
    @IBAction func chooseCategoryAction(_ sender: UIButton) {
        guard let title = sender.currentTitle else{
            return;
        }
        
        categoryButtons.forEach{(button) in
            button.isSelected = false;
        }
        
        sender.isSelected = true;
        category = Category(rawValue: title)!
    }
    
    @IBAction func handleNotificationSelection(_ sender: UIButton) {
        categoryButtons.forEach{(button) in
            UIView.animate(withDuration: 0.3, animations:{
                if(!button.isHidden){
                    button.isHidden = true;
                }
            })
        }
        notifactionButtons.forEach{(button) in
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
        
        notifactionButtons.forEach{(button) in
            button.isSelected = false;
        }
        
        sender.isSelected = true;
        
        notification = NotificationEnum(rawValue: title)!
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func saveCurrentEvent() {
        do{
            try realm.write {
                createTask()
            }
        } catch {
            print("Error saving new event \(error)")
        }
    }

    func createTask() {

        let event = Event()

        //basic
        if let title = titleText.text,
            let location = locationText.text {
            event.title = title
            event.location = location
        }
        event.eventType = EventType.Task

        //just test it as work, can you find where the Category enum selected
        event.category = category

        event.notificationTime = notification

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM/dd/yyyy"

        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "h:mm a"

        if let dueTime = dueDateTimeText.text,
            let dueDate = dateText.text {
            event.deadline = dateFormatter.date(from: dueDate)
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
        if let dateString = dateText.text {
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
        if let dateString = dateText.text,
            let currentDate = dateFormatter.date(from: dateString){
            currentDateModal = dateModals.filter("currentDate = %@", currentDate).first
            return currentDateModal
        }
        return nil

    }
    

}
