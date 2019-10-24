//
//  LivingTreeEnvironment.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 6/27/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// The environment configuration for an ecosystem of living trees.
struct LivingTreeEnvironment: GeneticEnvironment {
	
	// MARK: Genetic Constants
	
	var populationSize: Int
	var selectionMethod: SelectionMethod
	var selectableProportion: Double
	var mutationRate: Double
	var crossoverRate: Double
	var numberOfElites: Int
	var numberOfEliteCopies: Int
	var parameters: [String : Any]
	
	// MARK: Implementation-Specific Constants
	
	/// The maximum amount a scalar can drift during a mutation.
	var scalarMutationMagnitude: Int
	
	/// How often deletion mutations take place, between 0 and 1.
	var structuralMutationDeletionRate: Double
	/// How often addition mutations take place, between 0 and 1.
	var structuralMutationAdditionRate: Double
}
