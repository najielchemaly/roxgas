//
//  HistoryViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/16/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var viewYear: UIView!
    @IBOutlet weak var textFieldYear: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var pickerView: UIPickerView!
//    var years: NSMutableArray!
    
    var filteredHistory: [History] = [History]()
    var pickerHistory: [History] = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupTableView()
//        self.setupPickerView()
        self.getHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolbarView.labelTitle.text = "HISTORY"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHistory(isRefreshing: Bool = false) {
        if !isRefreshing {
            self.showWaitOverlay(color: Colors.appGreen)
        }
        
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getHistory()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    DatabaseObjects.histories = [History]()
                    if let jsonArray = response?.jsonArray {
                        for json in jsonArray {
                            let history = History.init(dictionary: json)
                            DatabaseObjects.histories.append(history!)
                            self.setupPickerView()
                        }
                    }
                }
                
                var seenType:[String:Bool] = [:]
                self.pickerHistory = DatabaseObjects.histories.filter {
                    seenType.updateValue(false, forKey: $0.year!) ?? true
                }
                
                self.filteredHistory = DatabaseObjects.histories
                self.filteredHistory = self.filteredHistory.filter { $0.year?.lowercased() == self.textFieldYear.text?.lowercased() }
                self.tableView.reloadData()
                
                if self.filteredHistory.count == 0 {
                    self.addEmptyLabel(text: "You have no history yet.")
                    self.viewYear.isHidden = true
                } else {
                    self.removeEmptyLabel()
                    self.viewYear.isHidden = false
                }
                
                self.removeAllOverlays()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func initializeViews() {
        self.viewYear.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
        self.tableView.register(UINib.init(nibName: "HistoryDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryDetailTableViewCell")
        self.tableView.register(UINib.init(nibName: "HistoryFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryFooterTableViewCell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.viewYear.isHidden = true
        
        self.refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
    }
    
    @objc func handleRefresh() {
        self.getHistory(isRefreshing: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let history = self.filteredHistory[section]
        if let products = history.products {
            return products.count+2
        }
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filteredHistory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }
        
        let history = filteredHistory[indexPath.section]
        if let products = history.products {
            if history.isExpanded == nil || history.isExpanded! {
                return 0
            }
            
            return CGFloat(products.count)*20
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let history = filteredHistory[indexPath.section]
        history.isExpanded = history.isExpanded == nil ? false : !history.isExpanded!
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as? HistoryTableViewCell {
                
                let history = self.filteredHistory[indexPath.section]

                if history.title == nil || history.title == "" {
                    cell.labelDescription.text = "Order"
                } else {
                    cell.labelDescription.text = history.title
                }
                if let orderNumber = history.order_nb {
                    cell.labelOrderNumber.text = "Order Number: " + orderNumber
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat  = "yyyy-MM-dd"
                let date = dateFormatter.date(from: history.date!)
                dateFormatter.dateFormat = "dd.LLL.yyyy"
                if let date = date {
                    let strDate = dateFormatter.string(from: date)
                    let dateArray = strDate.characters.split{$0 == "."}.map(String.init)
                    let day = dateArray[0]
                    cell.labelDay.text = day
                    let month = dateArray[1]
                    cell.labelMonth.text = month
                }
                
                return cell
            }
        } else if indexPath.row == (filteredHistory[indexPath.section].products?.count)!+1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryFooterTableViewCell") as? HistoryFooterTableViewCell {
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = false
                
                cell.labelTotalAmount.text = getTotalAmount(section: indexPath.section)
                
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryDetailTableViewCell") as? HistoryDetailTableViewCell {
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = false
                
                let history = self.filteredHistory[indexPath.section]
                let product = history.products![indexPath.row-1]
                
                cell.labelProduct.text = product.title
                if let quantity = product.quantity {
                    cell.labelQty.text = String(describing: quantity)
                }
                if let price = product.price {
                    cell.labelAmount.text = String(describing: price)
                }
 
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func getTotalAmount(section: Int) -> String {
        let history = filteredHistory[section]
        var amount = 0
        if let products = history.products {
            for product in products {
                if let price = product.price {
                    amount += price
                }
            }
        }
        
        return "LBP " + String(describing: amount)
    }
    
    func setupPickerView() {
//        self.years = getYears()
        if self.pickerView == nil {
            self.pickerView = UIPickerView()
            self.pickerView.delegate = self
            self.textFieldYear.inputView = self.pickerView
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
            toolbar.sizeToFit()
            toolbar.barStyle = .default
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissKeyboard))
            cancelButton.tintColor = Colors.appGreen
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
            doneButton.tintColor = Colors.appGreen
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            toolbar.items = [cancelButton, flexibleSpace, doneButton]
            
            self.textFieldYear.inputAccessoryView = toolbar
            
            if let history = DatabaseObjects.histories.first {
                self.textFieldYear.text = history.year
            }
        }
    }
    
    @objc func doneButtonTapped() {
        if pickerHistory.count > 0 {
            let row = self.pickerView.selectedRow(inComponent: 0)
            let history = pickerHistory[row]
            self.textFieldYear.text = history.year
            
            self.filteredHistory = self.filteredHistory.filter { $0.year?.lowercased() == self.textFieldYear.text?.lowercased() }
            self.tableView.reloadData()
        }
        
        self.dismissKeyboard()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerHistory.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let year = String(describing: pickerHistory[row].year!)
        return year
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
