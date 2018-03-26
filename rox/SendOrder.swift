/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class SendOrder: JSONable {
	public var deliveryDate : String?
	public var deliveryTime : String?
	public var totalAmount : String?
    public var addressId : String?
    public var paymentMethod: String?
    public var access_token: String?
    public var order: Array<Order>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let SendOrder_list = SendOrder.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of SendOrder Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [SendOrder]
    {
        var models:[SendOrder] = []
        for item in array
        {
            models.append(SendOrder(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let SendOrder = SendOrder(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: SendOrder Instance.
*/
    
    required public init() { }
    
	required public init?(dictionary: NSDictionary) {

		deliveryDate = dictionary["deliveryDate"] as? String
		deliveryTime = dictionary["deliveryTime"] as? String
		totalAmount = dictionary["totalAmount"] as? String
        addressId = dictionary["addressId"] as? String
        paymentMethod = dictionary["paymentMethod"] as? String
        if (dictionary["order"] != nil) { order = Order.modelsFromDictionaryArray(array: dictionary["order"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.deliveryDate, forKey: "deliveryDate")
		dictionary.setValue(self.deliveryTime, forKey: "deliveryTime")
		dictionary.setValue(self.totalAmount, forKey: "totalAmount")
        dictionary.setValue(self.addressId, forKey: "addressId")
        dictionary.setValue(self.paymentMethod, forKey: "paymentMethod")

		return dictionary
	}

}
