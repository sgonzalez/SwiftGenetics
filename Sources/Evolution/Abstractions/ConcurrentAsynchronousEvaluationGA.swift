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
final class ConcurrentAsynchronousEvaluationGA<Eval: AsynchronousFitnessEvaluator, LogDelegate: EvolutionLoggingDelegate> : EvolutionWrapper where Eval.G == LogDelegate.G {
	
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
			
			// Perform an epoch.
			population.epoch()
			
			// Schedule fitness evals.
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
					self.fitnessEvaluator.requestFitnessFor(organism: organism)
					
					remainingRequestsSem.wait()
					remainingRequests -= 1
					if remainingRequests == 0 {
						completionSem.signal()
					}
					remainingRequestsSem.signal()
				}
			}
			completionSem.wait()
			
			// Retrieve fitness evals.
			while population.organisms.contains(where: { $0.fitness == nil }) {
				let remainingOrganisms = population.organisms.filter({ $0.fitness == nil })
				remainingRequests = remainingOrganisms.count
				for organism in remainingOrganisms {
					DispatchQueue.global().async {
						organism.fitness = self.fitnessEvaluator.fitnessResultFor(organism: organism)
						
						remainingRequestsSem.wait()
						remainingRequests -= 1
						if remainingRequests == 0 {
							completionSem.signal()
						}
						remainingRequestsSem.signal()
					}
				}
				completionSem.wait()
				sleep(1) // Arbitrary sleep to avoid making things go crazy if the fitness evaluation check is very fast.
			}
			
			// Print epoch statistics.
			loggingDelegate.evolutionFinishedEpoch(i, population: population)
		}
		
	}
	
}

#endif
