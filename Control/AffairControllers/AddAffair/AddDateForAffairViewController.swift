//
//  AddDateForAffairViewController.swift
//  Control
//
//  Created by Влад Овсюк on 05.11.2020.
//

import UIKit

final class AddDateForAffairViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - Public Properties
    
    var affairTitleText = ""
    var affairDescriptionText = ""
    
    // MARK: - Private Properties
    
    private let pickerComponets: Int = 3
    private var selectedMonth: String = ""
    
    private var darkModeIsOn: Bool = UserDefaults.standard.bool(forKey: "darkModeIsOn")
    private var switchIsPressed: Bool = UserDefaults.standard.bool(forKey: "switchIsPressed")
    
    private var affairDay: Int = DateHelper.date.getTodaysDate().day
    private var affairMonth: Int = DateHelper.date.getTodaysDate().month
    private var affairYear: Int = DateHelper.date.getTodaysDate().year
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatePicker()
        configureTheme()
        configureLogo()
    }
    
    // MARK: - Private Metod
    
    private func configureDatePicker() {
        picker.delegate = self
        picker.dataSource = self
        setDafaultRowForPicker()
    }
    
    private func setDafaultRowForPicker() {
        picker.selectRow(DateHelper.date.getTodaysDate().day - 1, inComponent: 0, animated: true)
        picker.selectRow(DateHelper.date.getTodaysDate().month - 1, inComponent: 1, animated: true)
        picker.selectRow(1, inComponent: 2, animated: true)
    }
    
    private func configureTheme() {
        if switchIsPressed == true {
            darkModeIsOn == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        }
    }
    
    private func configureLogo() {
        if self.traitCollection.userInterfaceStyle == .light  {
            do {
            let gif = try UIImage(gifName: "controlLogoWhite.gif")
                self.logoImageView.setGifImage(gif, loopCount: -1) }
            catch {
                print("Ooops, loading error!")
            }
        } else {
            do {
            let gif = try UIImage(gifName: "controlLogoClear.gif")
                self.logoImageView.setGifImage(gif, loopCount: -1) }
            catch {
                print("Ooops, loading error!")
            }
        }
    }
    
    // MARK: - Action
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectDateButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "AddTimeForAffair", sender: self)
    }
    
    // MARK: - Segue Action
    
    @IBSegueAction func segueAddTimeForAffairViewController(_ coder: NSCoder) -> AddTimeForAffairViewController? {
        let controller = AddTimeForAffairViewController(coder: coder)
        controller?.affairTitle = affairTitleText
        controller?.affairDescription = affairDescriptionText
        controller?.affairDay = affairDay
        controller?.affairMonth = affairMonth
        controller?.affairYear = affairYear
        return controller
    }
}

// MARK: - UIPickerView

extension AddDateForAffairViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerComponets
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return DateHelper.date.daySourse.count
        } else if component == 1 {
            return DateHelper.date.monthSourse.count
        }
        return DateHelper.date.yearSourse.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let day = DateHelper.date.daySourse[pickerView.selectedRow(inComponent: 0)]
        let monthString = DateHelper.date.monthSourse[pickerView.selectedRow(inComponent: 1)]
        let monthInt = ChangeTypeHelper.changeType.monthStringToInd(month: monthString)
        let year = DateHelper.date.yearSourse[pickerView.selectedRow(inComponent: 2)]
        
        if selectedMonth != monthString {
            DateHelper.date.setDaySourseForPicker(month: monthInt, year: year)
            pickerView.reloadAllComponents()
        }
        selectedMonth = monthString
        affairDay = day
        affairMonth = monthInt
        affairYear = year
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(DateHelper.date.daySourse[row])"
        } else if component == 1 {
            return DateHelper.date.monthSourse[row]
        }
        return "\(DateHelper.date.yearSourse[row])"
    }
}
