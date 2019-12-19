//
//  File.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 12/18/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

public struct CheckpointManager<G: Genome> {
	
	/// Returns the population for a checkpoint at the given file URL.
	static public func population(from checkpoint: URL) throws -> Population<G> {
		let jsonData = try Data(contentsOf: checkpoint)
		return try JSONDecoder().decode(Population<G>.self, from: jsonData)
	}
	
	/// Creates a new checkpoint for the provided population and saves it to the specified file.
	static public func save(_ population: Population<G>, to checkpoint: URL) throws {
		let jsonData = try JSONEncoder().encode(population)
		try jsonData.write(to: checkpoint)
	}
	
}
