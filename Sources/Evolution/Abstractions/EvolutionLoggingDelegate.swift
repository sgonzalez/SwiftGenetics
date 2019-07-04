//
//  EvolutionLoggingDelegate.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 7/3/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// Implemented by types that can receive log events for a GA.
protocol EvolutionLoggingDelegate {
	associatedtype G: Genome
	
	/// Called at the beginning of an epoch.
	func evolutionStartingEpoch(_ i: Int)
	/// Called at the end of an epoch.
	func evolutionFinishedEpoch(_ i: Int, population: Population<G>)
	/// Called when the stopping condition has been met.
	func evolutionFoundSolution(_ solution: G, fitness: Double)
}
