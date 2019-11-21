//
//  LivingForestGenome.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 6/11/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// An evolvable forest of one or more independent trees.
/// Note: Forests have homogeneous gene types for now.
public struct LivingForestGenome<GeneType: TreeGeneType>: Genome {
	
	public typealias RealGene = LivingTreeGenome<GeneType>
	public typealias Environment = RealGene.Environment
	
	/// The child trees in the forest.
	public var trees: [RealGene]
	
	/// Creates a new forest given trees.
	public init(trees: [RealGene]) {
		self.trees = trees
	}
	
	/// Convenience initializer to build a forest directly from root tree genes.
	public init(roots: [LivingTreeGene<GeneType>]) {
		trees = roots.map { RealGene(rootGene: $0) }
	}
	
	mutating public func mutate(rate: Double, environment: Environment) {
		// Mutate each tree individually.
		for idx in 0..<trees.count {
			trees[idx].mutate(rate: rate, environment: environment)
		}
	}
	
	public func crossover(with partner: LivingForestGenome, rate: Double, environment: Environment) -> (LivingForestGenome, LivingForestGenome) {
		// Recombine each child individually, imagine how recombination works on chromosomes.
		let zippedChildren = zip(trees, partner.trees).map {
			return $0.0.crossover(with: $0.1, rate: rate, environment: environment)
		}
		return (
			LivingForestGenome(trees: zippedChildren.map { $0.0 }),
			LivingForestGenome(trees: zippedChildren.map { $0.1 })
		)
	}
	
	/// Returns a deep copy.
	func copy() -> LivingForestGenome {
		return LivingForestGenome(trees: trees.map { $0.copy() })
	}
	
}

extension LivingForestGenome: RawRepresentable {
	public typealias RawValue = [RealGene]
	public var rawValue: RawValue { return trees }
	public init?(rawValue: RawValue) {
		self = LivingForestGenome.init(trees: rawValue)
	}
}
