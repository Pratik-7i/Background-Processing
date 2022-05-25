//
//  TaskListVC.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 03/04/2022.
//

import UIKit

class TaskListVC: UIViewController
{
    @IBOutlet var listTableView: UITableView!
    
    @IBOutlet weak var stackViewDarkMode : UIStackView!
    @IBOutlet weak var viewSwitch : UIView!
    var switchTheme: DayNightModeSwitcher!
    
    lazy var arrTaskList : [TaskModel] = {
        return [TaskModel.init(title: "Background Fetch", description: "Launch your app in the background to execute a short refresh task.", segueId: "listToBGFetch"),
                TaskModel.init(title: "Background Processing", description: "A time-consuming processing task that runs while the app is in the background.", segueId: "listToBGProcessing"),
                TaskModel.init(title: "Background Notifications", description: "Deliver notifications that wake your app and allow you to perform non-UI operations in the background.", segueId: "listToBGNotification"),
                TaskModel.init(title: "Background Extension", description: "Extend app’s background execution time to ensure that critical tasks finish even if app moves to background.", segueId: "listToBGExtension"),
                TaskModel.init(title: "Background Downloading", description: "Downloading files in the background while your app is inactive.", segueId: "listToBGDownload"),
                TaskModel.init(title: "Background Audio Playback", description: "Playing audio files even if app moves to background.", segueId: "listToBGAudioPlayback")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addThemeSwitch()
        self.updateSwitchMode()
        self.setupControls()
    }
    
    func setupControls() {
        self.title = "Task list"
    }
    
    // MARK: - Manage light/dark mode
    
    func addThemeSwitch() {
        if #available(iOS 13.0, *) {
            self.stackViewDarkMode.isHidden = false
            self.switchTheme = DayNightModeSwitcher(frame: CGRect(x: 0, y: 0, width: self.viewSwitch.bounds.width, height: self.viewSwitch.bounds.height))
            self.switchTheme.fallingStarDelay = 3
            self.switchTheme.delegate = self
            self.viewSwitch.addSubview(self.switchTheme)
        }
        else {
            self.stackViewDarkMode.isHidden = true
        }
    }
    
    func updateSwitchMode() {
        if #available(iOS 13.0, *) {
            let currentMode = AppDel.window?.traitCollection.userInterfaceStyle
            let mode: TypeOfSwitcher = (currentMode == .dark) ? .night : .day
            self.switchTheme.set(to: mode, animated: true)
        }
    }
}

extension TaskListVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTaskList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TaskListCell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath) as! TaskListCell
        cell.load(task: self.arrTaskList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: self.arrTaskList[indexPath.row].segueId, sender: nil)
    }
}

extension TaskListVC: DayNightModeSwitcherDelegate
{
    func switcher(_ switcher: DayNightModeSwitcher, didChangeValueTo value: TypeOfSwitcher) {
        if #available(iOS 13.0, *) {
            UIView.animate(withDuration: 1, animations: {
                AppDel.window?.alpha = 0
            }) { completed in
                self.updateMode(value == .night ? .dark : .light)
                UIView.animate(withDuration: 1.2, animations: {
                    AppDel.window?.alpha = 1
                })
            }
        }
    }
    
    @available(iOS 13.0, *)
    func updateMode(_ mode: UIUserInterfaceStyle) {
        AppDel.window?.overrideUserInterfaceStyle = mode
        self.setNeedsStatusBarAppearanceUpdate()
        Helper.saveDefultsBool(mode == .dark, key: Key.isDarkMode)
    }
}
