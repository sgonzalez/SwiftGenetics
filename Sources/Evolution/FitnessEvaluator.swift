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
	
	/// Returns the fitness value for a given organism. Larger fitnesses are better.
	mutating func fitnessFor(organism: Organism<G>, solutionCallback: (G, Double) -> ()) -> Double
}
