//
//  File.swift
//  
//
//  Created by Mateusz Grudzień on 04/08/2024.
//

import Foundation

public protocol InjectionKey {
    associatedtype Value
    
    static var currentValue: Self.Value { get set }
}
