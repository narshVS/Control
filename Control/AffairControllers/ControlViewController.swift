//
//  ControlViewController.swift
//  ControlApp
//
//  Created by Влад Овсюк on 25.10.2020.
//

import UIKit
import SideMenu

final class ControlViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var datePicker: UIPickerView!
    
    @IBOutlet weak var titleSelectedDateLabel: UILabel!
    @IBOutlet weak var noAffairsLabel: UILabel!
    
    // MARK: - Helpers
    
    private let changeType = ChangeTypeHelper()
    
    // MARK: - Private properties
    
    private let monthSourse: Array<String> = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    private var yearSourse: Array<Int> = []
    private let pickerComponets = 2
    
    // MARK: - Properties
    
    var sideMenu: SideMenuNavigationController?
    
    var selectedDate: [DateModel] = []
    
    var currentAffair: [AffairModel] = []
    var affairs: [AffairModel] = [
        AffairModel(affairTitle: "День 1", affairDescription: "Тест", affairDate: (day: 1, month: 11, year: 2020), affairTime: "8:00", affaitIsDone: false),
        AffairModel(affairTitle: "День 2", affairDescription: "Тест", affairDate: (day: 2, month: 11, year: 2020), affairTime: "8:00", affaitIsDone: false),
        AffairModel(affairTitle: "День 3", affairDescription: "Тест", affairDate: (day: 3, month: 11, year: 2020), affairTime: "8:00", affaitIsDone: false),
        AffairModel(affairTitle: "Выгул собаки", affairDescription: "Взять пакеты", affairDate: (day: 13, month: 11, year: 2020), affairTime: "8:00", affaitIsDone: false),
        AffairModel(affairTitle: "Привести себя в порядок", affairDescription: "Паста RDA 150", affairDate: (day: 13, month: 11, year: 2020),  affairTime: "9:00", affaitIsDone: false),
        AffairModel(affairTitle: "Закрыть квартиру", affairDescription: "Оставить ключ на вахте", affairDate: (day: 13, month: 11, year: 2020),  affairTime: "9:30", affaitIsDone: false),
        AffairModel(affairTitle: "Купить кофе", affairDescription: "Латте без сахара", affairDate: (day: 13, month: 11, year: 2020),  affairTime: "9:45", affaitIsDone: false),
        AffairModel(affairTitle: "Заказать домой воду", affairDescription: "Попросить оставить на входе", affairDate: (day: 13, month: 11, year: 2020),  affairTime: "10:20", affaitIsDone: false),
        AffairModel(affairTitle: "Созвон", affairDescription: "Успеть до дедлайна", affairDate: (day: 13, month: 11, year: 2020),  affairTime: "12:00", affaitIsDone: false),
        AffairModel(affairTitle: "Поздравить Алену", affairDescription: "Пожалуйста не забудь", affairDate: (day: 13, month: 11, year: 2020),  affairTime: "13:00", affaitIsDone: false),
        AffairModel(affairTitle: "Заказать цветы", affairDescription: "51 роза", affairDate: (day: 13, month: 11, year: 2020),  affairTime: "13:10", affaitIsDone: false),
        AffairModel(affairTitle: "Купить вино", affairDescription: "Красное полусладкое", affairDate: (day: 13, month: 11, year: 2020),  affairTime: "18: 10", affaitIsDone: false)]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSideMenu()
        configureStartupView()
        configureDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setDafaultRowForPicker()
        scrollToTodayCollectionView()
    }
    
    // MARK: - Metods for Side Menu
    
    private func configureSideMenu() {
        let storybord = UIStoryboard(name: "Control", bundle: .main)
        let menuController = storybord.instantiateViewController(identifier: "MenuTableViewController") as! MenuTableViewController
        menuController.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menuController)
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: true)
    }
    
    func showAddAffairViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "AddAffairViewController") as! AddAffairViewController
        addChild(addAffairViewController)
        view.addSubview(addAffairViewController.view)
        addAffairViewController.didMove(toParent: self)
    }
    
    func showSettingViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
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
    
    // MARK: - Picker metod
    
    private func configureDatePicker() {
        let todayDate = getTodaysDate()
        datePicker.delegate = self
        datePicker.dataSource = self
        setYearSourseForPicker(year: todayDate.year)
    }
    
    private func setYearSourseForPicker(year: Int) {
        yearSourse.append(year - 1)
        yearSourse.append(year)
        yearSourse.append(year + 1)
    }
    
    private func setDafaultRowForPicker() {
        let todayDate = getTodaysDate()
        datePicker.selectRow(todayDate.monthInt - 1, inComponent: 0, animated: true)
        datePicker.selectRow(1, inComponent: 1, animated: true)
    }
    
    // MARK: - Private metod
    
    func getTodaysDate() -> DateModel {
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let retunrDate = DateModel(weekdayInt: weekday, day: day, monthInt: month, year: year, dayIsSelected: true)
        return retunrDate
    }
    
    private func configureStartupView() {
        setTitleSelectedDateLabel(selectedDate: getTodaysDate())
        configueArrayDates(month: getTodaysDate().monthInt, year: getTodaysDate().year)
        setAffairForSelectDate(selectDate: getTodaysDate())
        setSelectedDayInCollectionView(selectDay: getTodaysDate())
        configureEmptyState()
    }
    
    private func setTitleSelectedDateLabel(selectedDate: DateModel) {
        titleSelectedDateLabel.text = "\(changeType.weekdayStringLong(weekday: selectedDate.weekdayInt)), \(changeType.monthStringLong(month: selectedDate.monthInt)) \(selectedDate.day), \(selectedDate.year)"
    }
    
    private func configueArrayDates(month: Int, year: Int) {
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let calendar = NSCalendar.current
        let date = calendar.date(from: dateComponents as DateComponents)!
        
        let dayInMonth = calendar.range(of: .day, in: .month, for: date)!
        let firstWeekdayinMonth = calendar.component(.weekday, from: date)
        
        var weekday = firstWeekdayinMonth
        
        selectedDate.removeAll()
        for day in dayInMonth {
            selectedDate.append(DateModel(weekdayInt: weekday, day: day, monthInt: month, year: year, dayIsSelected: false))
            if weekday >= 7 {
                weekday = 1
            } else {
                weekday += 1
            }
        }
    }
    
    private func setAffairForSelectDate(selectDate: DateModel) {
        currentAffair.removeAll()
        for affair in affairs {
            let affairDay = (day: affair.affairDate.day, month: affair.affairDate.month, year: affair.affairDate.year)
            let selectedDay = (day: selectDate.day, month: selectDate.monthInt, year: selectDate.year)
            
            if affairDay == selectedDay {
                currentAffair.append(affair)
            }
        }
    }
    
    private func firstWeekdayinMonth(month: Int, year: Int) -> Int{
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let calendar = NSCalendar.current
        let date = calendar.date(from: dateComponents as DateComponents)!
        
        let firstWeekdayinMonth = calendar.component(.weekday, from: date)
        return firstWeekdayinMonth
    }
    
    private func configureEmptyState() {
        if currentAffair.isEmpty {
            noAffairsLabel.isHidden = false
            noAffairsLabel.text = "На сегодня дел нет"
        } else {
            noAffairsLabel.isHidden = true
        }
    }
    
    private func setSelectedDayInCollectionView(selectDay: DateModel) {
        resetSelectCellCollectionView()
        
        selectedDate[selectDay.day - 1] = .init(
            weekdayInt: selectedDate[selectDay.day - 1].weekdayInt,
            day: selectedDate[selectDay.day - 1].day,
            monthInt: selectedDate[selectDay.day - 1].monthInt,
            year: selectedDate[selectDay.day - 1].year,
            dayIsSelected: true)
    }
    
    private func resetSelectCellCollectionView() {
        for date in selectedDate {
            if date.dayIsSelected == true {
                selectedDate[date.day - 1] = .init(weekdayInt: selectedDate[date.day - 1].weekdayInt, day: selectedDate[date.day - 1].day, monthInt: selectedDate[date.day - 1].monthInt, year: selectedDate[date.day - 1].year, dayIsSelected: false)
            }
        }
    }
    
    private func scrollToTodayCollectionView() {
        let todayDate = getTodaysDate()
        let indexPath = IndexPath(item: todayDate.day - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }

    // MARK: - Action
    
    @IBAction func setDateTapped(_ sender: Any) {
        datePicker.isHidden ? (datePicker.isHidden = false) : (datePicker.isHidden = true)
    }
    
    
    @IBAction func sideMenuTapped(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    
    @IBAction func plusBattonTapped(_ sender: Any) {
        collectionView.reloadData()
    }
    
    @IBSegueAction func selectedListSegue(_ coder: NSCoder) -> SelectedAffair? {
        let controller = SelectedAffair(coder: coder)
        return controller
    }
}

// MARK: - UITableView

extension ControlViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentAffair.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AffairCell.reusableId, for: indexPath) as! AffairCell
        cell.configure(with: currentAffair[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            affairs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                tableView.reloadData()
            })
        }
        configureEmptyState()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentAffair[indexPath.row].affaitIsDone == false {
            currentAffair[indexPath.row] = .init(
                affairTitle: currentAffair[indexPath.row].affairTitle,
                affairDescription: currentAffair[indexPath.row].affairDescription,
                affairDate: currentAffair[indexPath.row].affairDate,
                affairTime: currentAffair[indexPath.row].affairTime, affaitIsDone: true)
        } else {
            currentAffair[indexPath.row] = .init(
                affairTitle: currentAffair[indexPath.row].affairTitle,
                affairDescription: currentAffair[indexPath.row].affairDescription,
                affairDate: currentAffair[indexPath.row].affairDate,
                affairTime: currentAffair[indexPath.row].affairTime,
                affaitIsDone: false)
        }
        tableView.reloadData()
    }
}

