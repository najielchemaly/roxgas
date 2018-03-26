/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Pos {
	public var id : String?
	public var title : String?
	public var address : String?
	public var location : String?
	public var phoneNumber : String?
    public var email: String?
    public var items_quantity: Int?
    public var isExpanded: Bool?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let Pos_list = Pos.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Pos Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Pos]
    {
        var models:[Pos] = []
        for item in array
        {
            models.append(Pos(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let Pos = Pos(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Pos Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		title = dictionary["title"] as? String
		address = dictionary["address"] as? String
		location = dictionary["location"] as? String
		phoneNumber = dictionary["phoneNumber"] as? String
        email = dictionary["email"] as? String
        items_quantity = dictionary["items_quantity"] as? Int
        
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.address, forKey: "address")
		dictionary.setValue(self.location, forKey: "location")
		dictionary.setValue(self.phoneNumber, forKey: "phoneNumber")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.items_quantity, forKey: "items_quantity")

		return dictionary
	}

}
