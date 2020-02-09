//
//  CorpusAnalyser.swift
//  MarkovChain
//
//  Created by Diana Komolova on 19/10/2017.
//  Copyright © 2017 Diana Komolova. All rights reserved.
//

import Foundation

enum Selection {
    case random
    case weighted
}

class CorpusAnalyser {
    let parser = CorpusParser()
    var corpusName: String
    
    init(corpusName: String) {
        self.corpusName = corpusName
    }
    
    func buildMatrix(completion: (_ matrix: Dictionary<Substring, Occurrence<Substring>>) -> Void) {
        guard let strings = self.parser.parse(fileName: self.corpusName) else {
            return
        }
        var occurrences = Dictionary<Substring, Occurrence<Substring>>()
        for (index, substring) in strings.enumerated() {
            var chain = Occurrence<Substring>()
            if let value = occurrences[substring] {
                chain = value
            }
            if strings.indices.contains(index + 1) {
                chain.add(strings[index + 1], occurrences: 1)
                occurrences[substring] = chain
            }
        }
        completion(occurrences)
    }
    
    func nextWord(matrix: Dictionary<Substring, Occurrence<Substring>>, currentWord: Substring, selection: Selection) -> Substring? {
        if let probabilities = matrix[currentWord] {
            switch selection {
            case .random:
                if let next = probabilities.map({ $0.0 }).randomItem() {
                    return next
                }
            case .weighted:
                return weightedRandom(probabilities)!
            }
        }
        return nil
    }
}

private func weightedRandom(_ probabilities: Occurrence<Substring>) -> Substring? {
    let totalSum = probabilities.map({ $0.1 }).reduce(0, +)
    var pseudoRandom = Int(arc4random_uniform(UInt32(totalSum)))
    let weights = probabilities.map({ $0.1 })
    for i in 0...probabilities.count {
        pseudoRandom -= weights[i]
        if pseudoRandom <= 0 {
            guard let next = probabilities.filter({ $1 == pseudoRandom }).map({ $0.0 }).randomItem() else {
                return nil
            }
            return next
        }
    }
    return nil
}

