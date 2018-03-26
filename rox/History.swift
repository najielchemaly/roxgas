/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class History {
	public var title : String?
	public var date : String?
    public var year: String?
    public var products: Array<Product>?
    public var order_nb: String?
    public var status: String?
    public var total: Int?
    public var isExpanded: Bool?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let History_list = History.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of History Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [History]
    {
        var models:[History] = []
        for item in array
        {
            models.append(History(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let History = History(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: History Instance.
*/
    
    required public init() { }
    
	required public init?(dictionary: NSDictionary) {

		title = dictionary["title"] as? String
		date = dictionary["date"] as? String
        year = dictionary["year"] as? String
        order_nb = dictionary["order_nb"] as? String
        status = dictionary["status"] as? String
        total = dictionary["total"] as? Int
        if (dictionary["products"] != nil) { products = Product.modelsFromDictionaryArray(array: dictionary["products"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.date, forKey: "date")
        dictionary.setValue(self.year, forKey: "year")
        dictionary.setValue(self.order_nb, forKey: "order_nb")
        dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.total, forKey: "total")

		return dictionary
	}

}
