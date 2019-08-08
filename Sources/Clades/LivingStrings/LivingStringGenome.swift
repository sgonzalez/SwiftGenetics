//
//  LivingStringGenome.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 7/9/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// An evolvable sequence of genes.
struct LivingStringGenome<GeneType: Gene>: Genome where GeneType.Environment == LivingStringEnvironment {
	
	typealias RealGene = GeneType
	typealias Environment = LivingStringEnvironment
	
	/// The actual sequence of genes.
	var genes: [RealGene]
	
	mutating func mutate(rate: Double, environment: Environment) {
		for i in 0..<genes.count {
			genes[i].mutate(rate: rate, environment: environment)
		}
	}
	
	func crossover(with partner: LivingStringGenome, rate: Double, environment: Environment) -> (LivingStringGenome, LivingStringGenome) {
		guard Double.random(in: 0..<1) < rate else { return (self, partner) }
		guard partner.genes.count > 1 && self.genes.count > 1 else { return (self, partner) }
		
		let percentPoint = Double.random(in: 0..<1)
		let crossoverPointA = Int(Double(self.genes.count) * percentPoint)
		let crossoverPointB = Int(Double(partner.genes.count) * percentPoint)
		
		var childGenesA = [RealGene]()
		var childGenesB = [RealGene]()
		
		// Crossover to create first child.
		childGenesA.append(contentsOf: self.genes.prefix(upTo: crossoverPointA))
		childGenesA.append(contentsOf: partner.genes.suffix(from: crossoverPointB))
		
		// Crossover to create second child.
		childGenesB.append(contentsOf: partner.genes.prefix(upTo: crossoverPointB))
		childGenesB.append(contentsOf: self.genes.suffix(from: crossoverPointA))
		
		return (
			LivingStringGenome(genes: childGenesA),
			LivingStringGenome(genes: childGenesB)
		)
	}
	
}

extension LivingStringGenome: RawRepresentable where RealGene: Hashable {
	typealias RawValue = [RealGene]
	var rawValue: RawValue { return genes }
	init?(rawValue: RawValue) {
		self = LivingStringGenome.init(genes: rawValue)
	}
}
