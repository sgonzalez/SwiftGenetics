//
//  Population.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 11/7/18.
//  Copyright © 2018 Santiago Gonzalez. All rights reserved.
//

/// Defines broad types of genetic algorithms.
enum EvolutionAlgorithmType {
	/// A standard, single-objective genetic algorithm.
	case standard
}

/// A world of organisms, genericized by a type of genome.
class Population<G: Genome> {
	
	typealias Environment = G.Environment
	
	/// The environment configuration that the population is subject to.
	var environment: Environment
	
	/// The type of evolution that this population undergoes.
	let evolutionType: EvolutionAlgorithmType
	
	/// The organisms in the world. Fit organisms are at the end when sorted.
	var organisms: [Organism<G>] = []
	
	/// The current generation.
	private(set) public var generation = 0
	/// The best organism of all time.
	private(set) public var bestOrganism: Organism<G>?
	/// The best organism in the current generation.
	private(set) public var bestOrganismInGeneration: Organism<G>?
	
	/// The total fitness of all organisms in this generation.
	private(set) internal var totalFitness: Double = 0.0
	/// This average fitness of this generation's organisms.
	private(set) internal var averageFitness: Double = 0.0
	
	/// Creates a new, empty population with the given environment configuration.
	init(environment: Environment, evolutionType: EvolutionAlgorithmType) {
		self.environment = environment
		self.evolutionType = evolutionType
	}
	
	/// Updates the population's fitness metrics for an epoch.
	private func updateFitnessMetrics() {
		totalFitness = 0.0
		var highestSoFar = -Double.greatestFiniteMagnitude
		var lowestSoFar = Double.greatestFiniteMagnitude
		for organism in organisms {
			if organism.fitness != nil {
				if organism.fitness > highestSoFar { // This is a better organism.
					highestSoFar = organism.fitness
					bestOrganismInGeneration = organism
					// Check if we have a new best organism.
					if organism.fitness > bestOrganism?.fitness ?? -Double.greatestFiniteMagnitude {
						bestOrganism = organism
					}
				}
				if organism.fitness < lowestSoFar { // This is a worse organism.
					lowestSoFar = organism.fitness
				}
				totalFitness += organism.fitness
			}
		}
		averageFitness = totalFitness / Double(organisms.count)
	}
	
	/// Performs an evolutionary epoch.
	func epoch() {
		// Get this generation's population.
		switch evolutionType {
		case .standard:
			// Sort existing population. Fit organisms are at the end.
			organisms.sort()
		}
		
		// Update the population's fitness metrics for the epoch.
		updateFitnessMetrics()
		
		// Create a new, empty population.
		var newOrganisms = [Organism<G>]()
		
		// Perform elite sampling.
		newOrganisms.append(contentsOf: elitesFromPopulation())
		
		// Sample parents.
		let numberOfParents = (environment.populationSize - newOrganisms.count) + ((environment.populationSize - newOrganisms.count) % 2)
		var parents = [Organism<G>]()
		switch environment.selectionMethod {
		case .roulette:
			guard environment.selectableProportion == 1.0 else { fatalError("Unimplemented.") } // TODO: Support roulette sampling with `selectableProportion`.
			parents = (0..<numberOfParents).map { _ in organismFromRoulette() }
		case let .tournament(size: size):
			parents = (0..<numberOfParents).map { _ in organismFromTournament(size: size) }
		case let .truncation(takePortion: portion):
			while parents.count < numberOfParents {
				parents += organisms.suffix(Int(Double(organisms.count) * portion * environment.selectableProportion)).suffix(numberOfParents) // NOTE: the truncation's `takePortion` stacks on top of the environment's `selectableProportion`.
			}
			parents = parents.suffix(numberOfParents)
		}
		assert(parents.count == numberOfParents)
		
		// Reproduce until the population is the desired size.
		let matings: [(Organism<G>, Organism<G>)] = (0..<parents.count/2).map { (parents[$0*2], parents[$0*2+1]) }
		for mating in matings {
			// Perform sampling.
			let progenitorA = mating.0
			let progenitorB = mating.1
			// Perform crossover.
			var (progenyGenomeA, progenyGenomeB) = progenitorA.genotype.crossover(with: progenitorB.genotype, rate: environment.crossoverRate, environment: environment)
			// Perform mutation.
			progenyGenomeA.mutate(rate: environment.mutationRate, environment: environment)
			progenyGenomeB.mutate(rate: environment.mutationRate, environment: environment)
			// Add children to the population.
			newOrganisms.append(Organism<G>(fitness: nil, genotype: progenyGenomeA, birthGeneration: generation))
			newOrganisms.append(Organism<G>(fitness: nil, genotype: progenyGenomeB, birthGeneration: generation))
		}
		
		// Replace the old population.
		assert(newOrganisms.count == organisms.count)
		organisms = newOrganisms
		generation += 1
	}
}
