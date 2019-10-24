//
//  LivingStringEnvironment.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 7/9/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// The environment configuration for an ecosystem of living strings.
struct LivingStringEnvironment: GeneticEnvironment {
	
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

}
