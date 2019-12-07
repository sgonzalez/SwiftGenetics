//
//  GeneticBehaviors.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 11/7/18.
//  Copyright © 2018 Santiago Gonzalez. All rights reserved.
//

/// Defines different techniques for candidate selection.
public enum SelectionMethod: Codable {
	/// Roulette / fitness proportionate selection.
	case roulette
	/// Tournament selection, with a tournament size that's greater than 0.
	case tournament(size: Int)
	/// Takes all the organisms in the population and selects the best portion
	/// of them. `takePortion` is in (0,1].
	case truncation(takePortion: Double)
	
	// MARK: - Coding.
	
	/// Coding keys for `Codable`.
	enum CodingKeys: String, CodingKey {
		case method
		case tournamentSize
		case truncationTakePortion
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		switch self {
		case .roulette:
			try container.encode("roulette", forKey: .method)
		case let .tournament(size: size):
			try container.encode("tournament", forKey: .method)
			try container.encode(size, forKey: .tournamentSize)
		case let .truncation(takePortion: takePortion):
			try container.encode("truncation", forKey: .method)
			try container.encode(takePortion, forKey: .truncationTakePortion)
		}
	}
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		let methodString = try values.decode(String.self, forKey: .method)
		switch methodString {
		case "roulette":
			self = .roulette
		case "tournament":
			let size = try values.decode(Int.self, forKey: .tournamentSize)
			self = .tournament(size: size)
		case "truncation":
			let takePortion = try values.decode(Double.self, forKey: .truncationTakePortion)
			self = .truncation(takePortion: takePortion)
		default:
			fatalError("Unknown method string.")
		}
	}
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
