//
//  EditProfileViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/19/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var viewFirstname: UIView!
    @IBOutlet weak var viewLastname: UIView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewProvince: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewStreet: UIView!
    @IBOutlet weak var viewBuilding: UIView!
    @IBOutlet weak var viewFloor: UIView!
    @IBOutlet weak var textFieldFirstname: UITextField!
    @IBOutlet weak var textFieldLastname: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldProvince: UITextField!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var textFieldStreet: UITextField!
    @IBOutlet weak var textFieldBuilding: UITextField!
    @IBOutlet weak var textFieldFloor: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var buttonLocation: UIButton!
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pickerView: UIPickerView!
    var selectedProvinceId: Int!
    
    let padding: CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.        
        self.setupPickerView()
        self.setupDelegates()
        self.fillUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolbarView.labelTitle.text = "EDIT PROFILE"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonLocationTapped(_ sender: Any) {
        var locationDescription: String!
        if DatabaseObjects.USER_LOCATION != nil {
            let latitude = DatabaseObjects.USER_LOCATION.coordinate.latitude
            let longitude = DatabaseObjects.USER_LOCATION.coordinate.longitude
            locationDescription = String(format:"%.8f", latitude) + ", " + String(format:"%.8f", longitude)
        } else if appDelegate.locationManager != nil {
            if let location = appDelegate.locationManager.location {
                DatabaseObjects.USER_LOCATION = location
                let latitude = DatabaseObjects.USER_LOCATION.coordinate.latitude
                let longitude = DatabaseObjects.USER_LOCATION.coordinate.longitude
                locationDescription = String(format:"%.8f", latitude) + ", " + String(format:"%.8f", longitude)
            }
        } else {
            appDelegate.initializeLocationManager()
        }
        
        self.textFieldLocation.text = locationDescription
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if isValidData() {
            self.showWaitOverlay(color: Colors.appGreen)
            
            DispatchQueue.global(qos: .background).async {
                let user = DatabaseObjects.user
                user.firstName = self.textFieldFirstname.text
                user.lastName = self.textFieldLastname.text
                user.phone = self.textFieldPhone.text
                user.province = self.textFieldProvince.text
                user.city = self.textFieldCity.text
                user.street = self.textFieldStreet.text
                user.building = self.textFieldBuilding.text
                user.floor = self.textFieldFloor.text
                if DatabaseObjects.USER_LOCATION != nil {
                    user.latitude = String(describing: DatabaseObjects.USER_LOCATION.coordinate.latitude)
                    user.longitude = String(describing: DatabaseObjects.USER_LOCATION.coordinate.longitude)
                }
                let response = Services.init().editProfile(user: user)
                DispatchQueue.main.async {
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        DatabaseObjects.user = user
                        let userDefaults = UserDefaults.standard
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: DatabaseObjects.user)
                        userDefaults.set(encodedData, forKey: "user")
                        userDefaults.synchronize()
                        self.showAlert(message: (response?.message)!, style: .alert, shouldPop: true)
                    } else {
                        self.showAlert(message: (response?.message)!, style: .alert)
                    }
                    
                    self.removeAllOverlays()
                }
            }
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
    }
    
    func initializeViews() {
        self.viewFirstname.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewLastname.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewPhone.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewProvince.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewCity.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewStreet.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewBuilding.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewFloor.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewLocation.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        
        if let view = self.scrollView.subviews.first {
            self.scrollView.frame.size = self.view.frame.size
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: (view.frame.size.height+padding)*CGFloat(self.scrollView.subviews.count)+self.scrollView.frame.origin.y)
        }
    }
    
    func setupPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.textFieldProvince.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appGreen
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appGreen
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        
        self.textFieldProvince.inputAccessoryView = toolbar
    }
    
    func doneButtonTapped() {
        if DatabaseObjects.provinces.count > 0 {
            let row = self.pickerView.selectedRow(inComponent: 0)
            let province = DatabaseObjects.provinces[row]
            self.textFieldProvince.text = province.title
            self.selectedProvinceId = province.id == nil ? 0 : province.id
        }
        
        self.dismissKeyboard()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DatabaseObjects.provinces.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let year = DatabaseObjects.provinces[row].title
        return year
    }
    
    var errorMessage: String = ""
    func isValidData() -> Bool {
        if (textFieldFirstname.text?.isEmpty)! || (textFieldLastname.text?.isEmpty)! ||
            /*(textFieldPhone.text?.isEmpty)! ||*/ (textFieldProvince.text?.isEmpty)! ||
            (textFieldCity.text?.isEmpty)! || (textFieldStreet.text?.isEmpty)! ||
            (textFieldBuilding.text?.isEmpty)! || (textFieldFloor.text?.isEmpty)! {
            errorMessage = "Please fill all empty fields!"
            return false
        }
        
        return true
    }
    
    func fillUserInfo() {
        self.textFieldFirstname.text = DatabaseObjects.user.firstName
        self.textFieldLastname.text = DatabaseObjects.user.lastName
        self.textFieldPhone.text = DatabaseObjects.user.phone
        self.textFieldProvince.text = DatabaseObjects.user.province
        self.textFieldCity.text = DatabaseObjects.user.city
        self.textFieldStreet.text = DatabaseObjects.user.street
        self.textFieldBuilding.text = DatabaseObjects.user.building
        self.textFieldFloor.text = DatabaseObjects.user.floor
        if let latitude = DatabaseObjects.user.latitude, let longitude = DatabaseObjects.user.longitude {
            self.textFieldLocation.text = String(format:"%.8f", Double(latitude)!) + ", " + String(format:"%.8f", Double(longitude)!)
        }
        
        if DatabaseObjects.IS_IN_REVIEW != nil && DatabaseObjects.IS_IN_REVIEW {
            self.textFieldPhone.placeholder?.append(" (Optional)")
            self.textFieldLocation.placeholder?.append(" (Optional)")
        }
    }
    
    func setupDelegates() {
        self.textFieldFirstname.delegate = self
        self.textFieldLastname.delegate = self
        self.textFieldCity.delegate = self
        self.textFieldStreet.delegate = self
        self.textFieldProvince.delegate = self
        self.textFieldPhone.delegate = self
        self.textFieldBuilding.delegate = self
        self.textFieldFloor.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldFirstname {
            textFieldLastname.becomeFirstResponder()
        } else if textField == textFieldLastname {
            textFieldPhone.becomeFirstResponder()
        } else if textField == textFieldPhone {
            textFieldProvince.becomeFirstResponder()
        } else if textField == textFieldProvince {
            textFieldCity.becomeFirstResponder()
        } else if textField == textFieldCity {
            textFieldStreet.becomeFirstResponder()
        } else if textField == textFieldStreet {
            textFieldBuilding.becomeFirstResponder()
        } else if textField == textFieldBuilding {
            textFieldFloor.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
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
