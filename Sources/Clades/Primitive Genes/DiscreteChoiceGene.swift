//
//  DiscreteChoiceGene.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 7/25/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// DIfferent types of categorical distributions should implement this protocol.
/// - Note: Any `CaseIterable` `enum` supports `DiscreteChoice` out of the box.
protocol DiscreteChoice: CaseIterable, Hashable { }

/// A single gene that represents a discrete, categorical choice.
struct DiscreteChoiceGene<C: DiscreteChoice, E: GeneticEnvironment>: Gene {
	typealias Environment = E
	
	/// The gene's value.
	var choice: C
	
	mutating func mutate(rate: Double, environment: DiscreteChoiceGene<C, E>.Environment) {
		guard Double.fastRandomUniform() < rate else { return }
		
		// Select a new choice randomly.
		choice = C.allCases.filter { $0 != choice }.randomElement()!
	}
}

extension DiscreteChoiceGene: RawRepresentable {
	typealias RawValue = C
	var rawValue: RawValue { return choice }
	init?(rawValue: RawValue) {
		self = DiscreteChoiceGene.init(choice: rawValue)
	}
}

