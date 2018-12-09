//
//  TaskViewController.swift
//  Calender
//
//  Created by Jesse Li on 12/2/18.
//  Copyright © 2018 Jesse Li. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var dueDateTimeText: UITextField!
    @IBOutlet weak var estimatedTimeText: UITextField!
    @IBOutlet weak var sessionsText: UITextField!
    @IBOutlet weak var sessionsPicker: UIPickerView!
    @IBOutlet var categoryButtons: [UIButton]!
    
    
    private var datePicker: UIDatePicker?
    private var dueDateTimePicker: UIDatePicker?
    private var estimatedTimePicker: UIDatePicker?
    
    private var category: Category?
    
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
    
    @IBAction func handleCategorySelection(_ sender: UIButton) {
        categoryButtons.forEach{(button) in
            UIView.animate(withDuration: 0.3, animations:{
                button.isHidden = !button.isHidden;
                self.view.layoutIfNeeded()
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
