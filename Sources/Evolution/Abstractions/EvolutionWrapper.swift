//
//  EvolutionWrapper.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 7/3/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// Implemented by types that contain a GA, simplifying the process of evolution
/// to only require a starting population and a fitness evaluator.
protocol EvolutionWrapper {
	associatedtype Eval: FitnessEvaluator
	
	/// The fitness evaluator that the GA uses.
	var fitnessEvaluator: Eval { get }
	/// Runs evolution on the given start population, for a maximum number of epochs.
	func evolve(population: Population<Eval.G>, maxEpochs: Int)
}
