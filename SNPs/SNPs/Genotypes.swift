//
//  Genotypes.swift
//  SNPs
//
//  Created by Sarah Anderson on 12/8/14.
//  Copyright (c) 2014 Sarah Anderson. All rights reserved.
//

import Foundation
import UIKit

struct Genotypes {
  //  var geneName: String
    var geneSNP: String
    var geneCall: String
 //   var mutationResult: String
 //   var geneGroup: String
 //   var summary: String
 //   var avoids: String
 //   var beneficials: String
    
    init(geneDictionary: NSDictionary) {
        
        let myGeneResults = geneDictionary["genotypes"] as NSDictionary
        
        geneSNP = myGeneResults["location"] as String
        geneCall = myGeneResults["call"] as String
        
    
    }
}