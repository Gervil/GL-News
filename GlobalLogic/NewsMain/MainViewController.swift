//
//  ViewController.swift
//  GlobalLogic
//
//  Created by Gerardo Villarroel on 22-06-22.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //Controles
    @IBOutlet weak var mProgressBar: UIActivityIndicatorView!
    @IBOutlet weak var mMasterTableView: UITableView!
    
    //Variables
    var mNewsDatas = [NewsData]()
    var mRefreshControl: UIRefreshControl!
    var mNewsSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl()
        getApiData()
    }
    
    //MARK: Refresh
    func addRefreshControl() {
        mRefreshControl = UIRefreshControl()
        mRefreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        self.mMasterTableView.addSubview(mRefreshControl)
    }
    
    @objc func refreshList() {
        if !Util.checkInternetAccess() {
            endRefreshing()
            present(Messages.errorConnection(), animated: true, completion: nil)
            return
        }
        mNewsDatas.removeAll()
        mMasterTableView.reloadData()
        mNewsSelected = 0
        getApiData()
    }
    
    func endRefreshing() {
        if self.mRefreshControl != nil {
            self.mRefreshControl.endRefreshing()
        }
    }

    //----------------------------------------------------------------------------------------------
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mNewsDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NewsCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MainTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        let data = mNewsDatas[indexPath.row]
        cell.newsImage.downloaded(from: URL(string: data.image)!)
        cell.newsTitle.text = data.title
        cell.newsDescription.text = data.description

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !Util.checkInternetAccess() {
            self.present(Messages.errorConnection(), animated: true, completion: nil)
            return
        }
        mNewsSelected = indexPath.row
        self.performSegue(withIdentifier: "NewsDetail", sender: self)
    }
    
    //----------------------------------------------------------------------------------------------
    //MARK: Get Api data
    func getApiData() {
        showProgress(true)
        
        //Check internet connection
        if !Util.checkInternetAccess() {
            self.present(Messages.errorConnection(), animated: true, completion: nil)
            showProgress(false)
            endRefreshing()
            return
        }
        
        //Url request
        let request = Util.cloudConnect(api_url: ApiConnection.NEWS_API, parms: "")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            OperationQueue.main.addOperation {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? NSArray
                    self.getData(jsonResponse!)
                    self.dispatch()
                    
                } catch _ {
                    self.endRefreshing()
                    return
                }
                self.showProgress(false)
            }
        }
        task.resume()
    }

    //MARK: Data extractor
    func getData(_ data: NSArray) {
        var newsImage = "", newsTitle = "", newsDescription = ""
        
        for item in data {
            let data = item as! NSDictionary
            newsImage = data.value(forKey: "image") as? String ?? ""
            newsTitle = data.value(forKey: "title") as? String ?? ""
            newsDescription = data.value(forKey: "description") as? String ?? ""
            
            if !newsImage.isEmpty && !newsTitle.isEmpty && !newsDescription.isEmpty {
                let news = NewsData(image: newsImage, title: newsTitle, description: newsDescription)!
                self.mNewsDatas.append(news)
            }
        }
    }
    
    //Show news
    func dispatch() {
        DispatchQueue.main.async {
            if self.mMasterTableView != nil {
                self.endRefreshing()
                self.mMasterTableView.reloadData()
            }
        }
    }
    
    //Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "NewsDetail" {
            if let destination = segue.destination as? DetailViewController {
                destination.mImage = mNewsDatas[mNewsSelected].image
                destination.mTitle = mNewsDatas[mNewsSelected].title
                destination.mDescription = mNewsDatas[mNewsSelected].description
            }
        }
    }
    
    //ShowProgress
    func showProgress(_ show: Bool) {
        mProgressBar.isHidden = !show
        mMasterTableView.isHidden = show
    }
}
