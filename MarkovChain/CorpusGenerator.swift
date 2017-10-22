//
//  CorpusGenerator.swift
//  MarkovChain
//
//  Created by Diana Komolova on 19/10/2017.
//  Copyright © 2017 Diana Komolova. All rights reserved.
//

import Foundation
class CorpusGenerator {
    
    var corpus: String
    
    init(_ corpusName: String) {
        self.corpus = corpusName
    }
    
    func buildText(length: Int, start: String) {
        let analyser = CorpusAnalyser(corpusName: self.corpus)
        var initial = Substring(start)
        var text = String(start)
        for _ in 0...length {
            if let next = analyser.nextWord(text: self.corpus, currentWord: initial) {
            text.append(String(" \(next)"))
            initial = next
            }
        }
        print(text)
    }
}

