//
//  ContinuousGene.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 10/25/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// The types of mutations that can be performed on a real-valued gene.
public enum ContinuousMutationType {
	/// Add a sample from a uniform distribution, centered at zero, to the value.
	case uniform
	/// Add a sample from a Gaussian distribution, centered at zero, to the value.
	case gaussian
}

/// Keys to the environment's parameters dictionary that a real-valued gene uses.
public enum ContinuousEnvironmentParameter: String {
	/// How large should mutations be.
	case mutationSize // Double
	/// The type of mutations that are performed.
	case mutationType // MutationType
}

/// Represents a single continuous value that can be evolved.
public struct ContinuousGene<R: FloatingPoint, E: GeneticEnvironment>: Gene, Equatable, Hashable {
	public typealias Environment = E
	public typealias Param = ContinuousEnvironmentParameter
	
	/// The gene's value.
	public var value: R
	
	/// Creates a new gene with the given value.
	public init(value: R) {
		self.value = value
	}
	
	mutating public func mutate(rate: Double, environment: ContinuousGene<R, E>.Environment) {
		guard Double.fastRandomUniform() < rate else { return }
		
		// Get environmental mutation parameters.
		guard let mutationSize = environment.parameters[Param.mutationSize.rawValue] as? Double else {
			fatalError("Expected \(Param.mutationSize.rawValue): Double in environment parameters!")
		}
		guard let mutationType = environment.parameters[Param.mutationType.rawValue] as? ContinuousMutationType else {
			fatalError("Expected \(Param.mutationType.rawValue): MutationType in environment parameters!")
		}
		
		// Perform the appropriate mutation.
		switch mutationType {
		case .uniform:
			value += genericize(Double.random(in: (-mutationSize)...mutationSize))
		case .gaussian:
			value += genericize(Double.randomGaussian(mu: 0.0, sigma: mutationSize))
		}
	}
	
	/// Converts the input `Double` into the gene's generic floating-point type.
	/// This is slightly ugly, but I can't think of a cleaner way to do this.
	private func genericize(_ num: Double) -> R {
		switch R.self {
		case is Float.Type:
			return Float(num) as! R
		case is Float80.Type:
			return Float80(num) as! R
		case is Double.Type:
			return num as! R
		default:
			fatalError("Unhandled floating-point type.")
		}
	}
	
	public static func == (lhs: ContinuousGene, rhs: ContinuousGene) -> Bool {
		return lhs.value == rhs.value // TODO: maybe this could cause issues, bad to compare IEEE float equality...
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(value)
	}
}
