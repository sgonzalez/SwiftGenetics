//
//  LivingTree+RandomGenesis.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 6/27/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

extension LivingTreeGene {
	
	/// Returns a random, recursively built tree subject to certain constraints.
	static func random(onlyNonLeaf: Bool = false, depth: Int = 1, parent: LivingTreeGene? = nil, template: TreeGeneTemplate<GeneType>) -> LivingTreeGene {
		let randomType = onlyNonLeaf ? template.nonLeafTypes.randomElement()! : template.allTypes.randomElement()!
		let gene = LivingTreeGene(template, geneType: randomType, parent: parent, children: [])
		if randomType.isBinaryType {
			if depth == 1 {
				gene.children = [
					LivingTreeGene(template, geneType: template.leafTypes.randomElement()!, parent: gene, children: []),
					LivingTreeGene(template, geneType: template.leafTypes.randomElement()!, parent: gene, children: [])
				]
			} else {
				gene.children = [
					random(onlyNonLeaf: onlyNonLeaf, depth: depth - 1, parent: gene, template: template),
					random(onlyNonLeaf: onlyNonLeaf, depth: depth - 1, parent: gene, template: template)
				]
			}
		} else if randomType.isUnaryType {
			gene.children = [LivingTreeGene(template, geneType: template.leafTypes.randomElement()!, parent: gene, children: [])]
		} else if randomType.isLeafType {
			// nop
		} else {
			fatalError()
		}
		return gene
	}
}
