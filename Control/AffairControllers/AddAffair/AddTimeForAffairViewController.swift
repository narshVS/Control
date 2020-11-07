//
//  AddTimeForAffairViewController.swift
//  Control
//
//  Created by Влад Овсюк on 05.11.2020.
//

import UIKit

final class AddTimeForAffairViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var picker: UIDatePicker!
    
    // MARK: - Public Properties
    
    var affairForSave: Affair?
    
    var affairTitle: String = ""
    var affairDescription: String = ""
    var affairDay: Int = 0
    var affairMonth: Int = 0
    var affairYear: Int = 0
    var affairIsDone: Bool = false
    
    // MARK: - Private Properties
    
    private var affairHour: Int = 0
    private var affairMinute: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatePicker()
        setNowTime()
    }
    
    // MARK: - Private Metod

    private func configureDatePicker() {
        picker.datePickerMode = .time
        picker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
    }
    
    private func setNowTime() {
        let nowTime = Date().getDateComponents(.hour, .minute)
        affairHour = nowTime.hour ?? 00
        affairMinute = nowTime.minute ?? 00
    }

    // MARK: - Action
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "AddTimeUnwindSegue", sender: self)
    }
    
    @IBAction func pickerViewDidSelectRow(_ sender: Any) {
        let pickerDate = picker.date.getDateComponents(.hour, .minute)
        affairHour = pickerDate.hour ?? 00
        affairMinute = pickerDate.minute ?? 00
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controlViewController = segue.destination as? ControlViewController else { return }
        let date = Date().setDate(year: affairYear, month: affairMonth, day: affairDay, hour: affairHour, minute: affairMinute)
        controlViewController.affairManager.addAffair(title: affairTitle, descript: affairDescription, isDone: affairIsDone, dayAffair: date)
        controlViewController.configureAfterUnwind()
    }
}
