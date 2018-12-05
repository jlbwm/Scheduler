//
//  EventViewController.swift
//  Calender
//
//  Created by Jesse Li on 12/2/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Event"

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
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func timeChanged(StartTimePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        startTimeTextField.text = dateFormatter.string(from: StartTimePicker.date)
        view.endEditing(true)
    }
    
    @objc func endTimeChanged(EndTimePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        endTImeTextField.text = dateFormatter.string(from: EndTimePicker.date)
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        startDateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @IBAction func handleNotificationSelection(_ sender: UIButton) {
        NotificationButtons.forEach{(button) in
            UIView.animate(withDuration: 0.3, animations:{
                button.isHidden = !button.isHidden;
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func ChooseNotificationAction(_ sender: UIButton) {
    }
    
    @IBAction func handleCategorySelection(_ sender: UIButton) {
        CategoryButtons.forEach{(button) in
            UIView.animate(withDuration: 0.3, animations:{
                button.isHidden = !button.isHidden;
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func ChooseCategoryAction(_ sender: Any) {
    }
}
