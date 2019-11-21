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
public protocol DiscreteChoice: CaseIterable, Hashable { }

/// A single gene that represents a discrete, categorical choice.
public struct DiscreteChoiceGene<C: DiscreteChoice, E: GeneticEnvironment>: Gene {
	public typealias Environment = E
	
	/// The gene's value.
	public var choice: C
	
	/// Creates a new gene with the given discrete value.
	public init(choice: C) {
		self.choice = choice
	}
	
	mutating public func mutate(rate: Double, environment: DiscreteChoiceGene<C, E>.Environment) {
		guard Double.fastRandomUniform() < rate else { return }
		
		// Select a new choice randomly.
		choice = C.allCases.filter { $0 != choice }.randomElement()!
	}
}

extension DiscreteChoiceGene: RawRepresentable {
	public typealias RawValue = C
	public var rawValue: RawValue { return choice }
	public init?(rawValue: RawValue) {
		self = DiscreteChoiceGene.init(choice: rawValue)
	}
}

