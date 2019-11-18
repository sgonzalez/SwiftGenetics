//
//  Double+ProbabilityDistributions.swift
//  SwiftGenetics
//
//  Created by Santiago Gonzalez on 4/21/19.
//  Copyright © 2019 Santiago Gonzalez. All rights reserved.
//

import Foundation

extension Double {
	
	/// Returns a random number sampled from the specified Gaussian distribution.
	static func randomGaussian(mu: Double, sigma: Double) -> Double {
		let p0 = 0.322232431088
		let p1 = 1.0
		let p2 = 0.342242088547
		let p3 = 0.204231210245e-1
		let p4 = 0.453642210148e-4
		let q0 = 0.099348462606
		let q1 = 0.588581570495
		let q2 = 0.531103462366
		let q3 = 0.103537752850
		let q4 = 0.385607006340e-2
		var u = 0.0
		var t = 0.0
		var p = 0.0
		var q = 0.0
		var z = 0.0
		
		u = Double.fastRandomUniform()
		if u < 0.5 {
			t = sqrt(-2.0 * log(u))
		} else {
			t = sqrt(-2.0 * log(1.0 - u))
		}
		p = p0 + t * (p1 + t * (p2 + t * (p3 + t * p4)))
		q = q0 + t * (q1 + t * (q2 + t * (q3 + t * q4)))
		if u < 0.5 {
			z = (p / q) - t
		} else {
			z = t - (p / q)
		}
		return (mu + sigma * z)
	}
}
