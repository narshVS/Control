//
//  AddDateForAffairViewController.swift
//  Control
//
//  Created by Влад Овсюк on 05.11.2020.
//

import UIKit

final class AddDateForAffairViewController: UIViewController {
    
    @IBOutlet weak var picker: UIPickerView!
    
    var titleText: String = ""
    var descriptionText: String = ""
    
    private let pickerComponets = 3
    
    
    private let monthSourse: Array<String> = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    private var yearSourse: Array<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatePicker()
    }
    
    private func configureDatePicker() {
        picker.delegate = self
        picker.dataSource = self
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - UIPickerView

extension AddDateForAffairViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerComponets
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return monthSourse.count
        } else if component == 1 {
            return monthSourse.count
        }
        return monthSourse.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let month = monthSourse[pickerView.selectedRow(inComponent: 0)]
//        let year = yearSourse[pickerView.selectedRow(inComponent: 1)]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return monthSourse[row]
        } else if component == 1 {
            return monthSourse[row]
        }
        return "\(monthSourse[row])"
    }
}
