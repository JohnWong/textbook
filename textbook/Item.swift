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
    
    func encodeWithCoder(aCoder: NSCoder) {
        let x = Mirror(reflecting: self)
        for item: (label: String?, value: Any) in x.children {
            let key = item.label!
            let value = item.value
            if key == "super" {
                continue
            }
            switch value {
            case let someBool as Bool:
                aCoder.encodeBool(someBool, forKey: key)
                break
            case let someInt as Int:
                aCoder.encodeInteger(someInt, forKey: key)
                break
            case let someFloat as Float:
                aCoder.encodeFloat(someFloat, forKey: key)
                break
            case let someDouble as Double:
                aCoder.encodeDouble(someDouble, forKey: key)
                break
            case let someObject as AnyObject:
                aCoder.encodeObject(someObject, forKey: key)
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
                newValue = aDecoder.decodeBoolForKey(key)
            case _ as Int:
                newValue = aDecoder.decodeIntegerForKey(key)
            case _ as Float:
                newValue = aDecoder.decodeFloatForKey(key)
            case _ as Double:
                newValue = aDecoder.decodeDoubleForKey(key)
            case _ as AnyObject:
                newValue = aDecoder.decodeObjectForKey(key)
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
