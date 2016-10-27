//
//  MasterViewController.swift
//  HelloZoo
//
//  Created by PeterChen on 2016/10/26.
//  Copyright © 2016年 PeterChen. All rights reserved.
//

import UIKit


class MasterViewController: UITableViewController, URLSessionDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    var dataArray = [AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 建立台北市動物園公開資料
        //https://jsonplaceholder.typicode.com/todos/1
//        http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613
        let todoEndpoint: String = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL ")
            return
        }
        
        let urlRequest = URLRequest(url : url)
        let config = URLSessionConfiguration.default
        // 建立一般的Session設定
        let session = URLSession(configuration: config)
        let dataTask = session.downloadTask(with: url)
        // 啟動或重新啟動下載動作
        dataTask.resume()
        
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            self.detailViewController = (controllers[controllers.count -1 ] as UINavigationController).topViewController as DetailViewController
//            
//        }

        
        func URLSessionFunc(session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: URL) {
            
            do {
                
                //JSON資料處理
                let dataDic = try JSONSerialization.jsonObject(with: Data(contentsOf: location), options: []) as! [String:[String:AnyObject]]
                //依據先前觀察的結構，取得result對應中的results所對應的陣列
                dataArray = dataDic["result"]!["results"] as! [AnyObject]
                
                //重新整理Table View
                self.tableView.reloadData()
                
            } catch {
                print("Error!")
            }
            
        }
        
                URLSessionFunc(session: session, downloadTask: dataTask, didFinishDownloadingToURL: url)
        
        let task = session.dataTask(with: urlRequest, completionHandler:{ (data,response, error) in
            //check for any error
            guard error == nil else {
                print("error calling GET on zoo data")
                print(error)
                return
            }
            
            // make sure we got the data
            guard let responseData = data else {
                print("Did not receive data")
                return
            }
            
            // parse the result as JSON, since that what the API provides
            do {
                
                
                
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("Error try convert data to JSON")
                    return
                    
                }
                
                //JSON資料處理
                let dataDic = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String:[String:AnyObject]]
                //依據先前觀察的結構，取得result對應中的results所對應的陣列
                self.dataArray = dataDic["result"]!["results"] as! [AnyObject]
//                print(self.dataArray.count)
//                print("description" + self.dataArray.description)

                
                
                // we have todo, let just print it to prove it works
//                print("The zoo data is: " + todo.description)
//                print("The zoo data is aaa: " + self.dataArray["result"])
                
                
               
                
                
                
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        })
        
        task.resume()
        
        
        
        
       
        
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // 取得被選中的動物的資料
                let object = dataArray[indexPath.row]
                //設定在第二個畫面控制器中的資料為這一隻動物的資料
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.thisAnimalDic = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

//        let object = objects[indexPath.row] as! NSDate
        cell.textLabel?.text = dataArray[indexPath.row]["A_Name_Ch"] as? String
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

