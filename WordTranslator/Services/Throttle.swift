//
//  Throttle.swift
//  WordTranslator
//
//  Created by Артем Мак on 31.01.2022.
//  Copyright © 2022 Артем Мак. All rights reserved.
//
import UIKit

class Throttle {
    private let delay: TimeInterval
    private var timer: Timer?
    
    init(delay: TimeInterval) {
        self.delay = delay
    }
    
    func run(completion: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { _ in
            completion()
        })
    }
    
    func cancel() {
        timer?.invalidate()
    }
}
