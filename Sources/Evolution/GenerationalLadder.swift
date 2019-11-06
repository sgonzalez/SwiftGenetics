//
//  GenerationalLadder.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 10/25/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// The core population structure in GALT.
struct GenerationalLadder<G: Genome> {
	
	/// A ranked reference to an organism.
	struct RankedOrganism {
		var rank: Double
		var generation: Int
		var organism: Organism<G>
	}
	
	/// The main data structure in the generational ladder; every organism that has ever been evaluated.
	var census = [RankedOrganism]()
	
	/// The previous ranked organism's loss vector.
	var lastLosses = [Double]()
	/// The previous rank value.
	var lastRank = Double.infinity
	
	/// The current generation. Starts at one because it takes one generation to get fitnesses back.
	var currentGeneration: Int = 1
	
	/// Called whenever a new organism's fitness is evaluated.
	mutating func processNew(organism: Organism<G>) {
		// Avoid reprocessing elites.
		if let eliteIndex = census.firstIndex(where: { $0.organism == organism }) {
			census[eliteIndex].generation = currentGeneration // We still need to add the elite to the census in the current generation.
			return
		}
		// Ensure we've collected sample losses.
		guard var organismLosses = organism.individualSampleLosses, !organismLosses.isEmpty else {
			print(organism)
			fatalError("Organisms must have individual sample losses when using GALT.")
		}
		
		// Calculate the organism's ranking according to "The Ladder", Avrim Blum and Moritz Hardt.
		
		let n = organismLosses.count
		if lastLosses.isEmpty {
			lastLosses = [Double](repeating: 0.0, count: n)
		}
		let s = zip(organismLosses, lastLosses).map { $0 - $1 }.standardDeviation()
		let empiricalLoss = organismLosses.mean()
		
		var rank: Double!
		if empiricalLoss < lastRank - s / sqrt(Double(n)) {
			rank = round(empiricalLoss * Double(n)) / Double(n) // The empirical loss rounded to the nearest integer multiple of 1/n.
		} else {
			rank = lastRank
			organismLosses = lastLosses
		}
		
		// Add to the census.
		let rankedOrganism = RankedOrganism(rank: rank, generation: currentGeneration, organism: organism)
		census.append(rankedOrganism)
		
		// Get ready for next organism.
		lastRank = rank
		lastLosses = organismLosses
	}
	
	/// Called at the beginning of each generation, after processing the previous
	/// generation's organisms, to get a sorted population.
	/// - Note: Do not call at the beginning of generation zero (i.e., before any fitnesses have been calculated).
	mutating func newGenerationSortedOrganisms() -> [Organism<G>] {
		// Sort the census by rank (higher-ranked organisms at the end).
		census.sort(by: { $1.rank > $0.rank })
		
		// Build sorted population data structure.
		let sortedPopulation = census.filter { $0.generation == currentGeneration }.map { $0.organism }
		assert(!sortedPopulation.isEmpty)
		
		// Get ready for The Next Generation. These are the voyages of the starship Enterprise...
		currentGeneration += 1
		
		// Return.
		return sortedPopulation
	}
}
