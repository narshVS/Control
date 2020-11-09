//
//  SelectedAffair.swift
//  ControlApp
//
//  Created by Влад Овсюк on 31.10.2020.
//

import UIKit

final class SelectedAffair: UIViewController, UITextViewDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var viewForExite: UIView!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - Public Properties
    
    var affair: Affair?
    
    // MARK: - Public Properties
    
    private var darkModeIsOn: Bool = UserDefaults.standard.bool(forKey: "darkModeIsOn")
    private var switchIsPressed: Bool = UserDefaults.standard.bool(forKey: "switchIsPressed")
    private var checkBoxState: Bool?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configueView()
        configureDatePicker()
        configureViewForExite()
        setDafaultDateForPicker()
        configureCheckBoxButton()
        configureTheme()
        configureLogo()
    }
    
    // MARK: - Private Metod
    
    private func configueView() {
        setDateOnLabel()
        setTimeOnLabel()
        configureTimeLabel()
        configureTextField()
        configureTextView()
    }
    
    private func setDateOnLabel() {
        let day = affair?.dateAffair?.getDateInt(.day)
        let monthInt = affair?.dateAffair?.getDateInt(.month)
        let monthString = "\(ChangeTypeHelper.changeType.monthIntToStringLong(month: monthInt!))"
        let year = affair?.dateAffair?.getDateInt(.year)
        let weedayInt = affair?.dateAffair?.getDateInt(.weekday)
        let weekdayString = "\(ChangeTypeHelper.changeType.weekdayIntToStringLong(weekday: weedayInt!))"
        dateLabel.text = "\(weekdayString), \(monthString) \(day!), \(year!)"
    }
    
    private func configureTimeLabel() {
        timeLabel.layer.borderWidth = 1.0
        timeLabel.layer.cornerRadius = 5
        timeLabel.layer.borderColor = UIColor.placeholderText.cgColor
    }
    
    private func setTimeOnLabel() {
        let hour = "\(ChangeTypeHelper.changeType.hourShortToLong(date: (affair?.dateAffair)!))"
        let minute = "\(ChangeTypeHelper.changeType.minuteShortToLong(date: (affair?.dateAffair)!))"
        timeLabel.text = "\(hour):\(minute)"
    }
    
    private func configureTextField() {
        titleTextField.text = affair?.title
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.cornerRadius = 5
        titleTextField.layer.borderColor = UIColor.placeholderText.cgColor
    }
    
    private func configureTextView() {
        descriptionTextView.text = affair?.descript
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.placeholderText.cgColor
        descriptionTextView.layer.cornerRadius = 7
        textViewDidEndEditing(descriptionTextView)
    }
    
    private func configureCheckBoxButton() {
        checkBoxState = affair?.isDone
        setCheckBox()
    }
    
    private func configureDatePicker() {
        picker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
    }
    
    private func configureViewForExite() {
        viewForExite.layer.cornerRadius = 3
        checkBoxState = affair?.isDone
    }
    
    private func setCheckBox() {
        if checkBoxState == true {
            checkBoxButton.setBackgroundImage(UIImage(named: "checkBoxOn"), for: .normal)
        } else {
            checkBoxButton.setBackgroundImage(UIImage(named: "checkBoxOff"), for: .normal)
        }
    }
    
    private func setDafaultDateForPicker() {
        picker.date = (affair?.dateAffair)!
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
    
    // MARK: - Override View Controller
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.placeholderText {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Описание"
            descriptionTextView.textColor = UIColor.placeholderText
        }
    }
    
    // MARK: - Action
    @IBAction func checkBoxTapped(_ sender: Any) {
        if checkBoxState == true {
            checkBoxState = false
        } else {
            checkBoxState = true
        }
        setCheckBox()
    }
    
    @IBAction func deleteAffair(_ sender: Any) {
        AffairManager.manager.deleteAffair(object: affair!)
        performSegue(withIdentifier: "SelectedAffairUnwindSegue", sender: self)
    }
    
    @IBAction func savaAffair(_ sender: Any) {
        AffairManager.manager.exchangeAffair(object: affair!, title: titleTextField.text!, descript: descriptionTextView.text, isDone: checkBoxState!, dayAffair: (affair?.dateAffair)!)
        performSegue(withIdentifier: "SelectedAffairUnwindSegue", sender: self)
    }
    
    @IBAction func pickerViewDidSelectRow(_ sender: Any) {
        affair?.dateAffair = picker.date
        setDateOnLabel()
        setTimeOnLabel()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controlViewController = segue.destination as? ControlViewController else { return }
        controlViewController.configureAfterUnwind()
    }
}
