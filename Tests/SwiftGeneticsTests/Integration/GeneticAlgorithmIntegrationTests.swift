import XCTest
import SwiftGenetics

final class GeneticAlgorithmIntegrationTests: XCTestCase {
	typealias RealGene = ContinuousGene<Double, LivingStringEnvironment>
	typealias NeuroevolutionString = LivingStringGenome<RealGene>
	
	/// Evaluates whether strings are sorted in ascending order. One point is added
	/// to the fitness for each consecutive pair of sorted values.
	struct SortedFitnessEvaluator: SynchronousFitnessEvaluator {
		typealias G = NeuroevolutionString
		mutating func fitnessFor(organism: Organism<G>, solutionCallback: (G, Double) -> ()) -> FitnessResult {
			var fitness = 0.0
			for i in 0..<(organism.genotype.genes.count - 1) {
				let left = organism.genotype.genes[i]
				let right = organism.genotype.genes[i+1]
				if left.value < right.value {
					fitness += 1
				}
			}
			return FitnessResult(fitness: fitness)
		}
	}
	
	struct MockLogDelegate: EvolutionLoggingDelegate {
		typealias G = NeuroevolutionString
		
		func evolutionStartingEpoch(_ i: Int) {
			
		}
		
		func evolutionFinishedEpoch(_ i: Int, duration: TimeInterval, population: Population<G>) {
			
		}
		
		func evolutionFoundSolution(_ solution: G, fitness: Double) {
			
		}
	}
	
	/// Runs a GA that aims to find a sorted string of real numbers.
	/// NOTE: this test is stochastic and may fail once in a blue moon.
    func testSortingGA() {
		let maxEpochs = 20
		let stringLength = 4
		// Define environment.
		let environment = LivingStringEnvironment(
			populationSize: 20,
			selectionMethod: .tournament(size: 2),
			selectableProportion: 1.0,
			mutationRate: 0.1,
			crossoverRate: 0.5,
			numberOfElites: 4,
			numberOfEliteCopies: 1,
			parameters: [
				ContinuousEnvironmentParameter.mutationSize.rawValue: AnyCodable(0.1),
				ContinuousEnvironmentParameter.mutationType.rawValue: AnyCodable(ContinuousMutationType.uniform)
			]
		)
		// Build initial population.
		let population = Population<NeuroevolutionString>(environment: environment, evolutionType: .standard)
		for _ in 0..<environment.populationSize {
			// Create random vectors where `x_i ~ Uniform(0,1)`.
			let weights = (0..<stringLength).map { _ in Double.fastRandomUniform() }
			let genes = weights.map { RealGene(value: $0) }
			let genotype = NeuroevolutionString(genes: genes)
			let organism = Organism<LivingStringGenome>(fitness: nil, genotype: genotype)
			population.organisms.append(organism)
		}
		// Evolve!
		let evaluator = SortedFitnessEvaluator()
		let logDelegate = MockLogDelegate()
		let ga = ConcurrentSynchronousEvaluationGA(fitnessEvaluator: evaluator, loggingDelegate: logDelegate)
		let evolutionConfig = EvolutionAlgorithmConfiguration(maxEpochs: maxEpochs, algorithmType: population.evolutionType)
		ga.evolve(population: population, configuration: evolutionConfig)
		// Check solution.
		let bestOrganism = population.bestOrganism!
		let bestVector = bestOrganism.genotype.genes.map { $0.value }
		XCTAssertEqual(bestVector, bestVector.sorted())
    }

    static var allTests = [
        ("testSortingGA", testSortingGA),
    ]
}