// MARK: - UICollectionView

extension ControlViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedDate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AffairCollectionViewCell.reusableId, for: indexPath) as! AffairCollectionViewCell
        cell.configure(with: selectedDate[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setTitleSelectedDateLabel(selectedDate: selectedDate[indexPath.row])
        setAffairForSelectDate(selectDate: selectedDate[indexPath.row])
        setSelectedDayInCollectionView(selectDay: selectedDate[indexPath.row])
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
            return monthSourse.count
        }
        return yearSourse.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = monthSourse[pickerView.selectedRow(inComponent: 0)]
        let year = yearSourse[pickerView.selectedRow(inComponent: 1)]
        
        let dateFromPicker = DateModel(weekdayInt: firstWeekdayinMonth(month: changeType.monthStringToInd(month: month), year: year),
                                       day: 1,
                                       monthInt: changeType.monthStringToInd(month: month),
                                       year: year,
                                       dayIsSelected: true)
        
        setTitleSelectedDateLabel(selectedDate: dateFromPicker)
        configueArrayDates(month: changeType.monthStringToInd(month: month), year: year)
        setAffairForSelectDate(selectDate: dateFromPicker)
        setSelectedDayInCollectionView(selectDay: dateFromPicker)
        configureEmptyState()
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return monthSourse[row]
        }
        return "\(yearSourse[row])"
    }
}
