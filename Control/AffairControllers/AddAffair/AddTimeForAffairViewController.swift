//
//  AddTimeForAffairViewController.swift
//  Control
//
//  Created by Влад Овсюк on 05.11.2020.
//

import UIKit

final class AddTimeForAffairViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Public Properties
    
    var affairForSave: Affair?
    
    var affairTitle: String = ""
    var affairDescription: String = ""
    var affairDay: Int = 0
    var affairMonth: Int = 0
    var affairYear: Int = 0
    var affairIsDone: Bool = false
    
    // MARK: - Private Properties
    
    private var affairManager: AffairManager = AffairManager()
    
    private let pickerComponets: Int = 2
    private var hoursSource: Array<Int> = []
    private var minutesSource: Array<Int> = []
    
    private var affairHour: Int = 0
    private var affairMinute: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addArrayTime()
        configureDatePicker()
        setCurrentTime()
    }
    
    // MARK: - Private Metod
    
    private func addArrayTime() {
        for hour in 0...23 {
            hoursSource.append(hour)
        }
        for minute in 0...59 {
            minutesSource.append(minute)
        }
    }
    
    private func configureDatePicker() {
        picker.delegate = self
        picker.dataSource = self
        setDafaultRowForPicker()
    }
    
    private func setDafaultRowForPicker() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        picker.selectRow(hour, inComponent: 0, animated: true)
        picker.selectRow(minute, inComponent: 1, animated: true)
    }
    
    private func setCurrentTime() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        timeLabel.text = "\(hour):\(minute)"
    }
    
    private func setTimeLabel() {
        timeLabel.text = "\(affairHour):\(affairMinute)"
    }

    private func saveAffair() {
        let date = Date().setDate(year: affairYear, month: affairMonth, day: affairDay, hour: affairHour, minute: affairMinute)
        affairManager.addAffair(title: affairTitle, descript: affairDescription, isDone: affairIsDone, dayAffair: date)
    }
    
    // MARK: - Action
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveAffair()
        performSegue(withIdentifier: "ControlUnwindSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controlViewController = segue.destination as? ControlViewController else { return }
        controlViewController.configureAfterUnwind()
    }
}

// MARK: - UIPickerView

extension AddTimeForAffairViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerComponets
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hoursSource.count
        }
        return minutesSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hour = hoursSource[pickerView.selectedRow(inComponent: 0)]
        let minute = minutesSource[pickerView.selectedRow(inComponent: 1)]
        timeLabel.text = "\(hour):\(minute)"
        affairHour = hour
        affairMinute = minute
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(hoursSource[row])"
        }
        return "\(minutesSource[row])"
    }
}
