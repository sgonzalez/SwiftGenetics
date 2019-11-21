//
//  LivingTreeEnvironment.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 6/27/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// The environment configuration for an ecosystem of living trees.
public struct LivingTreeEnvironment: GeneticEnvironment {
	
	// MARK: Genetic Constants
	
	public var populationSize: Int
	public var selectionMethod: SelectionMethod
	public var selectableProportion: Double
	public var mutationRate: Double
	public var crossoverRate: Double
	public var numberOfElites: Int
	public var numberOfEliteCopies: Int
	public var parameters: [String : Any]
	
	// MARK: Implementation-Specific Constants
	
	/// The maximum amount a scalar can drift during a mutation.
	public var scalarMutationMagnitude: Int
	
	/// How often deletion mutations take place, between 0 and 1.
	public var structuralMutationDeletionRate: Double
	/// How often addition mutations take place, between 0 and 1.
	public var structuralMutationAdditionRate: Double
	
	
	/// Creates a new environment.
	public init(
		populationSize: Int,
		selectionMethod: SelectionMethod,
		selectableProportion: Double,
		mutationRate: Double,
		crossoverRate: Double,
		numberOfElites: Int,
		numberOfEliteCopies: Int,
		parameters: [String : Any],
		scalarMutationMagnitude: Int,
		structuralMutationDeletionRate: Double,
		structuralMutationAdditionRate: Double
	) {
		self.populationSize = populationSize
		self.selectionMethod = selectionMethod
		self.selectableProportion = selectableProportion
		self.mutationRate = mutationRate
		self.crossoverRate = crossoverRate
		self.numberOfElites = numberOfElites
		self.numberOfEliteCopies = numberOfEliteCopies
		self.parameters = parameters
		self.scalarMutationMagnitude = scalarMutationMagnitude
		self.structuralMutationAdditionRate = structuralMutationAdditionRate
		self.structuralMutationDeletionRate = structuralMutationDeletionRate
	}
}
