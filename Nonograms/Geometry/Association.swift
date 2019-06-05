//
//  Association.swift
//  Nonograms
//
//  Created by Philipp Brendel on 05.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

protocol Associator {
    func associate(channels: [Channel], hints: [Int], hintOffset: Int) -> [Channel]
}

class Association {
    let associators: [Associator] = [
        UniqueRunsAssociator(),
        MaximumHintAssociator()
    ]
    
    func associate(channels: [Channel], hints: [Int]) -> [Channel] {
        var stepResult = channels
        var result: [Channel]
        
        repeat {
            result = stepResult
            stepResult = applyAssociators(channels: result, hints: hints)
            
            if stepResult == result {
                stepResult = applyAssociatorsToSplitRanges(channels: stepResult, hints: hints)
            }
            
        } while stepResult != result
        
        return result
    }
    
    func applyAssociators(channels: [Channel], hints: [Int], hintOffset: Int = 0) -> [Channel] {
        var associatedChannels = channels
        
        for associator in associators {
            associatedChannels = associator.associate(channels: associatedChannels, hints: hints, hintOffset: hintOffset)
        }
        
        return associatedChannels
    }
    
    func applyAssociatorsToSplitRanges(channels: [Channel], hints: [Int]) -> [Channel] {
        var result = channels
        
        for (i, channel) in channels.enumerated() {
            guard let hintIndex = channel.associatedHintIndex else { continue }
            
            let channelsBefore = Array(channels.prefix(i))
            
            if channelsBefore.first(where: {$0.associatedHintIndex == nil}) != nil {
                let hintsBefore = Array(hints.prefix(hintIndex))
                let associatedChannels = applyAssociators(channels: channelsBefore, hints: hintsBefore)
                
                for k in 0..<i {
                    result[k] = associatedChannels[k]
                }
            }
            
            let channelsAfter = Array(channels.suffix(from: i + 1))
            
            if channelsAfter.first(where: {$0.associatedHintIndex == nil}) != nil {
                let hintsAfter = Array(hints.suffix(from: hintIndex + 1))
                let associatedChannels = applyAssociators(channels: channelsAfter, hints: hintsAfter, hintOffset: hintIndex + 1)
                
                for k in (i + 1)..<channels.count {
                    result[k] = associatedChannels[k - (i + 1)]
                }
            }
        }
        
        return result
    }
}

class UniqueRunsAssociator: Associator {
    func associate(channels: [Channel], hints: [Int], hintOffset: Int) -> [Channel] {
        guard channels.count == hints.count else { return channels }
        
        for (i, channel) in channels.enumerated() {
            let currentHint = hints[i]
            
            if i > 0 && hints[i - 1] + currentHint < channel.length {
                return channels
            }
            
            if i + 1 < channels.count && hints[i + 1] + currentHint < channel.length {
                return channels
            }
        }
        
        return channels.enumerated().map {
            index, channel in channel.associate(hintIndex: index + hintOffset)
        }
    }
}

class MaximumHintAssociator: Associator {
    func associate(channels: [Channel], hints: [Int], hintOffset: Int) -> [Channel] {
        guard let maxHint = hints.max() else {
            return channels
        }
        
        let maxHintCount = hints.filter{$0 == maxHint}.count
        let channelsThatFitHint = channels.filter{$0.length >= maxHint}
        
        guard channelsThatFitHint.count == maxHintCount else {
            return channels
        }
        
        var hintIndex = -1
        var result = channels
    
        for (channelIndex, channel) in channels.enumerated() {
            guard channel.length >= maxHint else { continue }
            
            hintIndex = hints.index(maxHint, offsetBy: hintIndex + 1)
            
            assert(hintIndex >= 0)
            
            if hintIndex > 0 && maxHint + hints[hintIndex - 1] < channel.length {
                return channels
            }
            
            if hintIndex + 1 < hints.length && maxHint + hints[hintIndex + 1] < channel.length {
                return channels
            }
            
            result[channelIndex] = channel.associate(hintIndex: hintIndex + hintOffset)
        }
        
        return result
    }
}
