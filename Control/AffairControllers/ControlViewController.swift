//
//  ControlViewController.swift
//  ControlApp
//
//  Created by Влад Овсюк on 25.10.2020.
//

import UIKit
import SideMenu
import SwiftyGif

struct AffairModel {
    let affairTitle: String
    let affairDescription: String
    let affairDate: (day: Int, month: Int, year: Int, hour: Int, minut: Int)
    let affairTime: String
    let affaitIsDone: Bool
}

final class ControlViewController: UIViewController, SwiftyGifDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var datePicker: UIPickerView!
    
    @IBOutlet weak var titleSelectedDateLabel: UILabel!
    @IBOutlet weak var noAffairsLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - Private properties
    
    private var selectedMonth: [DateModel] = []
    private var affairs: [Affair] = []
    private var selectedAffairs: [Affair] = []
    
    private var selectedAffair: Affair?
    private var selectedDay: DateModel!
    
    private let pickerComponets: Int = 2
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Properties
    
    var sideMenu: SideMenuNavigationController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSystemTheme()
        configureStartupView()
        configureSideMenu()
//        add()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureDatePicker()
    }
    
    func add() {
            let affaairArray: [AffairModel] = [
                AffairModel(affairTitle: "Выгул собаки", affairDescription: "Взять пакеты", affairDate: (day: 16, month: 11, year: 2020, hour: 8, minut: 00), affairTime: "8:00", affaitIsDone: false),
                AffairModel(affairTitle: "Привести себя в порядок", affairDescription: "Паста RDA 150", affairDate: (day: 16, month: 11, year: 2020, hour: 9, minut: 00),  affairTime: "9:00", affaitIsDone: false),
                AffairModel(affairTitle: "Закрыть квартиру", affairDescription: "Оставить ключ на вахте", affairDate: (day: 16, month: 11, year: 2020, hour: 9, minut: 30),  affairTime: "9:30", affaitIsDone: false),
                AffairModel(affairTitle: "Купить кофе", affairDescription: "Латте без сахара", affairDate: (day: 16, month: 11, year: 2020, hour: 09, minut: 45), affairTime: "9:45", affaitIsDone: false),
                AffairModel(affairTitle: "Заказать домой воду", affairDescription: "Попросить оставить на входе", affairDate: (day: 16, month: 11, year: 2020, hour: 10, minut: 20),  affairTime: "10:20", affaitIsDone: false),
                AffairModel(affairTitle: "Созвон", affairDescription: "Успеть до дедлайна", affairDate: (day: 16, month: 11, year: 2020, hour: 12, minut: 00), affairTime: "12:00", affaitIsDone: false),
                AffairModel(affairTitle: "Поздравить Алену", affairDescription: "Пожалуйста не забудь", affairDate: (day: 16, month: 11, year: 2020, hour: 13, minut: 00),  affairTime: "13:00", affaitIsDone: false),
                AffairModel(affairTitle: "Заказать цветы", affairDescription: "51 роза", affairDate: (day: 16, month: 11, year: 2020, hour: 13, minut: 10), affairTime: "13:10", affaitIsDone: false),
                AffairModel(affairTitle: "Купить вино", affairDescription: "Красное полусладкое", affairDate: (day: 16, month: 11, year: 2020, hour: 18, minut: 10), affairTime: "18: 10", affaitIsDone: false)]
            
            for affair in affaairArray {
                let date = Date().setDate(year: affair.affairDate.year, month: affair.affairDate.month, day: affair.affairDate.day, hour: affair.affairDate.hour, minute: affair.affairDate.minut)
                AffairManager.manager.addAffair(title: affair.affairTitle, descript: affair.affairDescription, isDone: false, dayAffair: date)
            }
        }
    
    // MARK: - Public Metod
    
    func saveSelectAffairSegue(affair: Affair) {
        selectedAffair = affair
        performSegue(withIdentifier: "SelectedAffairTapped", sender: self)
    }
    
    func configureAfterUnwind() {
        loadDataAffair()
        setAffairForSelectDate(selectDate: selectedDay)
        sortAffair()
        setCircleForSelectedDay(selectDay: selectedDay)
        tableView.reloadData()
    }
    
    func configureTheme() {
        if userDefaults.bool(forKey: "themeSwitchWasPressed") == true {
            userDefaults.bool(forKey: "darkModeIsOn") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        }
        
        if userDefaults.bool(forKey: "themeIsReset") == true {
            userDefaults.bool(forKey: "systemThemeIsDark") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        }
    }
    
    func configureLogo() {
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
    
    // MARK: - Private metod
    
    private func loadDataAffair() {
        AffairManager.manager.fetchAffairs { [weak self] affairs in
            self?.affairs = affairs
        }
    }
    
    private func configureStartupView() {
        configureTheme()
        configureLogo()
        loadDataAffair()
        setTitleSelectedDateLabel(selectedDate: DateHelper.date.getTodaysDate())
        getArrayDates(month: DateHelper.date.getTodaysDate().month, year: DateHelper.date.getTodaysDate().year)
        setAffairForSelectDate(selectDate: DateHelper.date.getTodaysDate())
        setCircleForSelectedDay(selectDay: DateHelper.date.getTodaysDate())
        scrollToTodayCollectionView(day: DateHelper.date.getTodaysDate())
        sortAffair()
        configureEmptyState()
    }
    
    private func setTitleSelectedDateLabel(selectedDate: DateModel) {
        titleSelectedDateLabel.text = "\(ChangeTypeHelper.changeType.weekdayIntToStringLong(weekday: selectedDate.weekdayInt)), \(ChangeTypeHelper.changeType.monthIntToStringLong(month: selectedDate.month)) \(selectedDate.day), \(selectedDate.year)"
    }
    
    private func getArrayDates(month: Int, year: Int) {
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let calendar = NSCalendar.current
        let date = calendar.date(from: dateComponents as DateComponents)!
        
        let dayInMonth = calendar.range(of: .day, in: .month, for: date)!
        let firstWeekdayinMonth = calendar.component(.weekday, from: date)
        
        var weekday = firstWeekdayinMonth
        
        selectedMonth.removeAll()
        for day in dayInMonth {
            selectedMonth.append(DateModel(weekdayInt: weekday,
                                           day: day,
                                           month: month,
                                           year: year,
                                           hour: 0,
                                           minute: 0,
                                           dayIsSelected: false))
            if weekday >= 7 {
                weekday = 1
            } else {
                weekday += 1
            }
        }
    }
    
    private func setAffairForSelectDate(selectDate: DateModel) {
        selectedDay = selectDate
        selectedAffairs.removeAll()
        affairs.forEach { affair in
            let date = affair.dateAffair?.getDateComponents(.day, .month, .year)
            let affairDay = (day: date?.day, month: date?.month, year: date?.year)
            let selectedDay = (day: selectDate.day, month: selectDate.month, year: selectDate.year)
            
            if affairDay == selectedDay {
                selectedAffairs.append(affair)
            }
        }
    }
    
    private func configureEmptyState() {
        if selectedAffairs.isEmpty {
            noAffairsLabel.isHidden = false
            noAffairsLabel.text = "На сегодня дел нет"
        } else {
            noAffairsLabel.isHidden = true
        }
    }
    
    private func sortAffair() {
        selectedAffairs.sort{
            if $0.dateAffair?.getDateInt(.hour) == $1.dateAffair?.getDateInt(.hour) {
                return ($0.dateAffair?.getDateInt(.minute))! < ($1.dateAffair?.getDateInt(.minute))!
            }
            return ($0.dateAffair?.getDateInt(.hour))! < ($1.dateAffair?.getDateInt(.hour))!
        }
    }
    
    private func hidePicker() {
        datePicker.isHidden = true
    }
    
    private func setSystemTheme() {
        self.traitCollection.userInterfaceStyle == .dark ? (userDefaults.setValue(true, forKey: "systemThemeIsDark")) : (userDefaults.setValue(false, forKey: "systemThemeIsDark"))
        userDefaults.setValue(false, forKey: "themeIsReset")
    }
    
    // MARK: - SideMenu Metods
    
    private func configureSideMenu() {
        let storybord = UIStoryboard(name: "Control", bundle: .main)
        let menuController = storybord.instantiateViewController(identifier: "MenuTableViewController") as! MenuTableViewController
        menuController.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menuController)
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: true)
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
    }
    
    func showSettingViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
        addChild(addAffairViewController)
        view.addSubview(addAffairViewController.view)
        addAffairViewController.didMove(toParent: self)
    }
    
    func showForewordViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "ForewordViewController") as! ForewordViewController
        addChild(addAffairViewController)
        view.addSubview(addAffairViewController.view)
        addAffairViewController.didMove(toParent: self)
    }
    
    func hideChildView() {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
    }
    
    // MARK: - Collection View Metod
    
    private func setCircleForSelectedDay(selectDay: DateModel) {
        resetSelectCellCollectionView()
        
        selectedMonth[selectDay.day - 1] = .init(
            weekdayInt: selectedMonth[selectDay.day - 1].weekdayInt,
            day: selectedMonth[selectDay.day - 1].day,
            month: selectedMonth[selectDay.day - 1].month,
            year: selectedMonth[selectDay.day - 1].year,
            hour: selectedMonth[selectDay.day - 1].hour,
            minute: selectedMonth[selectDay.day - 1].minute,
            dayIsSelected: true)
    }
    
    private func resetSelectCellCollectionView() {
        for date in selectedMonth {
            if date.dayIsSelected == true {
                selectedMonth[date.day - 1] = .init(weekdayInt: selectedMonth[date.day - 1].weekdayInt,
                                                    day: selectedMonth[date.day - 1].day,
                                                    month: selectedMonth[date.day - 1].month,
                                                    year: selectedMonth[date.day - 1].year,
                                                    hour: selectedMonth[date.day - 1].hour,
                                                    minute: selectedMonth[date.day - 1].minute,
                                                    dayIsSelected: false)
            }
        }
    }
    
    private func scrollToTodayCollectionView(day: DateModel) {
        let indexPath = IndexPath(item: day.day - 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
    
    // MARK: - Picker Metod
    
    private func configureDatePicker() {
        datePicker.delegate = self
        datePicker.dataSource = self
        setDafaultRowForPicker()
        DateHelper.date.configue()
    }
    
    private func setDafaultRowForPicker() {
        let todayDate = DateHelper.date.getTodaysDate()
        datePicker.selectRow(todayDate.month - 1, inComponent: 0, animated: true)
        datePicker.selectRow(1, inComponent: 1, animated: true)
    }
    
    // MARK: - Action
    
    @IBAction func setDateTapped(_ sender: Any) {
        datePicker.isHidden ? (datePicker.isHidden = false) : (datePicker.isHidden = true)
    }
    
    
    @IBAction func sideMenuTapped(_ sender: Any) {
        hidePicker()
        present(sideMenu!, animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        hidePicker()
    }
    
    @IBAction func unwindControlViewController(_ sender: UIStoryboardSegue) {  }
    
    // MARK: - Segue Action
    
    @IBSegueAction func settingAffairTapped(_ coder: NSCoder) -> SelectedAffair? {
        hidePicker()
        let controller = SelectedAffair(coder: coder)
        controller?.affair = selectedAffair
        return controller
    }
    
    // MARK: - Override View Controller
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configureLogo()
        }
    }
}


