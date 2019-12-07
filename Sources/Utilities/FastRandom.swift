//
//  FastRandom.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 11/13/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

extension Double {
	
	/// Returns a pseudorandom sample from Uniform(0,1).
	/// 
	/// This ran faster than `Double.random(in: 0..<1)` when tested on
	/// November 13, 2019 with the `-O` (optimize for speed) compiler flag.
	@inlinable public static func fastRandomUniform() -> Double {
		return Double(arc4random()) / Double(UINT32_MAX)
	}
	
}
