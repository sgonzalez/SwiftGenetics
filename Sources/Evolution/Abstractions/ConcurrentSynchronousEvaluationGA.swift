//
//  ConcurrentSynchronousEvaluationGA.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 6/12/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

#if os(OSX) || os(iOS) // Linux does not have Dispatch
// TODO: test out on Linux.

/// Encapsulates a generic genetic algorithm that performs synchronous fitness
/// evaluations concurrently. The fitness evaluator needs to be thread-safe.
final public class ConcurrentSynchronousEvaluationGA<Eval: SynchronousFitnessEvaluator, LogDelegate: EvolutionLoggingDelegate> : EvolutionWrapper where Eval.G == LogDelegate.G {

	public var fitnessEvaluator: Eval
	public var afterEachEpochFns = [(Int) -> ()]()

	/// A delegate for logging information from the GA.
	var loggingDelegate: LogDelegate

	/// Creates a new evolution wrapper.
	public init(fitnessEvaluator: Eval, loggingDelegate: LogDelegate) {
		self.fitnessEvaluator = fitnessEvaluator
		self.loggingDelegate = loggingDelegate
	}

	public func evolve(population: Population<Eval.G>, configuration: EvolutionAlgorithmConfiguration) {
		for i in 0..<configuration.maxEpochs {
			// Log start of epoch.
			loggingDelegate.evolutionStartingEpoch(i)
			let startDate = Date()

			// Perform an epoch.
			population.epoch()

			// Calculate fitnesses concurrently.
			var remainingRequests = population.organisms.count
			let remainingRequestsSem = DispatchSemaphore(value: 1)
			let completionSem = DispatchSemaphore(value: 0)
			for organism in population.organisms {
				guard organism.fitness == nil else {
					remainingRequestsSem.wait()
					remainingRequests -= 1
					remainingRequestsSem.signal()
					continue
				}

				DispatchQueue.global().async {
					let fitnessResult = self.fitnessEvaluator.fitnessFor(organism: organism, solutionCallback: { solution, fitness in
						self.loggingDelegate.evolutionFoundSolution(solution, fitness: fitness)
					})
					organism.fitness = fitnessResult.fitness

					remainingRequestsSem.wait()
					remainingRequests -= 1
					if remainingRequests == 0 {
						completionSem.signal()
					}
					remainingRequestsSem.signal()
				}
			}
			completionSem.wait()

			// Print epoch statistics.
			let elapsedInterval = Date().timeIntervalSince(startDate)
			loggingDelegate.evolutionFinishedEpoch(i, duration: elapsedInterval, population: population)

			// Execute epoch finished functions.
			for fn in afterEachEpochFns {
				fn(i)
			}
		}

	}

}

#endif
