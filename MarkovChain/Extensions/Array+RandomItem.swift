//
//  Array+RandomItem.swift
//  MarkovChain
//
//  Created by Diana Komolova on 19/10/2017.
//  Copyright © 2017 Diana Komolova. All rights reserved.
//

import Foundation
extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
