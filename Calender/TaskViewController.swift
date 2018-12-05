//
//  TaskViewController.swift
//  Calender
//
//  Created by Jesse Li on 12/2/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var estimatedTimeText: UITextField!
    @IBOutlet weak var sessionsText: UITextField!
    
    private var datePicker: UIDatePicker?
    private var dueDateTimePicker: UIDatePicker?
    private var estimatedTimePicker: UIDatePicker?
    private var sessionsPicker: Picker
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a task"
        
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
        
        timeText.inputView = dueDateTimePicker
        dueDateTimePicker?.addTarget(self, action: #selector(TaskViewController.dueDateTimeChanged(dueDateTimePicker:)), for: .valueChanged)
        
        estimatedTimeText.inputView = estimatedTimePicker
        estimatedTimePicker?.addTarget(self, action: #selector(TaskViewController.estimatedTimeChanged(estimatedTimePicker:)), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func estimatedTimeChanged(estimatedTimePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        estimatedTimeText.text = dateFormatter.string(from: estimatedTimePicker.date)
    }
    
    @objc func dueDateTimeChanged(dueDateTimePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        timeText.text = dateFormatter.string(from: dueDateTimePicker.date)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateText.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
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
