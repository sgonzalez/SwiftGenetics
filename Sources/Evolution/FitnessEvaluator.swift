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
	var individualSampleLosses: [Double]?
	
	init(fitness: Double, individualSampleLosses: [Double]? = nil) {
		self.fitness = fitness
		self.individualSampleLosses = individualSampleLosses
	}
}

/// Implemented by types that can evaluate fitnesses synchronously.
protocol SynchronousFitnessEvaluator: FitnessEvaluator {
	/// Returns the fitness value for a given organism. Larger fitnesses are better.
	/// - Parameter organism: The organism to evaluate.
	/// - Parameter solutionCallback: A function that can be called when a stopping condition is reached.
	/// - Parameter returnIndividualLosses: Whether the evaluator should return individual sample losses in the result.
	mutating func fitnessFor(organism: Organism<G>, solutionCallback: (G, Double) -> (), returnIndividualLosses: Bool) -> FitnessResult
}


/// Implemented by types that can evaluate fitnesses asynchronously.
protocol AsynchronousFitnessEvaluator: FitnessEvaluator {
	/// Submits a request for the fitness value for a given organism.
	mutating func requestFitnessFor(organism: Organism<G>)
	/// Checks if the evaluator has a fitness for the given organism, and
	/// returns it. This function is idempotent if it returns `nil`, and can thus be
	/// called periodically in a loop to wait for a fitness value.
	/// - Parameter organism: The organism to evaluate.
	/// - Parameter returnIndividualLosses: Whether the evaluator should return individual sample losses in the result.
	mutating func fitnessResultFor(organism: Organism<G>, returnIndividualLosses: Bool) -> FitnessResult?
}
