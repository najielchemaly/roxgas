//
//  PurchaseViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/17/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class PurchaseViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewDeliveryDate: UIView!
    @IBOutlet weak var textFieldDeliveryDate: UITextField!
    @IBOutlet weak var viewDeliveryTime: UIView!
    @IBOutlet weak var textFieldDeliverTime: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var viewPaymentMethod: UIView!
    @IBOutlet weak var textFieldPaymentMethod: UITextField!
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var textFieldTotal: UITextField!
    @IBOutlet weak var buttonOrderNow: UIButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonAddProduct: UIButton!
    @IBOutlet weak var labelDeliveryCharge: UILabel!
    
    var timePicker: UIDatePicker!
    var datePicker: UIDatePicker!
    var productsPickerView: UIPickerView!
    var paymentMethodPickerView: UIPickerView!
    var selectedTextField: UITextField!
    var orders: [Order] = [Order]()
    var refillOrders: [Order] = [Order]()
    var selectedPickerViewRow: Int = 0
    var totalAmount = 0
    
    let rowHeight: CGFloat = 35
    let scrollViewPadding: CGFloat = 100
    
    var deliveryCharge = DeliveryCharge()
    var viewDidAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addEmptyProduct()
        self.setupTableView()
        self.setupPickerView()
        self.setupDataPicker()
        self.fillInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolbarView.labelTitle.text = "PURCHASE"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonOrderNowTapped(_ sender: Any) {
        if isValidData() {
            if DatabaseObjects.user.phone == nil || DatabaseObjects.user.phone == "" {
                let alert = UIAlertController(title: nil, message: "Please enter your phone number to proceed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
                    self.redirectToVC(storyboardId: StoryboardIds.EditProfileViewController, type: .Push)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: nil, message: "Are you sure you want to send this order?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
                    self.showWaitOverlay(color: Colors.appGreen)
                    DispatchQueue.global(qos: .background).async {
                        let response = Services.init().checkPendingOrders()
                        if response?.status == ResponseStatus.SUCCESS.rawValue {
                            self.proceedOrder()
                        } else {
                            if let message = response?.message {
                                DispatchQueue.main.async {
                                    self.showAlert(message: message, style: .alert)
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.removeEmptyLabel()
                        }
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
    }
    
    @IBAction func buttonAddProductTapped(_ sender: Any) {
        self.addEmptyProduct()
        self.tableView.reloadData()
        
        self.tableViewHeightConstraint.constant = (rowHeight * CGFloat(self.orders.count))
        
        self.selectedPickerViewRow = 0
    }
    
    func proceedOrder() {
        self.showWaitOverlay(color: Colors.appGreen)
        
        let sendOrder = SendOrder.init()
        sendOrder.deliveryDate = self.textFieldDeliveryDate.text
        sendOrder.deliveryTime = self.textFieldDeliverTime.text
        sendOrder.addressId = self.textFieldLocation.text
        sendOrder.paymentMethod = self.textFieldPaymentMethod.text
        sendOrder.totalAmount = self.textFieldTotal.text?.replacingOccurrences(of: "LBP ", with: "")
        let order = Order(id: self.deliveryCharge.id, qty: 1)
        if let price = self.deliveryCharge.price {
            order.price = price
        }
        if let title = self.deliveryCharge.title {
            order.name = title
        }
        orders.append(order)
        orders.append(contentsOf: refillOrders)
        sendOrder.order = orders
        
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().sendOrder(sendOrder: sendOrder)
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    self.orders = [Order]()
                    confirmationType = ConfirmationType.Purchase.rawValue
                    self.redirectToVC(storyboardId: StoryboardIds.ConfirmationViewController, type: .Push)
                } else {
                    if let message = response?.message {
                        self.showAlert(message: message, style: .alert)
                    }
                }
                
                self.removeAllOverlays()
            }
        }
    }
    
    func addEmptyProduct() {
        let order = Order.init(id: nil, qty: 1)
        self.orders.append(order)
    }
    
    func initializeViews() {
        self.viewDeliveryDate.addBottomBorderWithColor(color: Colors.appGreen.withAlphaComponent(0.5), width: 1)
        self.viewDeliveryTime.addBottomBorderWithColor(color: Colors.appGreen.withAlphaComponent(0.5), width: 1)
        self.viewLocation.addBottomBorderWithColor(color: Colors.appGreen.withAlphaComponent(0.5), width: 1)
        self.viewPaymentMethod.addBottomBorderWithColor(color: Colors.appGreen.withAlphaComponent(0.5), width: 1)
        self.viewTotal.addBottomBorderWithColor(color: Colors.appGreen.withAlphaComponent(0.5), width: 1)
        
        if !viewDidAppear {
            self.scrollView.contentSize.height += scrollViewPadding
            self.viewDidAppear = true
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as? ProductTableViewCell {
            cell.selectionStyle = .none
            
            cell.labelLeftBottomBorder.backgroundColor = Colors.appGreen
            cell.labelRightBottomBorder.backgroundColor = Colors.appGreen
            
            cell.buttonDecreaseQty.tag = indexPath.row
            cell.buttonDecreaseQty.addTarget(self, action: #selector(buttonDecreaseQtyTapped(sender:)), for: .touchUpInside)
            
            cell.buttonIncreaseQty.tag = indexPath.row
            cell.buttonIncreaseQty.addTarget(self, action: #selector(buttonIncreaseQtyTapped(sender:)), for: .touchUpInside)
            
            cell.textFieldProductName.delegate = self
            cell.textFieldProductName.tag = indexPath.row
            self.setupPickerView(textField: cell.textFieldProductName)
            
            let order = orders[indexPath.row]
            cell.textFieldProductName.text = order.name
            
            if let qty = order.qty {
                cell.textFieldProductQty.text = String(describing: qty)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if self.orders.count > 1 {
                if self.orders[indexPath.row].id?.lowercased() == "cylinder" {
                    self.refillOrders.removeLast()
                }
                self.orders.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                self.tableViewHeightConstraint.constant = rowHeight * CGFloat(self.orders.count)

                tableView.reloadData()
                
                self.calculateTotalAmount()
            } else {
                self.showAlert(message: "You must have at least one product", style: .alert)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }
    
    func setupDataPicker() {
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .date
        self.datePicker.minimumDate = Date.init()
        self.textFieldDeliveryDate.inputView = self.datePicker
        
        self.timePicker = UIDatePicker()
        self.timePicker.datePickerMode = .time
        self.textFieldDeliverTime.inputView = self.timePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appGreen
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appGreen
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]

        self.textFieldDeliveryDate.inputAccessoryView = toolbar
        self.textFieldDeliverTime.inputAccessoryView = toolbar
    }
    
    func setupPickerView(textField: UITextField) {
        self.productsPickerView = UIPickerView()
        self.productsPickerView.delegate = self
        self.productsPickerView.tag = 2
        textField.inputView = self.productsPickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appGreen
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appGreen
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        
        textField.inputAccessoryView = toolbar
    }
    
    func setupPickerView() {
        self.paymentMethodPickerView = UIPickerView()
        self.paymentMethodPickerView.delegate = self
        self.paymentMethodPickerView.tag = 1
        self.textFieldPaymentMethod.inputView = self.paymentMethodPickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appGreen
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appGreen
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        
        self.textFieldPaymentMethod.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        if textFieldDeliveryDate.isFirstResponder {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.textFieldDeliveryDate.text = dateFormatter.string(from: datePicker.date)
        } else if textFieldDeliverTime.isFirstResponder {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            self.textFieldDeliverTime.text = timeFormatter.string(from: timePicker.date)
            
//            let calendar = Calendar.autoupdatingCurrent
//            let components = calendar.dateComponents([.hour, .minute], from: timePicker.date)
//            var time:CGFloat = 0
//            if let hour = components.hour, let minute = components.minute {
//                time = CGFloat(hour) + CGFloat(minute)/60
//            }
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat  = "EEEE"
//            let weekDay = dateFormatter.string(from: datePicker.date)
//
//            if isWorkingHour(weekDay: weekDay, time: time) {
//                let timeFormatter = DateFormatter()
//                timeFormatter.dateFormat = "hh:mm a"
//                self.textFieldDeliverTime.text = timeFormatter.string(from: timePicker.date)
//            } else {
//                self.textFieldDeliverTime.text = ""
//                self.showAlert(title: "Dear Customer", message: "Our working hours are from 8 AM till 5 PM on weekdays and from 8 AM till 1 PM on Saturday", style: .alert)
//            }
        } else if textFieldPaymentMethod.isFirstResponder {
            textFieldPaymentMethod.text = paymentMethods[self.selectedPickerViewRow]
        } else {
            let index = self.selectedTextField.tag
            let product = DatabaseObjects.products[self.selectedPickerViewRow]
            if let price = product.price {
                self.orders[index].price = price
            }
            if let title = product.title {
                self.orders[index].name = title
                
                self.selectedTextField.text = title
            }
            if let id = product.id {
                self.orders[index].id = id
                
                if id.lowercased() == "cylinder" {
                    self.addRefillOrder()
                }
            }
            
            self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
            
            self.calculateTotalAmount()
        }
        
        self.dismissKeyboard()
    }
    
    func isWorkingHour(weekDay: String, time: CGFloat) -> Bool {
        if weekDay.lowercased() == "sunday" {
            return false
        }
        
        if weekDay.lowercased() == "saturday" && (time < 8 || time > 13) {
            return false
        }
        
        if time < 8 || time > 17 {
            return false
        }
        
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return paymentMethods.count
        } else {
            return DatabaseObjects.products.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return paymentMethods[row]
        } else {
            return DatabaseObjects.products[row].title
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedPickerViewRow = row
    }
    
    @objc func buttonIncreaseQtyTapped(sender: UIButton) {
        let row = sender.tag
        if let cell = tableView.cellForRow(at: IndexPath.init(row: row, section: 0)) as? ProductTableViewCell {
            var productQty = 0
            if let qty = self.orders[row].qty {
                productQty = qty
            }
            
            productQty += 1
            
            self.orders[row].qty = productQty
            if let qty = self.orders[row].qty {
                cell.textFieldProductQty.text = String(describing: qty)
            }
            
            if cell.textFieldProductName.text != nil && cell.textFieldProductName.text != "" {
                calculateTotalAmount()
            }
        }
    }
    
    @objc func buttonDecreaseQtyTapped(sender: UIButton) {
        let row = sender.tag
        if let cell = tableView.cellForRow(at: IndexPath.init(row: row, section: 0)) as? ProductTableViewCell {
            var productQty = 0
            if let qty = self.orders[row].qty {
                productQty = qty
            }
            
            if productQty > 1 {
                productQty -= 1
            }
            
            self.orders[row].qty = productQty
            if let qty = self.orders[row].qty {
                cell.textFieldProductQty.text = String(describing: qty)
            }
            
            if cell.textFieldProductName.text != nil && cell.textFieldProductName.text != "" {
                calculateTotalAmount()
            }
        }
    }
    
    func calculateTotalAmount() {
        var totalAmount = 0
        for order in orders {
            if let price = order.price, let qty = order.qty {
                totalAmount += (price*qty)
            }
        }

        for refillOrder in refillOrders {
            if let price = refillOrder.price, let qty = refillOrder.qty {
                totalAmount += (price*qty)
            }
        }
        
        if totalAmount > 0 {
            totalAmount += self.deliveryCharge.price!
        }
        
        let strTotalAmount = totalAmount == 0 ? "Amount" : String(describing: totalAmount)
        self.textFieldTotal.text = "LBP " + strTotalAmount
    }
    
    var errorMessage: String = ""
    func isValidData() -> Bool {
        if (textFieldDeliveryDate.text?.isEmpty)! {
            errorMessage = "You should specify the Delivery Date."
            return false
        }
        
        if (textFieldDeliverTime.text?.isEmpty)! {
            errorMessage = "You should specify the Delivery Time."
            return false
        }
        
        if let order = orders.first {
            if order.name == nil || order.qty == nil {
                errorMessage = "You must order at least one item."
                return false
            }
        } else {
            errorMessage = "You must order at least one item."
            return false
        }
        
        if (textFieldPaymentMethod.text?.isEmpty)! {
            errorMessage = "You should specify the Payment Method"
            return false
        }
        
        return true
    }
    
    func addRefillOrder() {
        if let refill = DatabaseObjects.refills.first {
            if let id = refill.id, let price = refill.price {
                let order = Order(id: String(describing: id), qty: 1)
                order.price = price
                refillOrders.append(order)
            }
        }
    }
    
    func fillInfo() {
        self.textFieldLocation.text = DatabaseObjects.user.city
        
        if let deliveryCharge = DatabaseObjects.deliveryCharges.first {
            self.deliveryCharge = deliveryCharge
            if let price = deliveryCharge.price {
                self.labelDeliveryCharge.text = "LBP " + String(describing: price)
            }
        }
        
        self.textFieldDeliverTime.text = "3:00 PM"
        
//        let product = DatabaseObjects.products.filter { $0.id?.lowercased() == "cylinder" }.first
//        if let price = product?.price {
//            self.orders[0].price = String(describing: price)
//        }
//        if let title = product?.title {
//            self.orders[0].name = title
//        }
//        if let id = product?.id {
//            self.orders[0].id = id
//        }
//
//        self.tableView.reloadData()
//        self.calculateTotalAmount()
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
