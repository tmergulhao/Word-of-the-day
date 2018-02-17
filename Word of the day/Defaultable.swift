//
//  Defaultable.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 02/11/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

protocol BridgedType {}

// Swift codable types
extension String : BridgedType {}
extension Bool : BridgedType {}
extension Int : BridgedType {}
extension Float : BridgedType {}
extension Double : BridgedType {}

// Foundation codable types
extension Data : BridgedType {}

extension Default {

    init(key : String) {

        self.key = key

        if Element.Type.self is BridgedType {

            self.value = UserDefaults.standard.value(forKey: key) as? Element
            return
        }

        guard let data = UserDefaults.standard.data(forKey: key) else { return }

        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(Element.self, from: data)
            self.value = decoded
        } catch {
            #if DEBUG
                print(error)
            #endif
        }
    }

    func set(_ value : Element?) {

        guard let value = value else {
            UserDefaults.standard.set(nil, forKey: key)
            return
        }

        if Element.Type.self is BridgedType {
            UserDefaults.standard.set(value, forKey: key)
            return
        }

        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(value)
            UserDefaults.standard.set(encoded, forKey: key)
        } catch {
            #if DEBUG
                print(error)
            #endif
        }
    }
}

public struct Default<Element : Codable> {
    
    var key : String
    var value : Element? {
        didSet { set(value) }
    }
}

extension Default : CustomStringConvertible {
    public var description : String {
        return "Default<\(String(describing: Element.self))>(\"\(key)\", \(value != nil ? String(describing: value!) : "nil"))"
    }
}

infix operator « : AssignmentPrecedence

public func «<T>(left : inout Default<T>, right : T?) {
    left.value = right
}

public func «<T>(left : inout T?, right : Default<T>) {
    left = right.value
}
