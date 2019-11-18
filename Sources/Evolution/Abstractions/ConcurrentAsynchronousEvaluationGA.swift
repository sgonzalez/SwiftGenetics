//
//  ConcurrentAsynchronousEvaluationGA.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 7/2/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

#if os(OSX) || os(iOS) // Linux does not have Dispatch

/// Encapsulates a generic genetic algorithm that performs asynchronous fitness
/// evaluations concurrently. The fitness evaluator needs to be thread-safe.
final class ConcurrentAsynchronousEvaluationGA<Eval: AsynchronousFitnessEvaluator, LogDelegate: EvolutionLoggingDelegate> : EvolutionWrapper where Eval.G == LogDelegate.G, Eval.G: Hashable {

	var fitnessEvaluator: Eval
	var afterEachEpochFns = [(Int) -> ()]()

	/// A delegate for logging information from the GA.
	var loggingDelegate: LogDelegate

	/// How long to wait before polling for fitness values again.
	var pollingInterval: TimeInterval

	/// Creates a new asynchronous evolution wrapper.
	init(fitnessEvaluator: Eval, loggingDelegate: LogDelegate, pollingInterval: TimeInterval = 1.0) {
		self.fitnessEvaluator = fitnessEvaluator
		self.loggingDelegate = loggingDelegate
		self.pollingInterval = pollingInterval
	}

	func evolve(population: Population<Eval.G>, configuration: EvolutionAlgorithmConfiguration) {
		for i in 0..<configuration.maxEpochs {
			// Log start of epoch.
			loggingDelegate.evolutionStartingEpoch(i)
			let startDate = Date()

			// Perform an epoch.
			population.epoch()

			// Schedule fitness evals.

			var remainingRequests = population.organisms.count
			let remainingRequestsSem = DispatchSemaphore(value: 1)
			let completionSem = DispatchSemaphore(value: 0)

			/// Updates the remaining request and loop completion variables in a
			/// thread-safe manner.
			func decrementRequests() {
				remainingRequestsSem.wait()
				remainingRequests -= 1
				if remainingRequests == 0 {
					completionSem.signal()
				}
				remainingRequestsSem.signal()
			}

			var evalDependencies = [Eval.G: [Organism<Eval.G>]]()

			// Iterate over the population.
			for organism in population.organisms {
				guard organism.fitness == nil else {
					remainingRequestsSem.wait()
					remainingRequests -= 1
					remainingRequestsSem.signal()
					continue
				}

				// Check if we've already requested the fitness for this genotype.
				let alreadyRequested = evalDependencies[organism.genotype] != nil
				if alreadyRequested {
					evalDependencies[organism.genotype]!.append(organism)
				} else {
					// Make a note of the request.
					evalDependencies[organism.genotype] = []
				}

				DispatchQueue.global().async {
					if !alreadyRequested { // Avoid duplicate requests.
						self.fitnessEvaluator.requestFitnessFor(organism: organism)
					}
					decrementRequests()
				}
			}
			completionSem.wait()

			// Retrieve fitness evals.
			var evalDependencyResults = [Eval.G: FitnessResult?]()
			let evalDependencyResultsSem = DispatchSemaphore(value: 1)
			while population.organisms.contains(where: { $0.fitness == nil }) {
				let remainingOrganisms = population.organisms.filter({ $0.fitness == nil })
				remainingRequests = remainingOrganisms.count
				let organismsSem = DispatchSemaphore(value: 1)
				for organism in remainingOrganisms {
					// Check if our dependency has results yet.
					evalDependencyResultsSem.wait()
					let potentialResult = evalDependencyResults[organism.genotype]
					evalDependencyResultsSem.signal()
					if let result = potentialResult {
						organism.fitness = result?.fitness
						decrementRequests()
						continue
					}

					DispatchQueue.global().async {
						if let result = self.fitnessEvaluator.fitnessResultFor(organism: organism) {
							organismsSem.wait()
							organism.fitness = result.fitness
							organismsSem.signal()
							evalDependencyResultsSem.wait()
							evalDependencyResults[organism.genotype] = result
							evalDependencyResultsSem.signal()
						}

						decrementRequests()
					}
				}
				completionSem.wait()
				if pollingInterval > 0.0 {
					// Arbitrary sleep to avoid making things go crazy if the fitness evaluation check is very fast.
					usleep(UInt32(pollingInterval * 1000 * 1000))
				}
			}

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
