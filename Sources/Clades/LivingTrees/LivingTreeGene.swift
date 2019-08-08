//
//  LivingTreeGene.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 11/15/18.
//  Copyright © 2018 Santiago Gonzalez. All rights reserved.
//

import Foundation

/// An element in a genetic tree, which can recursively contain a subtree of tree genes.
final class LivingTreeGene<GeneType: TreeGeneType>: Gene {
	typealias Environment = LivingTreeEnvironment
	
	/// The sampling template that's used for the gene types.
	var template: TreeGeneTemplate<GeneType>
	
	/// The gene's type marker.
	var geneType: GeneType
	/// A weak reference to the gene's parent gene, or `nil` if it's the root.
	weak var parent: LivingTreeGene?
	/// Owned references to child genes.
	var children: [LivingTreeGene]
	
	/// A coefficient that isn't modified during evolution. It's a placeholder
	/// that can be used later with CMA-ES.
	var coefficient: Double?
	/// Whether the gene takes a coefficient.
	var allowsCoefficient: Bool
	
	/// Creates a new tree gene.
	init(_ template: TreeGeneTemplate<GeneType>, geneType: GeneType, parent: LivingTreeGene?, children: [LivingTreeGene], allowsCoefficient: Bool = true) {
		self.template = template
		self.geneType = geneType
		self.parent = parent
		self.children = children
		self.allowsCoefficient = allowsCoefficient
	}
	
	func mutate(rate: Double, environment: Environment) {
		guard Double.random(in: 0..<1) < rate else { return }
		
		performGeneTypeSpecificMutations(rate: rate, environment: environment)
		
		var madeStructuralMutation = false
		
		// Deletion mutations.
		if Double.random(in: 0..<1) < environment.structuralMutationDeletionRate {
			if !children.isEmpty {
				children = []
				geneType = template.leafTypes.randomElement()!
				madeStructuralMutation = true
			}
		}
		
		// Addition mutations.
		if Double.random(in: 0..<1) < environment.structuralMutationAdditionRate {
			if children.isEmpty {
				geneType = template.nonLeafTypes.randomElement()!
				if geneType.isBinaryType {
					children = [
						LivingTreeGene(template, geneType: template.leafTypes.randomElement()!, parent: self, children: []),
						LivingTreeGene(template, geneType: template.leafTypes.randomElement()!, parent: self, children: [])
					]
				} else if geneType.isUnaryType {
					children = [LivingTreeGene(template, geneType: template.leafTypes.randomElement()!, parent: self, children: [])]
				} else if geneType.isLeafType {
					// nop
				} else {
					fatalError()
				}
				madeStructuralMutation = true
			}
		}
		
		// Attempt to mutate type, maintaining the same structure, only if a
		// structural mutation has not already been made.
		if !madeStructuralMutation {
			if geneType.isBinaryType {
				geneType = template.binaryTypes.filter { $0 != geneType }.randomElement()!
			} else if geneType.isUnaryType {
				geneType = template.unaryTypes.filter { $0 != geneType }.randomElement() ?? template.unaryTypes.first!
			} else if geneType.isLeafType {
				geneType = template.leafTypes.filter { $0 != geneType }.randomElement()!
			} else {
				fatalError()
			}
		}
	}
	
	/// Performs a bottom-up, depth-first enumeration of the tree, including self.
	func bottomUpEnumerate(eachNode fn: (LivingTreeGene) -> ()) {
		for child in children {
			child.bottomUpEnumerate(eachNode: fn)
		}
		fn(self)
	}
	
	/// Returns all nodes in the subtree, including the current gene.
	var allNodes: [LivingTreeGene] {
		var nodes: [LivingTreeGene] = [self]
		for child in children {
			nodes.append(contentsOf: child.allNodes)
		}
		return nodes
	}
	
	/// Creates a deep copy of the gene.
	func copy(withParent: LivingTreeGene? = nil) -> LivingTreeGene {
		let newGene = LivingTreeGene(template, geneType: geneType, parent: withParent, children: [], allowsCoefficient: allowsCoefficient)
		newGene.children = children.map { $0.copy(withParent: newGene) }
		return newGene
	}
	
	/// Rebuilds parent connections from child connections.
	func recursivelyResetParents() {
		for child in children {
			child.parent = self
			child.recursivelyResetParents()
		}
	}
	
}

extension LivingTreeGene {
	/// Perform mutations that are specific to the living tree's `GeneType`.
	func performGeneTypeSpecificMutations(rate: Double, environment: Environment) {
		// Default implementation is intentionally empty.
	}
}