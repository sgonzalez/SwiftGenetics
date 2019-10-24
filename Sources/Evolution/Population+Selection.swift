//
//  Population+Selection.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 6/27/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

extension Population {
	
	/// Performs elite selection. This function assumes that organisms
	/// are sorted in ascending order.
	internal func elitesFromPopulation() -> [Organism<G>] {
		guard environment.numberOfEliteCopies * environment.numberOfElites % 2 == 0 else {
			fatalError("Must be an even number for roulette sampling to work.")
		}
		var elites = [Organism<G>]()
		for _ in 0..<environment.numberOfEliteCopies {
			elites.append(contentsOf: organisms.suffix(environment.numberOfElites))
		}
		return elites
	}
	
	/// Perform roulette sampling to get an organism.
	internal func organismFromRoulette() -> Organism<G> {
		guard totalFitness != 0 else {
			return organisms.randomElement()!
		}
		let slice = totalFitness > 0 ? Double.random(in: 0..<totalFitness) : 0.0
		var cumulativeFitness = 0.0
		for organism in organisms {
			cumulativeFitness += organism.fitness
			if cumulativeFitness >= slice {
				return organism
			}
		}
		return organisms.first!
	}
	
	/// Perform tournament sampling to get an organism.
	internal func organismFromTournament(size: Int) -> Organism<G> {
		let selectableCount = Int(Double(organisms.count) * environment.selectableProportion)
		let playerIndices = (0..<size).map { _ in Int.random(in: (organisms.count - selectableCount)..<organisms.count) }
		return organisms[playerIndices.max()!] // This cool trick works because the organisms are sorted with ascending fitnesses. Not to toot my own horn, but this optimization has such a palpable elegance to it.
	}
	
}
