//
//  GeneticStructures.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 6/27/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// An environment where evolution takes place.
public protocol GeneticEnvironment: GeneticConstants {
	
}

/// Implemented by structures that have an associated genetic environment.
public protocol GeneticEnvironmentAssociable {
	associatedtype Environment: GeneticEnvironment
}

/// An individual genetic element.
public protocol Gene: Mutatable {
	
}

/// A collection of genes.
public protocol Genome: Mutatable, Crossoverable {
	
}

/// Represents a specific, individual organism with a fitness and genome.
public class Organism<G: Genome> {
	/// A unique identifier for this organism.
	public let uuid: UUID
	/// This organism's fitness value, or `nil` if it is unknown.
	public var fitness: Double!
	/// The organism's genotype.
	public var genotype: G
	/// The generation that this organism was created in, or -1.
	public var birthGeneration: Int
	
	/// Creates a new organism.
	public init(fitness: Double!, genotype: G, birthGeneration: Int = -1) {
		uuid = UUID()
		self.fitness = fitness
		self.genotype = genotype
		self.birthGeneration = birthGeneration
	}
}

// Allows organisms to be compared by their fitnesses.
extension Organism: Comparable {
	public static func < (lhs: Organism<G>, rhs: Organism<G>) -> Bool {
		guard lhs.fitness != nil && rhs.fitness != nil else { return false }
		return lhs.fitness < rhs.fitness
	}
	
	public static func == (lhs: Organism<G>, rhs: Organism<G>) -> Bool {
		return lhs.fitness == rhs.fitness
	}
}

// Organisms are hashable by their UUID.
extension Organism: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(uuid)
	}
}
