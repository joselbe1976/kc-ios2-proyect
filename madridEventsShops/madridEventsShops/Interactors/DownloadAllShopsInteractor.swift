//
//  DownloadAllShopsInteractor.swift
//  MadridShops
//
//  Created by Diego Freniche Brito on 07/09/2017.
//  Copyright © 2017 KC. All rights reserved.
//

import Foundation

protocol DownloadAllShopsInteractor {
    // execute: downloads all shops. Return on the main thread
    func execute(onSuccess: @escaping (Shops) -> Void, onError: errorClosure)
    func execute(onSuccess: @escaping (Shops) -> Void)
}
