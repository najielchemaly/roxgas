/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class User: NSObject, NSCoding {
	public var id : Int?
	public var firstName : String?
	public var lastName : String?
	public var phone : String?
	public var province : String?
	public var city : String?
	public var street : String?
	public var building : String?
    public var floor : String?
	public var email : String?
	public var activated : String?
    public var password : String?
    public var location: String?
    
    /* Used to parse and send data to server */
    public var latitude: String?
    public var longitude: String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let User_list = User.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of User Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let User = User(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: User Instance.
*/
    
    required public override init() { }
    
    required public init(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey:"id") as? Int
        firstName = decoder.decodeObject(forKey:"firstName") as? String
        lastName = decoder.decodeObject(forKey:"lastName") as? String
        phone = decoder.decodeObject(forKey:"phone") as? String
        province = decoder.decodeObject(forKey:"province") as? String
        city = decoder.decodeObject(forKey:"city") as? String
        street = decoder.decodeObject(forKey:"street") as? String
        building = decoder.decodeObject(forKey:"building") as? String
        floor = decoder.decodeObject(forKey:"floor") as? String
        email = decoder.decodeObject(forKey:"email") as? String
        activated = decoder.decodeObject(forKey:"activated") as? String
        password = decoder.decodeObject(forKey:"password") as? String
        latitude = decoder.decodeObject(forKey:"latitude") as? String
        longitude = decoder.decodeObject(forKey:"longitude") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(firstName, forKey: "firstName")
        coder.encode(lastName, forKey: "lastName")
        coder.encode(phone, forKey: "phone")
        coder.encode(province, forKey: "province")
        coder.encode(city, forKey: "city")
        coder.encode(street, forKey: "street")
        coder.encode(building, forKey: "building")
        coder.encode(floor, forKey: "floor")
        coder.encode(email, forKey: "email")
        coder.encode(activated, forKey: "activated")
        coder.encode(password, forKey: "password")
        coder.encode(latitude, forKey: "latitude")
        coder.encode(longitude, forKey: "longitude")
    }
    
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		firstName = dictionary["firstName"] as? String
		lastName = dictionary["lastName"] as? String
		phone = dictionary["phone"] as? String
		province = dictionary["province"] as? String
		city = dictionary["city"] as? String
		street = dictionary["street"] as? String
		building = dictionary["building"] as? String
        floor = dictionary["floor"] as? String
		email = dictionary["email"] as? String
		activated = dictionary["activated"] as? String
        password = dictionary["password"] as? String
        location = dictionary["location"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.firstName, forKey: "firstName")
		dictionary.setValue(self.lastName, forKey: "lastName")
		dictionary.setValue(self.phone, forKey: "phone")
		dictionary.setValue(self.province, forKey: "province")
		dictionary.setValue(self.city, forKey: "city")
		dictionary.setValue(self.street, forKey: "street")
		dictionary.setValue(self.building, forKey: "building")
        dictionary.setValue(self.floor, forKey: "floor")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.activated, forKey: "activated")
        dictionary.setValue(self.password, forKey: "password")
        dictionary.setValue(self.location, forKey: "location")

		return dictionary
	}

}
