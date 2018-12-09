//
//  ReoccuringEventViewController.swift
//  Calender
//
//  Created by Dylan Mouser on 12/4/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import UIKit

class ReoccuringEventViewController: UIViewController {

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

}
