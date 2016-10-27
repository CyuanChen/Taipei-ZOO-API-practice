//
//  DetailViewController.swift
//  HelloZoo
//
//  Created by PeterChen on 2016/10/26.
//  Copyright © 2016年 PeterChen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, URLSessionDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!

    @IBOutlet weak var animalName: UILabel!
    var thisAnimalDic: AnyObject?

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = (thisAnimalDic as! [String: AnyObject])["A_Pic01_URL"]
        if let url = url
        {
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let dataTask = session.downloadTask(with:URL(string: url as! String )!)
            // 啟動或重新啟動下載動作
            dataTask.resume()
            URLSessionFunc(session: session, downloadTask: dataTask, didFinishDownloadingToURL: URL(string: url as! String)!)
            
        }
        var test = (thisAnimalDic as! [String: AnyObject])["A_Feature"]
    
        if test == nil {
            print("change to interpretation")
            test = (thisAnimalDic as! [String: AnyObject])["A_Interpretation"]
        }
        detailDescriptionLabel.text = (string: test as? String)
        
        animalName.text = (string: (thisAnimalDic as! [String: AnyObject])["A_Name_Ch"] as? String)
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    func URLSessionFunc(session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: URL) {
        
            
            guard let data = NSData(contentsOf: location) else {
                return
            }
        
//            detailDescriptionLabel.text = data.description
            detailImage.image = UIImage(data: data as Data)
      
        
    }
    func URLSessionFunc2(session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: URL) {
        
        
        guard let data = NSData(contentsOf: location) else {
            return
        }
        
        detailDescriptionLabel.text = data.description
//        detailImage.image = UIImage(data: data as Data)
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

