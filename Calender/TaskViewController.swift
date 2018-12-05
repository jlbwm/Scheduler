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
    
    private var datePicker: UIDatePicker?
    private var timePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a task"
        
        datePicker = UIDatePicker();
        datePicker?.datePickerMode = .date
        
        timePicker = UIDatePicker();
        timePicker?.datePickerMode = .time
        
        dateText.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(TaskViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        timeText.inputView = timePicker
        timePicker?.addTarget(self, action: #selector(TaskViewController.timeChanged(timePicker:)), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func timeChanged(timePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        timeText.text = dateFormatter.string(from: timePicker.date)
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateText.text = dateFormatter.string(from: datePicker.date)
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
