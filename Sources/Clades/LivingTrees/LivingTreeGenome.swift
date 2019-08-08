//
//  LivingTreeGenome.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 6/28/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// An evolvable tree.
struct LivingTreeGenome<GeneType: TreeGeneType>: Genome {
	
	typealias RealGene = LivingTreeGene<GeneType>
	
	/// The tree's root gene.
	var rootGene: RealGene
	
	mutating func mutate(rate: Double, environment: Environment) {
		rootGene.bottomUpEnumerate { gene in
			gene.mutate(rate: rate, environment: environment)
		}
	}
	
	func crossover(with partner: LivingTreeGenome, rate: Double, environment: Environment) -> (LivingTreeGenome, LivingTreeGenome) {
		guard Double.random(in: 0..<1) < rate else { return (self, partner) }
		guard partner.rootGene.children.count > 1 && self.rootGene.children.count > 1 else { return (self, partner) }
		
		var childRootA = self.rootGene.copy()
		var childRootB = partner.rootGene.copy()
		
		let crossoverRootA = childRootA.allNodes.randomElement()!
		let crossoverRootB = childRootB.allNodes.randomElement()!
		
		let crossoverRootAOriginalParent = crossoverRootA.parent
		let crossoverRootBOriginalParent = crossoverRootA.parent
		
		// Crossover to create first child.
		if let parent = crossoverRootBOriginalParent {
			crossoverRootA.parent = parent
		} else {
			childRootB = crossoverRootB
		}
		
		// Crossover to create second child.
		if let parent = crossoverRootAOriginalParent {
			crossoverRootB.parent = parent
		} else {
			childRootA = crossoverRootA
		}
		
		return (
			LivingTreeGenome(rootGene: childRootA),
			LivingTreeGenome(rootGene: childRootB)
		)
	}
	
	/// Returns a deep copy.
	func copy() -> LivingTreeGenome {
		let newRoot = self.rootGene.copy()
		return LivingTreeGenome(rootGene: newRoot)
	}
	
}

extension LivingTreeGenome: RawRepresentable {
	typealias RawValue = RealGene
	var rawValue: RawValue { return rootGene }
	init?(rawValue: RawValue) {
		self = LivingTreeGenome.init(rootGene: rawValue)
	}
}

// Living trees can behave as genes within a living forest genome.
extension LivingTreeGenome: Gene {
	typealias Environment = RealGene.Environment
}
