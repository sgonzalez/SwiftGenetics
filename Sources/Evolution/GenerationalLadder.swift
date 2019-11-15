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
	
	private let canClimbDownLadder = false
	private let isGenerational = false
	private let ageismSorting = false
	
	/// A ranked reference to an organism.
	struct RankedOrganism {
		/// Rank from the ladder.
		var rank: Double
		/// Rank from the ladder that takes low ranks into account correctly.
		var galtRank: Double
		/// The generation's index.
		var generation: Int
		/// The organism.
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
	
	var earliestBestOrganism: RankedOrganism? {
		return census.filter { $0.generation == currentGeneration }.sorted { $1.generation > $0.generation }.first
	}
	
	private var intraGenerationalLastLosses = [Double]()
	private var intraGenerationalLastRank = Double.infinity
	
	/// Called whenever a new organism's fitness is evaluated.
	mutating func processNew(organism: Organism<G>) {
		// Avoid reprocessing elites.
		if let eliteIndex = census.firstIndex(where: { $0.organism.uuid == organism.uuid }) {
			census[eliteIndex].generation = currentGeneration // We still need to add the elite to the census in the current generation.
//			let rankedOrganism = RankedOrganism(rank: census[eliteIndex].rank, galtRank: census[eliteIndex].galtRank, generation: currentGeneration, organism: organism) // Duplicate the elite in the census for the current generation.
//			census.append(rankedOrganism)
			return
		}
		// Ensure we've collected sample losses.
		guard var organismLosses = organism.individualSampleLosses, !organismLosses.isEmpty else {
			print(organism)
			fatalError("Organisms must have individual sample losses when using GALT.")
		}
		
		// Calculate the organism's ranking according to "The Ladder", Avrim Blum and Moritz Hardt.
		
		let n = organismLosses.count
		if intraGenerationalLastLosses.isEmpty {
			intraGenerationalLastLosses = [Double](repeating: 0.0, count: n)
		}
		let s = zip(organismLosses, intraGenerationalLastLosses).map { $0 - $1 }.standardDeviation()
		let empiricalLoss = organismLosses.mean()
		
		var rank: Double!
		var galtRank: Double!
		
		// Check if we can climb the ladder.
		if empiricalLoss < intraGenerationalLastRank - s / sqrt(Double(n)) {
			rank = round(empiricalLoss * Double(n)) / Double(n) // The empirical loss rounded to the nearest integer multiple of 1/n.
			
			galtRank = rank
		} else {
			rank = intraGenerationalLastRank
			organismLosses = intraGenerationalLastLosses
			
			if canClimbDownLadder {
				galtRank = min(rank, round(empiricalLoss * Double(n)) / Double(n)) // The empirical loss rounded to the nearest integer multiple of 1/n.
			} else {
				galtRank = rank
			}
		}
		
		// Add to the census.
		assert(rank != Double.infinity)
		let rankedOrganism = RankedOrganism(rank: rank, galtRank: galtRank, generation: currentGeneration, organism: organism)
		census.append(rankedOrganism)
		
		// Get ready for next organism.
		lastRank = rank
		lastLosses = organismLosses
		
		if !isGenerational {
			intraGenerationalLastRank = lastRank
			intraGenerationalLastLosses = lastLosses
		}
	}
	
	/// Called at the beginning of each generation, after processing the previous
	/// generation's organisms, to get a sorted population.
	/// - Note: Do not call at the beginning of generation zero (i.e., before any fitnesses have been calculated).
	mutating func newGenerationSortedOrganisms() -> [Organism<G>] {
		// Close-off the generation.
		intraGenerationalLastRank = lastRank
		intraGenerationalLastLosses = lastLosses
		
		// Sort the census by rank (higher-ranked organisms at the end). Subsequently sort by age (earlier-generation organisms at the end).
		census.sort {
			if $0.galtRank != $1.galtRank {
				return $1.galtRank > $0.galtRank
			} else {
				if ageismSorting {
					return $1.generation < $0.generation
				} else {
					return Bool.random() // randomly sort
				}
			}
		}
		
		// Build sorted population data structure.
		let sortedPopulation = census.filter { $0.generation == currentGeneration }.map { $0.organism }
		assert(!sortedPopulation.isEmpty)
		
		// Get ready for The Next Generation. These are the voyages of the starship Enterprise...
		currentGeneration += 1
		
		// Return.
		return sortedPopulation
	}
}
