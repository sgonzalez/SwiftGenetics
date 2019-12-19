import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
		testCase(GeneticAlgorithmIntegrationTests.allTests),
		testCase(PopulationCheckpointingTests.allTests)
    ]
}
#endif
