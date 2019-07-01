//
//  TreeGeneType.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 6/27/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// An abstract interface that all tree gene types conform to.
protocol TreeGeneType: Equatable {
	var childCount: Int { get }
	var isBinaryType: Bool { get }
	var isUnaryType: Bool { get }
	var isLeafType: Bool { get }
	static var binaryTypes: [Self] { get }
	static var unaryTypes: [Self] { get }
	static var leafTypes: [Self] { get }
	static var nonLeafTypes: [Self] { get }
	static var allTypes: [Self] { get }
}

extension TreeGeneType {
	var isBinaryType: Bool { return Self.binaryTypes.contains(self) }
	var isUnaryType: Bool { return Self.unaryTypes.contains(self) }
	var isLeafType: Bool { return Self.leafTypes.contains(self) }
	
	static var nonLeafTypes: [Self] { return binaryTypes + unaryTypes }
	static var allTypes: [Self] { return nonLeafTypes + leafTypes }
}

/// Templates can enforce certain constraints and define gene type sampling.
struct TreeGeneTemplate<T: TreeGeneType> {
	/// Sampling array for binary gene types.
	let binaryTypes: [T]
	/// Sampling array for unary gene types.
	let unaryTypes: [T]
	/// Sampling array for leaf gene types.
	let leafTypes: [T]
	
	/// A sampling array for non-leaf types.
	var nonLeafTypes: [T] { return binaryTypes + unaryTypes }
	/// A sampling array for all types.
	var allTypes: [T] { return nonLeafTypes + leafTypes }
}
