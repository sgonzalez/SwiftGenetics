//
//  EvolutionWrapper.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 7/3/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// The high-level configuration for a GA. Hyperparameters that are too broad to be considered part of a
/// `GeneticEnvironment` are included here.
struct EvolutionAlgorithmConfiguration {
	let maxEpochs: Int
	let algorithmType: EvolutionAlgorithmType
}

/// Implemented by types that contain a GA, simplifying the process of evolution
/// to only require a starting population and a fitness evaluator.
protocol EvolutionWrapper {
	associatedtype Eval: FitnessEvaluator
	
	/// The fitness evaluator that the GA uses.
	var fitnessEvaluator: Eval { get }
	/// Runs evolution on the given start population, for a maximum number of epochs.
	func evolve(population: Population<Eval.G>, configuration: EvolutionAlgorithmConfiguration)
	
	/// The functions that are called after each epoch.
	var afterEachEpochFns: [(Int) -> ()] { get set }
	/// Calls the passed function after each epoch. The function takes the completed generation's number.
	/// - Note: This function just provides syntactic sugar.
	mutating func afterEachEpoch(_ afterEachEpochFn: @escaping (Int) -> ())
}

extension EvolutionWrapper {
	mutating func afterEachEpoch(_ afterEachEpochFn: @escaping (Int) -> ()) {
		afterEachEpochFns.append(afterEachEpochFn)
	}
}
