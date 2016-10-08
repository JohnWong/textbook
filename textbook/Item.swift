//
//  Item.swift
//  textbook
//
//  Created by John Wong on 4/22/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

class Item: NSObject, NSCoding {
    
    enum Priority : Int {
        case defaultPriority = 0
        case lowPriority = 1
        case mediumPriority = 2
        case highPriority = 3
    }
    
    func encode(with aCoder: NSCoder) {
        let x = Mirror(reflecting: self)
        for item: (label: String?, value: Any) in x.children {
            let key = item.label!
            let value = item.value
            if key == "super" {
                continue
            }
            switch value {
            case let someBool as Bool:
                aCoder.encode(someBool, forKey: key)
                break
            case let someInt as Int:
                aCoder.encode(someInt, forKey: key)
                break
            case let someFloat as Float:
                aCoder.encode(someFloat, forKey: key)
                break
            case let someDouble as Double:
                aCoder.encode(someDouble, forKey: key)
                break
            case let someObject as AnyObject:
                aCoder.encode(someObject, forKey: key)
                break
            default:
                print("something else \(key)")
            }
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        let x = Mirror(reflecting: self)
        for item: (label: String?, value: Any) in x.children {
            let key = item.label!
            let value = item.value
            var newValue: AnyObject?
            if key == "super" {
                continue
            }
            switch value {
            case _ as Bool:
                newValue = aDecoder.decodeBool(forKey: key) as AnyObject?
            case _ as Int:
                newValue = aDecoder.decodeInteger(forKey: key) as AnyObject?
            case _ as Float:
                newValue = aDecoder.decodeFloat(forKey: key) as AnyObject?
            case _ as Double:
                newValue = aDecoder.decodeDouble(forKey: key) as AnyObject?
            case _ as AnyObject:
                newValue = aDecoder.decodeObject(forKey: key) as AnyObject?
            default:
                print("something else \(key)")
            }
            if let newValue: AnyObject = newValue {
                self.setValue(newValue, forKey: key)
            }
        }
    }
    
    override var description: String {
        get {
            var desc = self.classForCoder.description() + " {\n"
            let x = Mirror(reflecting: self)
            for item: (label: String?, value: Any) in x.children {
                let key = item.label!
                let value = item.value
                desc += "\(key): \(value)\n"
            }
            return desc + "}"
        }
    }
}
