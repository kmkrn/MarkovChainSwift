//
//  CorpusAnalyser.swift
//  MarkovChain
//
//  Created by Diana Komolova on 19/10/2017.
//  Copyright © 2017 Diana Komolova. All rights reserved.
//

import Foundation

class CorpusAnalyser {
    let parser = CorpusParser()
    var corpusName: String
    var corpusMatrix: Dictionary<Substring, Occurence<Substring>>
    
    init(corpusName: String) {
        self.corpusName = corpusName
        self.corpusMatrix = CorpusAnalyser.buildMatrix(parser.parse(fileName: corpusName)!)
    }
    
    private class func buildMatrix(_ strings: [Substring]) -> Dictionary<Substring, Occurence<Substring>> {
        var occurencies = Dictionary<Substring, Occurence<Substring>>()
        
        for (index, substring) in strings.enumerated() {
            var chain = Occurence<Substring>()
            if strings.indices.contains(index + 1){
                if let value = occurencies[substring] {
                    chain = value
                }
                chain.add(strings[index + 1], occurrences: 1)
                occurencies[substring] = chain
            }
        }
        
        return occurencies
    }
    
    
    func nextWord(text: String, currentWord: Substring) -> Substring? {
        if let probabilities = self.corpusMatrix[currentWord] {
            if let next = probabilities.map({ $0.0 }).randomItem() {
                return next
            }
        }
        return nil
    }
}

struct Occurence <Element: Hashable> {
    private var contents: [Element : Int] = [:]
    
    init() {}
    
    mutating func add(_ substring: Element, occurrences: Int = 1) {
        precondition(occurrences > 0, "Cannot add negative number")
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
        precondition(occurrences > 0, "Cannot add negative number")
        if currentCount > occurrences {
            contents[substring] = currentCount - occurrences
        } else {
            contents.removeValue(forKey: substring)
        }
    }
}

extension Occurence: Sequence {
    typealias Iterator = AnyIterator<(element: Element, count: Int)>
    
    func makeIterator() -> Iterator {
        var iterator = contents.makeIterator()
        
        return AnyIterator {
            return iterator.next()
        }
    }
}

extension Occurence: Collection {
    
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

