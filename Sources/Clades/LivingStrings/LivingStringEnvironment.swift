//
//  LivingStringEnvironment.swift
//  lossga
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
	var mutationRate: Double
	var crossoverRate: Double
	var numberOfElites: Int
	var numberOfEliteCopies: Int

	// MARK: Implementation-Specific Constants

}
