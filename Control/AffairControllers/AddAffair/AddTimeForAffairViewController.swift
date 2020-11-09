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
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - Public Properties
    
    var affairForSave: Affair?
    
    var affairTitle: String = ""
    var affairDescription: String = ""
    var affairDay: Int = 0
    var affairMonth: Int = 0
    var affairYear: Int = 0
    var affairIsDone: Bool = false
    
    // MARK: - Private Properties
    
    private var darkModeIsOn: Bool = UserDefaults.standard.bool(forKey: "darkModeIsOn")
    private var switchIsPressed: Bool = UserDefaults.standard.bool(forKey: "switchIsPressed")
    
    private var affairHour: Int = 0
    private var affairMinute: Int = 0
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimePicker()
        setNowTime()
        configureTheme()
        configureLogo()
    }
    
    // MARK: - Private Metod

    private func configureTimePicker() {
        picker.datePickerMode = .time
        picker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
    }
    
    private func setNowTime() {
        let nowTime = Date().getDateComponents(.hour, .minute)
        affairHour = nowTime.hour ?? 00
        affairMinute = nowTime.minute ?? 00
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let date = Date().setDate(year: affairYear, month: affairMonth, day: affairDay, hour: affairHour, minute: affairMinute)
        AffairManager.manager.addAffair(title: affairTitle, descript: affairDescription, isDone: affairIsDone, dayAffair: date)
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
        controlViewController.configureAfterUnwind()
    }
}
