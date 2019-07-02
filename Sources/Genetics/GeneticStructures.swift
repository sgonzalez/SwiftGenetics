//
//  GeneticStructures.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 6/27/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// An environment where evolution takes place.
protocol GeneticEnvironment: GeneticConstants {
	
}

/// Implemented by structures that have an associated genetic environment.
protocol GeneticEnvironmentAssociable {
	associatedtype Environment: GeneticEnvironment
}

/// An individual genetic element.
protocol Gene: Mutatable {
	
}

/// A collection of genes.
protocol Genome: Mutatable, Crossoverable {
	associatedtype RealGene: Gene
}

/// Represents a specific, individual organism with a fitness and genome.
class Organism<G: Genome> {
	/// A unique identifier for this organism.
	let uuid: UUID
	/// This organism's fitness value, or `nil` if it is unknown.0
	var fitness: Double!
	/// The organism's genotype.
	var genotype: G
	/// The generation that this organism was created in, or -1.
	var birthGeneration: Int
	
	/// Creates a new organism.
	init(fitness: Double!, genotype: G, birthGeneration: Int = -1) {
		uuid = UUID()
		self.fitness = fitness
		self.genotype = genotype
		self.birthGeneration = birthGeneration
	}
}

// Allows organisms to be compared by their fitnesses.
extension Organism: Comparable {
	static func < (lhs: Organism<G>, rhs: Organism<G>) -> Bool {
		guard lhs.fitness != nil && rhs.fitness != nil else { return false }
		return lhs.fitness < rhs.fitness
	}
	
	static func == (lhs: Organism<G>, rhs: Organism<G>) -> Bool {
		return lhs.fitness == rhs.fitness
	}
}
