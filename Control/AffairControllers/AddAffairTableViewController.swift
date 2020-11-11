//
//  AddAffairTableViewController.swift
//  Control
//
//  Created by Влад Овсюк on 10.11.2020.
//

import UIKit

class AddAffairTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    // MARK: - Outlet
    
    @IBOutlet weak var affairTitleTextField: UITextField!
    @IBOutlet weak var affairDescriptionTextView: UITextView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var timeCell: UITableViewCell!
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
    
    private var affairHour: Int = 0
    private var affairMinute: Int = 0
    private var affairDay: Int = 0
    private var affairMonth: Int = 0
    private var affairYear: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        configureTextView()
        configureTheme()
        configureLogo()
        configureTimePicker()
        configureDatePicker()
        setTodayDataForAffairDate()
        configureGestureRecognizerForHideKeyboard()
    }
    
    // MARK: - Private Metod
    
    private func configureTextField() {
        affairTitleTextField.delegate = self
        affairTitleTextField.autocapitalizationType = .sentences
    }
    
    
    private func configureTextView() {
        affairDescriptionTextView.delegate = self
        affairDescriptionTextView.text = "Описание"
        affairDescriptionTextView.textColor = UIColor.placeholderText
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Поле не заполнено", message: "Пожалуйста введите событие",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Выход",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func configureTheme() {
        if userDefaults.bool(forKey: "themeSwitchWasPressed") == true {
            userDefaults.bool(forKey: "darkModeIsOn") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
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
    
    private func configureTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
    }
    
    private func configureDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale(localeIdentifier: "ru") as Locale
    }
    
    private func setTodayDataForAffairDate() {
        let dateModel = DateHelper.date.getTodaysDate()
        affairHour = dateModel.day
        affairMinute = dateModel.minute
        affairDay = dateModel.day
        affairMonth = dateModel.month
        affairYear = dateModel.year
    }
    
    private func configureGestureRecognizerForHideKeyboard() {
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(dismissKeyboardGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if affairDescriptionTextView.textColor == UIColor.placeholderText {
            affairDescriptionTextView.text = nil
            affairDescriptionTextView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if affairDescriptionTextView.text.isEmpty {
            affairDescriptionTextView.text = "Описание"
            affairDescriptionTextView.textColor = UIColor.placeholderText
        }
    }
    
    // MARK: - Action
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectTextButtonTapped(_ sender: Any) {
        if affairTitleTextField.text!.isEmpty {
            showAlert()
        } else {
            let affairDate = Date().setDate(year: affairYear, month: affairMonth, day: affairDay, hour: affairHour, minute: affairMinute)
            AffairManager.manager.addAffair(title: affairTitleTextField.text!, descript: affairDescriptionTextView.text, isDone: false, dayAffair: affairDate)
            performSegue(withIdentifier: "AddAffairUnwindSegue", sender: self)
        }
    }
    
    @IBAction func timePickerViewDidSelectRow(_ sender: Any) {
        let timePickerDate = timePicker.date.getDateComponents(.hour, .minute)
        affairHour = timePickerDate.hour!
        affairMinute = timePickerDate.minute!
    }
    
    @IBAction func datePickerViewDidSelectRow(_ sender: Any) {
        let datePickerDate = datePicker.date.getDateComponents(.day, .month, .year)
        affairDay = datePickerDate.day!
        affairMonth = datePickerDate.month!
        affairYear = datePickerDate.year!
    }
    
    // MARK: - Override View Controller
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configureLogo()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controlViewController = segue.destination as? ControlViewController else { return }
        controlViewController.configureAfterUnwind()
    }
}
