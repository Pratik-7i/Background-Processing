//
//  DownloadObject.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 04/07/2022.
//

import UIKit

class DownloadObject: NSObject 
{
    let title           : String
    let fileURL         : String
    let fileName        : String?
    let directoryName   : String?
    var index           : Int = 0
    var isDownloading   : Bool = false
    var progress        : Double = 0
    var isDownloaded    : Bool = false
    var progressBlock   : DownloadProgressBlock?
    var completionBlock : DownloadCompletionBlock?
    
    init(title: String, fileURL: String, fileName: String?, directoryName: String?, index: Int = 0)
    {
        self.title          = title
        self.fileURL        = fileURL
        self.fileName       = fileName
        self.directoryName  = directoryName
        self.index          = index
    }
}
