//
//  TaskModel.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 03/04/2022.
//

import Foundation

final class TaskModel
{
    var title       : String = ""
    var description : String = ""
    var segueId     : String = ""
    
    init(title: String, description: String, segueId: String) {
        self.title = title
        self.description = description
        self.segueId = segueId
    }
}
