//
//  DownloadObject.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 04/07/2022.
//

import UIKit

class DownloadObject: NSObject 
{
    var title           : String?
    var fileURL         : String
    var fileName        : String?
    var directoryName   : String?
    var index           : Int = 0
    var isDownloading   : Bool = false
    var progress        : Double = 0
    var isDownloaded    : Bool = false
    var progressBlock   : DownloadProgressBlock?
    var completionBlock : DownloadCompletionBlock?
    
    init(title: String? = nil, fileURL: String, fileName: String? = nil, directoryName: String? = nil, index: Int = 0)
    {
        self.title          = title
        self.fileURL        = fileURL
        self.fileName       = fileName
        self.directoryName  = directoryName
        self.index          = index
    }
}
