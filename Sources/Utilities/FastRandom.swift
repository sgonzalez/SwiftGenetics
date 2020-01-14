//
//  FastRandom.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 11/13/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

#if os(Linux)
fileprivate var _wrap_arc4random_FIRST_CALL = true
func _wrap_arc4random() -> UInt32 {
	// Non-BSD distributions don't have arc4random().
	if _wrap_arc4random_FIRST_CALL {
		srandom(UInt32(time(nil))) // We need to seed random(). Grrr.
		_wrap_arc4random_FIRST_CALL = false
	}
	return random()
}
#else
let _wrap_arc4random = arc4random()
#endif

extension Double {
	
	/// Returns a pseudorandom sample from Uniform(0,1).
	/// 
	/// This ran faster than `Double.random(in: 0..<1)` on macOS when tested on
	/// November 13, 2019 with the `-O` (optimize for speed) compiler flag.
	@inlinable public static func fastRandomUniform() -> Double {
		return Double(_wrap_arc4random()) / Double(UINT32_MAX)
	}
	
}
