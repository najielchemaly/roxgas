//
//  NotificationsViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/19/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    let rowHeight: CGFloat = 45
    let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupTableView()
        self.getNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolbarView.labelTitle.text = "NOTIFICATIONS"
        self.toolbarView.buttonBack.isHidden = true
        self.toolbarView.buttonBackLeadingConstraint.constant = -20
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseObjects.notifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let text = DatabaseObjects.notifications[indexPath.row].title {
            let estimatedHeight = text.height(withConstrainedWidth: self.view.frame.width-(rowHeight*2), font: UIFont.systemFont(ofSize: 16))
//            estimatedHeight = estimatedHeight > rowHeight ? estimatedHeight : rowHeight
            return estimatedHeight+padding
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell") as? NotificationsTableViewCell {
            cell.selectionStyle = .none
            
            let notification = DatabaseObjects.notifications[indexPath.row]
            
            cell.labelDescription.text = notification.title
//            cell.labelTime.text = String(describing: indexPath.row) + " Days"
            
            return cell
        }
        
        return UITableViewCell()
    }

    func handleRefresh() {
        self.getNotifications(isRefreshing: true)
    }
    
    func getNotifications(isRefreshing: Bool = false) {
        if !isRefreshing {
            self.showWaitOverlay(color: Colors.appGreen)
        }
        
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getNotifications()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    DatabaseObjects.notifications = [Notification]()
                    if let jsonArray = response?.jsonArray {
                        for json in jsonArray {
                            let notification = Notification.init(dictionary: json)
                            DatabaseObjects.notifications.append(notification!)
                        }
                        
                        
                        self.tableView.reloadData()
                    }
                }
                
                if DatabaseObjects.notifications.count == 0 {
                    self.addEmptyLabel(text: "You have no Notifications yet.")
                } else {
                    self.removeEmptyLabel()
                }
                
                self.removeAllOverlays()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
