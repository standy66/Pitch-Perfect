//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Andrew Stepanov on 29/01/16.
//  Copyright © 2016 Andrew Stepanov. All rights reserved.
//

import Foundation

class RecordedAudio {
    var title: String
    var filePathUrl: NSURL
    
    init(title: String, filePathUrl: NSURL) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
}