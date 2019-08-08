//
//  ConcurrentSynchronousEvaluationGA.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 6/12/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

#if os(OSX) || os(iOS) // Linux does not have Dispatch

/// Encapsulates a generic genetic algorithm that performs synchronous fitness
/// evaluations concurrently. The fitness evaluator needs to be thread-safe.
final class ConcurrentSynchronousEvaluationGA<Eval: SynchronousFitnessEvaluator, LogDelegate: EvolutionLoggingDelegate> : EvolutionWrapper where Eval.G == LogDelegate.G {
	
	var fitnessEvaluator: Eval
	
	/// A delegate for logging information from the GA.
	var loggingDelegate: LogDelegate
	
	/// Creates a new evolution wrapper.
	init(fitnessEvaluator: Eval, loggingDelegate: LogDelegate) {
		self.fitnessEvaluator = fitnessEvaluator
		self.loggingDelegate = loggingDelegate
	}
	
	func evolve(population: Population<Eval.G>, maxEpochs: Int = 1000) {
		for i in 0..<maxEpochs {
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
					organism.fitness = self.fitnessEvaluator.fitnessFor(organism: organism, solutionCallback: { solution, fitness in
						self.loggingDelegate.evolutionFoundSolution(solution, fitness: fitness)
					})
					
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
		}

	}
	
}

#endif
