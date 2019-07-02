//
//  FitnessEvaluator.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 11/19/18.
//  Copyright © 2018 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// Implemented by types that can evaluate fitnesses for an associated genome.
protocol FitnessEvaluator {
	associatedtype G: Genome
}

/// Implemented by types that can evaluate fitnesses synchronously.
protocol SynchronousFitnessEvaluator: FitnessEvaluator {
	/// Returns the fitness value for a given organism. Larger fitnesses are better.
	mutating func fitnessFor(organism: Organism<G>, solutionCallback: (G, Double) -> ()) -> Double
}


/// Implemented by types that can evaluate fitnesses asynchronously.
protocol AsynchronousFitnessEvaluator: FitnessEvaluator {
	/// Submits a request for the fitness value for a given organism.
	mutating func requestFitnessFor(organism: Organism<G>)
	/// Checks if the evaluator has a fitness for the given organism, and
	/// returns it. This idempotent function can be called periodically in a
	/// loop to wait for a fitness value.
	mutating func fitnessResultFor(organism: Organism<G>) -> Double?
}
