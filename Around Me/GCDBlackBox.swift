//
//  GCDBlackBox.swift
//  Mappaa
//
//  Created by Shehryar Bajwa on 2018-08-20.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation


func performUIUpdatesonMain(_ updates: @ escaping () -> Void){
    DispatchQueue.main.async {
        updates()
    }
    
}
