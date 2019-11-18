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

/// The result from an organism's fitness evaluation.
struct FitnessResult {
	var fitness: Double

	init(fitness: Double) {
		self.fitness = fitness
	}
}

/// Implemented by types that can evaluate fitnesses synchronously.
protocol SynchronousFitnessEvaluator: FitnessEvaluator {
	/// Returns the fitness value for a given organism. Larger fitnesses are better.
	/// - Parameter organism: The organism to evaluate.
	/// - Parameter solutionCallback: A function that can be called when a stopping condition is reached.
	mutating func fitnessFor(organism: Organism<G>, solutionCallback: (G, Double) -> ()) -> FitnessResult
}


/// Implemented by types that can evaluate fitnesses asynchronously.
protocol AsynchronousFitnessEvaluator: FitnessEvaluator {
	/// Submits a request for the fitness value for a given organism.
	mutating func requestFitnessFor(organism: Organism<G>)
	/// Checks if the evaluator has a fitness for the given organism, and
	/// returns it. This function is idempotent if it returns `nil`, and can thus be
	/// called periodically in a loop to wait for a fitness value.
	/// - Parameter organism: The organism to evaluate.
	mutating func fitnessResultFor(organism: Organism<G>) -> FitnessResult?
}
