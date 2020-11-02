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
    
    @IBOutlet weak var todayDateButtonAsLabel: UIButton!
    @IBOutlet weak var titleSelectedDateLabel: UILabel!
    @IBOutlet weak var noAffairsLabel: UILabel!
    
    
    // MARK: - Private properties
    
    private var sideMenu: SideMenuNavigationController?
    
    // MARK: - Properties
    
    var selectedDate: [SelectedDateModel] = []
    
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
        startupConfigure()
        configureEmptyState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDateBarButtonItem()
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
    
    private func showAddAffairViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "AddAffairViewController") as! AddAffairViewController
        addChild(addAffairViewController)
        view.addSubview(addAffairViewController.view)
        addAffairViewController.didMove(toParent: self)
    }
    
    private func showSettingViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
        addChild(addAffairViewController)
        view.addSubview(addAffairViewController.view)
        addAffairViewController.didMove(toParent: self)
    }
    
    private func hideChildView() {
        if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
    }
    
    // MARK: - Private metod
    
    private func setDateBarButtonItem() {
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, E"
        formatter.timeZone = TimeZone(secondsFromGMT: 2)
        formatter.locale = Locale(identifier: "ru")
        let formattedDate = formatter.string(from: time as Date)
//        todayDateButtonAsLabel.setTitle("\(formattedDate)", for: .normal)
    }

    
    private func numberOfMondaysInMonth(month: Int, year: Int) {
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
            selectedDate.append(SelectedDateModel(weekdayInt: weekday, day: day, monthInt: month, year: year, dayIsSelected: false))
            if weekday >= 7 {
                weekday = 1
            } else {
                weekday += 1
            }
        }
    }
    
    private func startupConfigure() {
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        numberOfMondaysInMonth(month: month, year: year)
        setAffairForSelectDay(selectedDay: (SelectedDateModel(weekdayInt: 0, day: day, monthInt: month, year: year, dayIsSelected: false)))
        
        selectedDate[day - 1] = .init(weekdayInt: selectedDate[day - 1].weekdayInt, day: selectedDate[day - 1].day, monthInt: selectedDate[day - 1].monthInt, year: selectedDate[day - 1].year, dayIsSelected: true)
        setTitleSelectedDateLabel(selectedDate: SelectedDateModel(weekdayInt: weekday, day: day, monthInt: month, year: year, dayIsSelected: false))
    }
    
    private func setAffairForSelectDay(selectedDay: SelectedDateModel) {
        currentAffair.removeAll()
        affairs.forEach { affair in
            
            let affairDay = (day: affair.affairDate.day, month: affair.affairDate.month, year: affair.affairDate.year)
            let selectedDay = (day: selectedDay.day, month: selectedDay.monthInt, year: selectedDay.year)
            
            if affairDay == selectedDay {
                currentAffair.append(affair)
            }
        }
        tableView.reloadData()
    }
    
    private func resetSelectionCollectionView() {
        for index in 0...(selectedDate.count - 1){
            selectedDate[index] = .init(weekdayInt: selectedDate[index].weekdayInt, day: selectedDate[index].day, monthInt: selectedDate[index].monthInt, year: selectedDate[index].year, dayIsSelected: false)
        }
    }
    
    private func setTitleSelectedDateLabel(selectedDate: SelectedDateModel) {
        titleSelectedDateLabel.text = "\(selectedDate.weekdayStringLong(weekday: selectedDate.weekdayInt)), \(selectedDate.monthStringLong(month: selectedDate.monthInt)) \(selectedDate.day), \(selectedDate.year)"
    }
    
    private func configureEmptyState() {
        if currentAffair.isEmpty {
            noAffairsLabel.isHidden = false
            noAffairsLabel.text = "На сегодня дел нет"
        } else {
            noAffairsLabel.isHidden = true
        }
    }

    // MARK: - Action
    
    @IBAction func sideMenuTapped(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    
    @IBAction func plusBattonTapped(_ sender: Any) {
        tableView.reloadData()
        collectionView.reloadData()
        print("Table view and Collection View has been reloaded")
        print(selectedDate)
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
            
            tableView.reloadData()
        } else {
            
            currentAffair[indexPath.row] = .init(
                affairTitle: currentAffair[indexPath.row].affairTitle,
                affairDescription: currentAffair[indexPath.row].affairDescription,
                affairDate: currentAffair[indexPath.row].affairDate,
                affairTime: currentAffair[indexPath.row].affairTime,
                affaitIsDone: false)
            
            tableView.reloadData()
        }
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
        setAffairForSelectDay(selectedDay: selectedDate[indexPath.row])
        setTitleSelectedDateLabel(selectedDate: selectedDate[indexPath.row])
        
        resetSelectionCollectionView()
        selectedDate[indexPath.row] = .init(weekdayInt: selectedDate[indexPath.row].weekdayInt, day: selectedDate[indexPath.row].day, monthInt: selectedDate[indexPath.row].monthInt, year: selectedDate[indexPath.row].year, dayIsSelected: true)
        
        collectionView.reloadData()
        configureEmptyState()
    }
}


// MARK: - MenuTableViewControllerDelegate

extension ControlViewController: MenuTableViewControllerDelegate {
    func didSelectMenuItem(named: SideMenuItem) {
        
        sideMenu?.dismiss(animated: true, completion: nil)
        
        title = named.rawValue
        switch named {
        case .myAffairs:
            hideChildView()
        
        case .addAffair:
            hideChildView()
            showAddAffairViewController()
            
        case .setting:
            hideChildView()
            showSettingViewController()
        }
    }
}
