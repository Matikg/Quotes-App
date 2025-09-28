//
//  CameraAccessManager.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 28/05/2025.
//

import Foundation
import AVFoundation

enum CameraAccessStatus {
    case authorized
    case denied
    case notDetermined
}

protocol CameraAccessManagerInterface {
    func checkCameraAccess() async -> CameraAccessStatus
    func shouldAskForCameraAccess() -> Bool
}

final class CameraAccessManager: CameraAccessManagerInterface {
    func checkCameraAccess() async -> CameraAccessStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return .authorized
        case .notDetermined:
            let granted = await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    continuation.resume(returning: granted)
                }
            }
            return granted ? .authorized : .denied
        case .denied, .restricted:
            return .denied
        @unknown default:
            return .denied
        }
    }
    
    func shouldAskForCameraAccess() -> Bool {
        AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined
    }
}
