//
//  LivingStringEnvironment.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 7/9/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// The environment configuration for an ecosystem of living strings.
public struct LivingStringEnvironment: GeneticEnvironment {
	
	// MARK: Genetic Constants
	
	public var populationSize: Int
	public var selectionMethod: SelectionMethod
	public var selectableProportion: Double
	public var mutationRate: Double
	public var crossoverRate: Double
	public var numberOfElites: Int
	public var numberOfEliteCopies: Int
	public var parameters: [String : AnyCodable]

	// MARK: Implementation-Specific Constants

	
	/// Creates a new environment.
	public init(
		populationSize: Int,
		selectionMethod: SelectionMethod,
		selectableProportion: Double,
		mutationRate: Double,
		crossoverRate: Double,
		numberOfElites: Int,
		numberOfEliteCopies: Int,
		parameters: [String : AnyCodable]
	) {
		self.populationSize = populationSize
		self.selectionMethod = selectionMethod
		self.selectableProportion = selectableProportion
		self.mutationRate = mutationRate
		self.crossoverRate = crossoverRate
		self.numberOfElites = numberOfElites
		self.numberOfEliteCopies = numberOfEliteCopies
		self.parameters = parameters
	}
}
