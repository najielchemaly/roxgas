//
//  Extensions.swift
//  rox
//
//  Created by MR.CHEMALY on 10/16/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init?(hexString: String, alpha: CGFloat = 1) {
        assert(hexString[hexString.startIndex] == "#", "Expected hex string of format #RRGGBB")
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                
                if scanner.scanHexInt32(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
                    a = alpha
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

extension UIView {
    
    func animate(withDuration duration: TimeInterval = 1.0, alpha: CGFloat = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        })
    }
    
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    func loadAndSetupXib(fromNibNamed nibName: String) {
        let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func customizeView(color: UIColor, withRadius: Bool = true) {
        self.backgroundColor = color
        
        if withRadius {
            self.layer.cornerRadius = 10.0
        }
    }
    
    func customizeBorder(color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat, alpha: CGFloat = 1) {
//        let borderr = UILabel()
//        borderr.backgroundColor = color.withAlphaComponent(alpha)
//        borderr.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
//        self.addSubview(borderr)
        
        let border = CALayer()
        border.backgroundColor = color.withAlphaComponent(alpha).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func isEnabled(enable: Bool) {
        self.isUserInteractionEnabled = enable
        self.alpha = enable ? 1 : 0.5
    }
}

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    
    func isEmpty() -> Bool {
        return (self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!
    }
    
}

extension UITextView {
    
    func isEmpty() -> Bool {
        return (self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!
    }
    
}

extension UIDatePicker {
    
    func setMaxDate() {
        self.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
    }
    
}

extension UIViewController {
    
    enum NavigationType : String {
        case Push = "PUSH"
        case Present = "PRESENT"
        case Popop = "POPUP"
    }
    
    func redirectToVC(storyboardId: String, type: NavigationType, animated: Bool = true, title: String? = nil, backTitle: String? = "BACK", delegate: UIPopoverPresentationControllerDelegate? = nil) {
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: storyboardId) {
            switch type {
            case .Push:
                destinationVC.navigationItem.backBarButtonItem?.title = backTitle
                destinationVC.navigationItem.title = title
                
                self.navigationController?.pushViewController(destinationVC, animated: animated)
                break
            case .Present:
                self.present(destinationVC, animated: animated, completion: nil)
                break
            case .Popop:
                destinationVC.modalPresentationStyle = .popover
                let popover = destinationVC.popoverPresentationController
                popover?.permittedArrowDirections = .init(rawValue: 0)
                popover?.sourceRect = view.bounds
                popover?.sourceView = view
                popover?.delegate = delegate
                
                self.present(destinationVC, animated: true, completion: nil)
                break
            }
        }
    }
    
    func showAlert(title: String = "Alert", message: String, style: UIAlertControllerStyle, shouldPop: Bool = false) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            if shouldPop {
                self.popVC()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func popVC(toRoot: Bool = false) {
        if toRoot {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIButton {
    
    func customizeLayout(color: UIColor) {
        self.setTitleColor(color, for: .normal)
    }
    
}

extension UIImageView {
    
    func customizeTint(color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
}

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}

extension String {
    
    init?(dictionary: NSDictionary) {
        if dictionary["images"] != nil {
            self = dictionary["images"] as! String
        } else {
            self = ""
        }
    }
    
    public static func modelsFromDictionaryArray(array:NSArray) -> [String] {
        var models:[String] = []
        for item in array {
            if let someItem = item as? String {
                models.append(someItem)
            } else {
                models.append(String(dictionary: item as! NSDictionary)!)
            }
        }
        return models
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}

protocol JSONable {}
extension JSONable {
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                if let orderArray = child.value as? Array<Order> {
                    var orders = [NSDictionary]()
                    for order in orderArray {
                        orders.append(order.toDict() as NSDictionary)
                    }
                    
                    dict[key] = orders
                } else {
                    dict[key] = child.value
                }
            }
        }
        return dict
    }
}
