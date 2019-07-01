//
//  LivingTree+Equatable.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 6/13/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

extension LivingTreeGene: Equatable {
	
	// NOTE: does not compare parents.
	static func == (lhs: LivingTreeGene, rhs: LivingTreeGene) -> Bool {
		return
			lhs.coefficient == rhs.coefficient &&
			lhs.allowsCoefficient == rhs.allowsCoefficient &&
			lhs.geneType == rhs.geneType &&
			lhs.children == rhs.children
	}
	
}
