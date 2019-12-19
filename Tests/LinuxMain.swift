import XCTest

import SwiftGeneticsTests

var tests = [XCTestCaseEntry]()
tests += GeneticAlgorithmIntegrationTests.allTests()
tests += PopulationCheckpointingTests.allTests()
XCTMain(tests)
