//
//  SettingViewController.swift
//  ControlApp
//
//  Created by Влад Овсюк on 27.10.2020.
//

import UIKit

final class SettingViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var clearDataSwitch: UISwitch!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
    private var darkModeIsOn: Bool = UserDefaults.standard.bool(forKey: "darkModeIsOn")
    private var switchIsPressed: Bool = UserDefaults.standard.bool(forKey: "switchIsPressed")
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwitchOn()
        configureLogo()
    }
    
    // MARK: - Private Metod
    
    private func setSwitchOn() {
        if darkModeIsOn == true {
            darkModeSwitch.setOn(true, animated: false)
        } else {
            darkModeSwitch.setOn(false, animated: false)
        }
    }
    
    private func setupTheme() {
        if darkModeIsOn == true {
                NotificationCenter.default.post(name: .darkModeEnabled, object: nil)
            } else {
                NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
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
    
    @IBAction func darkModeSwitchTapped(_ sender: Any) {
        userDefaults.setValue(true, forKey: "switchIsPressed")
        userDefaults.setValue(darkModeSwitch.isOn, forKey: "switchButton")
        if darkModeSwitch.isOn == true {
            userDefaults.set(true, forKey: "darkModeIsOn")
            NotificationCenter.default.post(name: .darkModeEnabled, object: nil)
        } else {
            userDefaults.set(false, forKey: "darkModeIsOn")
            NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
        }
    }
    @IBAction func deleteAllData(_ sender: Any) {
        let alert = UIAlertController(title: "Подтвердите действие", message: "Вы уверены?",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Удалить всё",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        AffairManager.manager.clearData()
                                        self.clearDataSwitch.isOn = false
                                      }))
        alert.addAction(UIAlertAction(title: "Отмена",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
}
