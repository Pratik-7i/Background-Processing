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
 
    lazy var arrTaskList : [TaskModel] = {
        return [TaskModel.init(title: "Background Fetch", description: "Launch your App in the background to execute a short refresh task.", segueId: "listToBGFetch"),
                TaskModel.init(title: "Background Processing", description: "A time-consuming processing task that runs while the app is in the background.", segueId: "listToBGProcessing"),
                TaskModel.init(title: "Background Downloading", description: "Downloading files in the background while your App is inactive.", segueId: "listToBGDownload")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupControls()
    }
    
    func setupControls() {
        self.title = "Task list"
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

