import XCTest
import SwiftGenetics

final class PopulationCheckpointingTests: XCTestCase {
	typealias RealGene = ContinuousGene<Double, LivingStringEnvironment>
	typealias NeuroevolutionString = LivingStringGenome<RealGene>
	
	func testStringPopulationPersistence() {
		// Define an environment that changes nothing.
		let environment = LivingStringEnvironment(
			populationSize: 4,
			selectionMethod: .tournament(size: 2),
			selectableProportion: 1.0,
			mutationRate: 0.0,
			crossoverRate: 0.0,
			numberOfElites: 4,
			numberOfEliteCopies: 1,
			parameters: [
				ContinuousEnvironmentParameter.mutationSize.rawValue: AnyCodable(0.0),
				ContinuousEnvironmentParameter.mutationType.rawValue: AnyCodable(ContinuousMutationType.uniform.rawValue)
			]
		)
		// Build initial population.
		let population = Population<NeuroevolutionString>(environment: environment, evolutionType: .standard)
		for i in 0..<environment.populationSize {
			let genes = [RealGene(value: Double(i)), RealGene(value: Double(i))]
			let genotype = NeuroevolutionString(genes: genes)
			let organism = Organism<LivingStringGenome>(fitness: nil, genotype: genotype)
			population.organisms.append(organism)
		}
		// Perform one epoch.
		population.epoch()
		// Save population.
		let tmpCheckpointURL = URL(fileURLWithPath: "/tmp/swiftgenetics_tests_\(UUID().uuidString)")
		try! CheckpointManager<NeuroevolutionString>.save(population, to: tmpCheckpointURL)
		// Read population.
		let reconstitutedPopulation = try! CheckpointManager<NeuroevolutionString>.population(from: tmpCheckpointURL)
		// Perform checks.
		XCTAssertEqual(population.generation, reconstitutedPopulation.generation)
		XCTAssertEqual(population.organisms, reconstitutedPopulation.organisms)
		let originalJSON = try! JSONEncoder().encode(population)
		let reconstitutedJSON = try! JSONEncoder().encode(reconstitutedPopulation)
		XCTAssertEqual(originalJSON, reconstitutedJSON)
		// Cleanup
		try! FileManager.default.removeItem(at: tmpCheckpointURL)
	}

    static var allTests = [
        ("testStringPopulationPersistence", testStringPopulationPersistence),
    ]
}
