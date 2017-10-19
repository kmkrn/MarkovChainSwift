//
//  CorpusGenerator.swift
//  MarkovChain
//
//  Created by Diana Komolova on 19/10/2017.
//  Copyright © 2017 Diana Komolova. All rights reserved.
//

import Foundation
class CorpusGenerator {
    
    var corpus: String?
    
    init(_ corpusName: String) {
        self.corpus = corpusName
    }
    
    func buildText(length: Int) {
        let analyser = CorpusAnalyser(corpusName: self.corpus!)
        guard let text = self.corpus else {
            return
        }
        var start = Substring("Mulligan")
        for _ in 0...length {
            let next = analyser.nextWord(text: text, currentWord: start)
            print(next!)
            start = next!
        }
    }
}

