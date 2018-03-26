//
//  RefillViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/18/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class RefillViewController: BaseViewController, UIPickerViewDelegate {

    @IBOutlet weak var viewDeliveryDate: UIView!
    @IBOutlet weak var viewDeliveryTime: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewPaymentMethod: UIView!
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var buttonRefill: UIButton!
    @IBOutlet weak var textFieldDeliveryDate: UITextField!
    @IBOutlet weak var textFieldDeliveryTime: UITextField!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var textFieldPaymentMethod: UITextField!
    @IBOutlet weak var labelTotal: UITextField!
    @IBOutlet weak var labelDeliveryCharge: UILabel!
    
    var deliveryCharge: Int = 0
    var timePicker: UIDatePicker!
    var datePicker: UIDatePicker!
    var paymentMethodPickerView: UIPickerView!
    var orders: [Order] = [Order]()
    
    let sendOrder = SendOrder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupPickerView()
        self.setupDataPicker()
        self.fillInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolbarView.labelTitle.text = "REFILL"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonRefillTapped(_ sender: Any) {
        if isValidData() {
            if DatabaseObjects.user.phone == nil || DatabaseObjects.user.phone == "" {
                let alert = UIAlertController(title: nil, message: "Please enter your phone number to proceed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
                    self.redirectToVC(storyboardId: StoryboardIds.EditProfileViewController, type: .Push)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: nil, message: "Are you sure you want to send a refill order?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
                    self.proceedOrder()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
    }
    
    func proceedOrder() {
        self.showWaitOverlay(color: Colors.appGreen)
        
        self.sendOrder.deliveryDate = self.textFieldDeliveryDate.text
        self.sendOrder.deliveryTime = self.textFieldDeliveryTime.text
        
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().sendOrder(sendOrder: self.sendOrder)
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    
                }
                
                if let message = response?.message {
                    self.showAlert(message: message, style: .alert)
                }
                
                self.removeAllOverlays()
            }
        }
    }
    
    func initializeViews() {
        self.viewDeliveryDate.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewDeliveryTime.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewCity.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewPaymentMethod.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewTotal.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
    }
    
    func setupDataPicker() {
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .date
        self.datePicker.minimumDate = Date.init()
        self.textFieldDeliveryDate.inputView = self.datePicker
        
        self.timePicker = UIDatePicker()
        self.timePicker.datePickerMode = .time
        self.timePicker.minimumDate = Date.init()
        self.textFieldDeliveryTime.inputView = self.timePicker
        
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
        self.textFieldDeliveryTime.inputAccessoryView = toolbar
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
    
    func doneButtonTapped() {
        if textFieldDeliveryDate.isFirstResponder {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.textFieldDeliveryDate.text = dateFormatter.string(from: datePicker.date)
        } else if textFieldDeliveryTime.isFirstResponder {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            self.textFieldDeliveryTime.text = dateFormatter.string(from: timePicker.date)
        } else if textFieldPaymentMethod.isFirstResponder {
            let row = self.paymentMethodPickerView.selectedRow(inComponent: 0)
            textFieldPaymentMethod.text = paymentMethods[row]
        }
        
        self.dismissKeyboard()
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
    
    func fillInfo() {
        self.textFieldCity.text = DatabaseObjects.user.city
        sendOrder.addressId = DatabaseObjects.user.city
        
        if let deliveryCharge = DatabaseObjects.deliveryCharges.first {
            if let price = deliveryCharge.price {
                self.deliveryCharge = price
                self.labelDeliveryCharge.text = "LBP " + String(describing: self.deliveryCharge)
            }
        }
        
        if let refill = DatabaseObjects.refills.first {
            if let id = refill.id, let price = refill.price {
                let order = Order(id: String(describing: id), qty: 1)
                order.price = price
                sendOrder.order = [order]
                sendOrder.totalAmount = String(describing: price+self.deliveryCharge)
                
                self.labelTotal.text = "LBP " + String(describing: price+self.deliveryCharge)
            }
        }
        
        if let paymentMethod = self.textFieldPaymentMethod.text {
            sendOrder.paymentMethod = paymentMethod
        }
        
        if let deliveryCharge = DatabaseObjects.deliveryCharges.first {
            let order = Order(id: deliveryCharge.id, qty: 1)
            if let price = deliveryCharge.price {
                order.price = price
            }
            sendOrder.order?.append(order)
        }
        
        self.textFieldDeliveryTime.text = "3:00 PM"
    }
    
    var errorMessage: String = ""
    func isValidData() -> Bool {
        if (textFieldDeliveryDate.text?.isEmpty)! {
            errorMessage = "You should specify the Delivery Date."
            return false
        }
        
        if (textFieldDeliveryTime.text?.isEmpty)! {
            errorMessage = "You should specify the Delivery Time."
            return false
        }
        
        if (textFieldPaymentMethod.text?.isEmpty)! {
            errorMessage = "You should specify the Payment Method"
            return false
        }
        
        return true
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
