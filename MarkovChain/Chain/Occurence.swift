//
//  Occurence.swift
//  MarkovChain
//
//  Created by Diana Komolova on 09/02/2020.
//  Copyright © 2020 Diana Komolova. All rights reserved.
//

import Foundation

struct Occurrence <Element: Hashable> {
    private var contents: [Element : Int] = [:]
    
    init() {}
    
    mutating func add(_ substring: Element, occurrences: Int = 1) {
        if let currentCount = contents[substring] {
            contents[substring] = currentCount + occurrences
        } else {
            contents[substring] = occurrences
        }
    }
    
    mutating func remove(_ substring: Element, occurrences: Int = 1) {
        guard let currentCount = contents[substring], currentCount >= occurrences else {
            preconditionFailure("Element does not exist")
        }
        if currentCount > occurrences {
            contents[substring] = currentCount - occurrences
        } else {
            contents.removeValue(forKey: substring)
        }
    }
}

extension Occurrence: Sequence {
    typealias Iterator = AnyIterator<(element: Element, count: Int)>
    
    func makeIterator() -> Iterator {
        var iterator = contents.makeIterator()
        
        return AnyIterator {
            return iterator.next()
        }
    }
}

extension Occurrence: Collection {
    
    typealias Index = SubstringIndex<Element>
    
    var startIndex: Index {
        return SubstringIndex(contents.startIndex)
    }
    
    var endIndex: Index {
        return SubstringIndex(contents.endIndex)
    }
    
    subscript (position: Index) -> Iterator.Element {
        let dictionaryElement = contents[position.index]
        return (element: dictionaryElement.key, count: dictionaryElement.value)
    }
    
    func index(after i: Index) -> Index {
        return Index(contents.index(after: i.index))
    }
}

struct SubstringIndex<Element: Hashable> {
    fileprivate let index: DictionaryIndex<Element, Int>
    
    fileprivate init(_ dictionaryIndex: DictionaryIndex<Element, Int>) {
        self.index = dictionaryIndex
    }
}

extension SubstringIndex: Comparable {
    static func == (lhs: SubstringIndex, rhs: SubstringIndex) -> Bool {
        return lhs.index == rhs.index
    }
    
    static func < (lhs: SubstringIndex, rhs: SubstringIndex) -> Bool {
        return lhs.index < rhs.index
    }
}
