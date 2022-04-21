//
//  TaskListCell.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 03/04/2022.
//

import UIKit

class TaskListCell: UITableViewCell
{
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var descLabel  : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func load(task: TaskModel) {
        self.titleLabel.text = task.title
        self.descLabel.text = task.description
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
