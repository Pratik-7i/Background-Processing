//
//  BGDownloadVC.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 04/07/2022.
//

import UIKit

class BGDownloadVC: UIViewController
{
    @IBOutlet weak var videosTableView : UITableView!
    var arrDownloads: [DownloadObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupControls()
        self.checkDownloads()
    }
    
    func setupControls() {
        self.title = "Video Library"
    }
    
    func checkDownloads()
    {
        for (index, dic) in arrURLs.enumerated()
        {
            guard let title = dic["title"] as? String, let fileURL = dic["url"] as? String else { continue }
            let fileName = (fileURL as NSString).lastPathComponent
            var download = DownloadObject(title: title, fileURL:fileURL, fileName: fileName, directoryName: VideosDirectory, index: index)
            
            let downloadStatus = DownloadManager.shared.isDownloadInProgress(forUniqueKey: fileURL)
            if downloadStatus.isInProcess {
                if let downloadObject = downloadStatus.downloadObject {
                    download = downloadObject
                    self.assignBlocks(to: download)
                }
            }
            download.isDownloaded = Helper.fileExists(fileName, directory: VideosDirectory)
            self.arrDownloads.append(download)
        }
        self.videosTableView.reloadData()
    }
    
    func downloadVideo(at index: Int) {
        let download = self.arrDownloads[index]
        DownloadManager.shared.downloadFile(download)
        self.assignBlocks(to: download)
    }
    
    func deleteVideo(at index: Int) {
        let download = self.arrDownloads[index]
        Helper.removeFileFromCache(fileName: download.fileName ?? "") { isRemoved in
            if isRemoved {
                download.isDownloaded = false
                self.videosTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    func assignBlocks(to download: DownloadObject) {
        download.progressBlock = { progress in
            self.videosTableView.reloadRows(at: [IndexPath(row: download.index, section: 0)], with: .none)
        }
        download.completionBlock = { error in
            self.videosTableView.reloadRows(at: [IndexPath(row: download.index, section: 0)], with: .none)
        }
    }
}

extension BGDownloadVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDownloads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: VideoListCell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as! VideoListCell
        cell.load(self.arrDownloads[indexPath.row])
        
        cell.downloadButtonTapped = { [weak self] sender in
            guard let strongSelf = self else { return }
            strongSelf.downloadVideo(at: indexPath.row)
        }
        cell.deletedButtonTapped = { [weak self] sender in
            guard let strongSelf = self else { return }
            strongSelf.deleteVideo(at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let download = self.arrDownloads[indexPath.row]
        if !download.isDownloaded { return }
        Helper.playVideo(url: download.fileURL, vc: self)
    }
}
