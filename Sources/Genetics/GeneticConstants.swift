//
//  GeneticConstants.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 11/7/18.
//  Copyright © 2018 Santiago Gonzalez. All rights reserved.
//

/// A basic collection of constants in any genetic algorithm.
public protocol GeneticConstants {
	/// The number of entities in the population.
	var populationSize: Int { get }
	
	/// The selection method that is to be used.
	var selectionMethod: SelectionMethod { get }
	/// The proportion of the sorted population that is eligible for selection, between 0 and 1.
	var selectableProportion: Double { get }
	
	/// Mutation rate, between 0 and 1.
	var mutationRate: Double { get }
	/// Cross-over rate, between 0 and 1.
	var crossoverRate: Double { get }
	
	/// The number of elites in each generation, set to 0 to disable elitism.
	/// Must be an even number.
	var numberOfElites: Int { get }
	/// The number of copies of each elite that are passed down to the next generation.
	var numberOfEliteCopies: Int { get }
	
	/// A dictionary of additional parameters.
	var parameters: [String: AnyCodable] { get }
}
