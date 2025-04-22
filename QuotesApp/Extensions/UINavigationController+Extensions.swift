//
//  UINavigationController+Extensions.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 08/04/2025.
//

import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
