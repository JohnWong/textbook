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
    
    let p = Priority.defaultPriority
    var s = ""
    
    func encodeWithCoder(aCoder: NSCoder) {
        let x = reflect(self)
        for i in 0 ..< x.count {
            let item = x[i]
            let key = item.0
            let value = item.1.value
            switch value {
            case let someBool as Bool:
                aCoder.encodeBool(someBool, forKey: key)
            case let someInt as Int:
                aCoder.encodeInteger(someInt, forKey: key)
            case let someFloat as Float:
                aCoder.encodeFloat(someFloat, forKey: key)
            case let someDouble as Double:
                aCoder.encodeDouble(someDouble, forKey: key)
            case let someString as String:
                aCoder.encodeObject(someString, forKey: key)
            default:
                println("something else \(key)")
            }
        }
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        let x = reflect(self)
        for i in 0 ..< x.count {
            let item = x[i]
            let key = item.0
            let value = item.1.value
            var newValue: AnyObject?
            switch value {
            case let someBool as Bool:
                newValue = aDecoder.decodeBoolForKey(key)
//            case let someObject as AnyObject:
//                newValue = aDecoder.decodeObjectForKey(key)
            case let someInt as Int:
                newValue = aDecoder.decodeIntegerForKey(key)
            case let someFloat as Float:
                newValue = aDecoder.decodeFloatForKey(key)
            case let someDouble as Double:
                newValue = aDecoder.decodeDoubleForKey(key)
            case let someString as String:
                newValue = aDecoder.decodeObjectForKey(key) as! String
//                self.setValue("123", forKeyPath: key)
//                self.setValue(str, forKey: key)
                continue
            default:
                println("something else \(key)")
            }
            let me = self as! textbook.CollectItem
            
            if let newObject = newValue {
                me.setValue(newObject, forKeyPath: key)
            }
        }
    }
    
    override var description: String {
        get {
            var desc = self.classForCoder.description() + " {\n"
            let x = reflect(self)
            for i in 0 ..< x.count {
                let key = x[i].0
                let value = x[i].1.value
                desc += "\(key): \(value)\n"
            }
            return desc + "}"
        }
    }
}
