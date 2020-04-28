//
//  CalendarController.swift
//  WorkCalendar
//
//  Created by Михаил Маслов on 15.12.2019.
//  Copyright © 2019 Михаил Маслов. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarView: UIViewController, UITextFieldDelegate {
    
    @IBAction func doneBtnFromKeyboardClicked (sender: Any) {
        self.view.endEditing(true)
    }
    fileprivate weak var calendar: FSCalendar!
    var workDayTextField: UITextField = UITextField()
    var restDayTextFields: UITextField = UITextField()
    let showActualCalendar = UIButton(type: .system)
    let ViewForDoneButtonOnKeyboard = UIToolbar()
    
    
    let btnDoneOnKeyboard = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(doneBtnFromKeyboardClicked))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCalendar()
        addTextFields()
        addLabels()
        addButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    func addCalendar() {
        let calendar = FSCalendar()
        let safeGuide = self.view.safeAreaLayoutGuide
        
        view.addSubview(calendar)
        
        calendar.appearance.borderRadius = 0
        calendar.collectionViewLayout.sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsSelection = false
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        calendar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = false
        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        calendar.heightAnchor.constraint(equalToConstant: 550).isActive = true
        calendar.widthAnchor.constraint(equalToConstant: 400).isActive = true
        self.calendar = calendar
        
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            view.frame.origin.y = -300
        }
        else {
            view.frame.origin.y = 0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:
        NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 2
    }
    
    func addTextFields() {
        let safeGuide = self.view.safeAreaLayoutGuide
        workDayTextField.smartInsertDeleteType = .no
        workDayTextField.delegate = self
        restDayTextFields.smartInsertDeleteType = .no
        restDayTextFields.delegate = self
        
        
        self.view.addSubview(workDayTextField)
        self.view.addSubview(restDayTextFields)
        
        
        workDayTextField.translatesAutoresizingMaskIntoConstraints = false
        restDayTextFields.translatesAutoresizingMaskIntoConstraints = false
        workDayTextField.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        restDayTextFields.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: workDayTextField, attribute: .top, relatedBy: .equal, toItem: view!, attribute:.top, multiplier: 1, constant: 700),
            NSLayoutConstraint(item: workDayTextField, attribute: .leading, relatedBy: .equal, toItem: view!, attribute: .leading, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: workDayTextField, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 100),
            NSLayoutConstraint(item: restDayTextFields, attribute: .top, relatedBy: .equal, toItem: view!, attribute:.top, multiplier: 1.0, constant: 700),
            NSLayoutConstraint(item: restDayTextFields, attribute: .trailing, relatedBy: .equal, toItem: view!, attribute: .trailing, multiplier: 1, constant: -50),
            NSLayoutConstraint(item: restDayTextFields, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 100)])
        
        
        ViewForDoneButtonOnKeyboard.sizeToFit()
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        
        workDayTextField.inputAccessoryView = ViewForDoneButtonOnKeyboard
        workDayTextField.keyboardType = .numberPad
        workDayTextField.textAlignment = .center
        workDayTextField.textColor = UIColor.white
        workDayTextField.backgroundColor = UIColor.systemIndigo
        workDayTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        restDayTextFields.inputAccessoryView = ViewForDoneButtonOnKeyboard
        restDayTextFields.keyboardType = .numberPad
        restDayTextFields.textAlignment = .center
        restDayTextFields.textColor = UIColor.white
        restDayTextFields.backgroundColor = UIColor.systemIndigo
        restDayTextFields.borderStyle = UITextField.BorderStyle.roundedRect
        
        
    }
    
    
    func addLabels() {
        let workDayLabel: UILabel = UILabel()
        let restDayLabel: UILabel = UILabel()
        let safeGuide = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(workDayLabel)
        self.view.addSubview(restDayLabel)
        workDayLabel.translatesAutoresizingMaskIntoConstraints = false
        restDayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        workDayLabel.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        restDayLabel.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: workDayLabel, attribute: .top, relatedBy: .equal, toItem: view!, attribute:.top, multiplier: 1, constant: 650),
            NSLayoutConstraint(item: workDayLabel, attribute: .leading, relatedBy: .equal, toItem: view!, attribute: .leading, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: restDayLabel, attribute: .top, relatedBy: .equal, toItem: view!, attribute:.top, multiplier: 1.0, constant: 650),
            NSLayoutConstraint(item: restDayLabel, attribute: .trailing, relatedBy: .equal, toItem: view!, attribute: .trailing, multiplier: 1, constant: -50)])
        
        workDayLabel.text = "Рабочие дни"
        workDayLabel.textAlignment = .center
        workDayLabel.textColor = UIColor.black
        
        restDayLabel.text = "Выходные дни"
        restDayLabel.textAlignment = .center
        restDayLabel.textColor = UIColor.black
        
    }
    
    func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
        let formatter = DateFormatter()
        let currentDateTime = Date()
        formatter.dateFormat = "MM-DD"
        let date1 = formatter.string(from: currentDateTime)
        let date2 = formatter.string(from: date as Date)
        return date1 == date2 ? 2 : 2
    }
    
    func addButton() {
        let safeGuide = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(showActualCalendar)
        showActualCalendar.translatesAutoresizingMaskIntoConstraints = false
        showActualCalendar.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        showActualCalendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: showActualCalendar, attribute: .top, relatedBy: .equal, toItem: view!, attribute: .top, multiplier: 1, constant: 800),
            NSLayoutConstraint(item: showActualCalendar, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 200)])
        
        showActualCalendar.setTitle("Рассчитать график", for: .normal)
        showActualCalendar.setTitleColor(.black, for: .normal)
        showActualCalendar.backgroundColor = UIColor.lightGray
        
    }
    
}

extension CalendarView: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        return "Вых"
        
    }
    
    
}