// MARK: - UITableView

extension ControlViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedAffairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AffairCell.reusableId, for: indexPath) as! AffairCell
        cell.configure(with: selectedAffairs[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hidePicker()
        if selectedAffairs[indexPath.row].isDone == false {
            AffairManager.manager.exchangeAffair(object: selectedAffairs[indexPath.row], title: selectedAffairs[indexPath.row].title!, descript: selectedAffairs[indexPath.row].descript!, isDone: true, dayAffair: selectedAffairs[indexPath.row].dateAffair!)
        } else {
            AffairManager.manager.exchangeAffair(object: selectedAffairs[indexPath.row], title: selectedAffairs[indexPath.row].title!, descript: selectedAffairs[indexPath.row].descript!, isDone: false, dayAffair: selectedAffairs[indexPath.row].dateAffair!)
        }
        loadDataAffair()
        setAffairForSelectDate(selectDate: selectedDay)
        sortAffair()
        tableView.reloadData()
    }
}

// MARK: - UICollectionView

extension ControlViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AffairCollectionViewCell.reusableId, for: indexPath) as! AffairCollectionViewCell
        cell.configure(with: selectedMonth[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hidePicker()
        selectedDay = selectedMonth[indexPath.row]
        setTitleSelectedDateLabel(selectedDate: selectedMonth[indexPath.row])
        setAffairForSelectDate(selectDate: selectedMonth[indexPath.row])
        setCircleForSelectedDay(selectDay: selectedMonth[indexPath.row])
        scrollToTodayCollectionView(day: selectedMonth[indexPath.row])
        sortAffair()
        configureEmptyState()
        
        tableView.reloadData()
        collectionView.reloadData()
    }
}

// MARK: - UIPickerView

extension ControlViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerComponets
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return DateHelper.date.monthSourse.count
        }
        return DateHelper.date.yearSourse.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = DateHelper.date.monthSourse[pickerView.selectedRow(inComponent: 0)]
        let year = DateHelper.date.yearSourse[pickerView.selectedRow(inComponent: 1)]
        
        let dateFromPicker = DateModel(weekdayInt: DateHelper.date.firstWeekdayinMonth(month: ChangeTypeHelper.changeType.monthStringToInd(month: month),
                                       year: year),
                                       day: 1,
                                       month: ChangeTypeHelper.changeType.monthStringToInd(month: month),
                                       year: year,
                                       hour: 0,
                                       minute: 0,
                                       dayIsSelected: true)
        
        setTitleSelectedDateLabel(selectedDate: dateFromPicker)
        getArrayDates(month: ChangeTypeHelper.changeType.monthStringToInd(month: month), year: year)
        setAffairForSelectDate(selectDate: dateFromPicker)
        setCircleForSelectedDay(selectDay: dateFromPicker)
        configureEmptyState()
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return DateHelper.date.monthSourse[row]
        }
        return "\(DateHelper.date.yearSourse[row])"
    }
}
