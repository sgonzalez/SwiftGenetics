//
//  EvolutionLoggingDelegate.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 7/3/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// Implemented by types that can receive log events for a GA.
public protocol EvolutionLoggingDelegate {
	associatedtype G: Genome
	
	/// Called at the beginning of an epoch.
	/// - Parameter i: The epoch index.
	func evolutionStartingEpoch(_ i: Int)
	
	/// Called at the end of an epoch.
	/// - Parameter i: The epoch index.
	/// - Parameter duration: How long the epoch took to run (elapsed wall-clock time).
	/// - Parameter population: The population at the end of the epoch.
	func evolutionFinishedEpoch(_ i: Int, duration: TimeInterval, population: Population<G>)
	
	/// Called when the stopping condition has been met.
	/// - Parameter solution: The genome that met the stopping condition.
	/// - Parameter fitness: The solution genome's fitness.
	func evolutionFoundSolution(_ solution: G, fitness: Double)
	
}
