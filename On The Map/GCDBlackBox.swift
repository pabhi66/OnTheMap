//
//  GCDBlackBozx.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/21/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
