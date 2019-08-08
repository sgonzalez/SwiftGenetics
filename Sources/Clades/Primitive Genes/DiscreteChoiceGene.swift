//
//  DiscreteChoiceGene.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 7/25/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

protocol DiscreteChoice: CaseIterable, Hashable { }

struct DiscreteChoiceGene<C: DiscreteChoice, E: GeneticEnvironment>: Gene {
	typealias Environment = E
	
	var choice: C
	
	mutating func mutate(rate: Double, environment: DiscreteChoiceGene<C, E>.Environment) {
		guard Double.random(in: 0..<1) < rate else { return }
		
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

