//
//  CorpusGenerator.swift
//  MarkovChain
//
//  Created by Diana Komolova on 19/10/2017.
//  Copyright © 2017 Diana Komolova. All rights reserved.
//

import Foundation
class TextGenerator {
    
    var corpus: String
    
    init(_ corpusName: String) {
        self.corpus = corpusName
    }
    
    func buildText(length: Int, start: String, generator: Choice) {
        let analyser = CorpusAnalyser(corpusName: self.corpus)
        var initial = Substring(start)
        var text = String(start)
        for _ in 0...length {
            if let next = analyser.nextWord(text: self.corpus, currentWord: initial, generator: generator) {
            text.append(String(" \(next)"))
            initial = next
            }
        }
        print(text)
    }
}

