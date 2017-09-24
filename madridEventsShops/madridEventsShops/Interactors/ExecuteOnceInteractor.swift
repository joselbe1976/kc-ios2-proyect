//
//  ExecuteOnce.swift
//  MadridShops
//
//  Created by Diego Freniche Brito on 18/09/2017.
//  Copyright © 2017 KC. All rights reserved.
//

import Foundation

protocol ExecuteOnceInteractor {
    func execute(closure: () -> Void)
}
