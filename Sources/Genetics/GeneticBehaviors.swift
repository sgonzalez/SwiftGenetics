//
//  GeneticBehaviors.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 11/7/18.
//  Copyright © 2018 Santiago Gonzalez. All rights reserved.
//

/// Defines different techniques for candidate selection.
public enum SelectionMethod {
	/// Roulette / fitness proportionate selection.
	case roulette
	/// Tournament selection, with a tournament size that's greater than 0.
	case tournament(size: Int)
	/// Takes all the organisms in the population and selects the best portion
	/// of them. `takePortion` is in (0,1].
	case truncation(takePortion: Double)
}

/// Implemented by types that can undergo mutation.
public protocol Mutatable: GeneticEnvironmentAssociable {
	/// Perform mutation. Non-idempotent.
	mutating func mutate(rate: Double, environment: Environment)
}

/// Implemented by types that can be recombined with a partner.
public protocol Crossoverable: GeneticEnvironmentAssociable {
	/// Perform genetic recombintion with the specified partner. Idempotent.
	func crossover(with partner: Self, rate: Double, environment: Environment) -> (Self, Self)
}
