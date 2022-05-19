//
//  VideoListCell.swift
//  BG Processing
//
//  Created by Pratik Prajapati on 04/07/2022.
//

import UIKit
import AVFoundation

class VideoListCell: UITableViewCell
{
    @IBOutlet var videoTitleLabel : UILabel!
    @IBOutlet var progressView    : UIProgressView!
    @IBOutlet var downloadButton  : UIButton!
    @IBOutlet var deletedButton   : UIButton!
    @IBOutlet var downloadedView  : UIView!
    @IBOutlet var downloadedLabel : UILabel!
    @IBOutlet var thumbImageView  : UIImageView!

    var downloadButtonTapped : ((UIButton)->())? = nil
    var deletedButtonTapped  : ((UIButton)->())? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func load(_ download: DownloadObject)
    {
        self.videoTitleLabel.text = download.title
        
        if download.isDownloading {
            self.downloadButton.isHidden = true
            self.deletedButton.isHidden = true
            self.downloadedView.isHidden = true
            self.progressView.isHidden = false
            self.progressView.progress = Float(download.progress)
        } else {
            self.downloadButton.isHidden = download.isDownloaded
            self.deletedButton.isHidden = !download.isDownloaded
            self.downloadedView.isHidden = false
            self.downloadedLabel.text = download.isDownloaded ? "Downloaded" : "Download to play"
            self.progressView.isHidden = true
        }
        
        /*
        if let url = URL(string: download.fileURL) {
            Helper.getThumbnailImageFromVideoUrl(url: url) { thumbImage in
                self.thumbImageView.image = thumbImage
            }
        }*/
    }
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        self.downloadButtonTapped?(sender)
    }
    
    @IBAction func deletedButtonTapped(_ sender: UIButton) {
        self.deletedButtonTapped?(sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
