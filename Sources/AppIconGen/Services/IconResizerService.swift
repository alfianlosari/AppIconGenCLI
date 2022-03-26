//
//  IconResizerService.swift
//  XCAIconGenerator
//
//  Created by Alfian Losari on 19/03/22.
//

import Foundation
import SwiftGD

protocol IconResizerServiceProtocol {
    
    func resizeIcons(from image: Image, for appIconType: AppIconType) async throws -> [AppIcon]
    
}

struct IconResizerService: IconResizerServiceProtocol {
    
    func resizeIcons(from image: Image, for appIconType: AppIconType) async throws -> [AppIcon] {
        let icons = appIconType.templateAppIcons
        return try await withThrowingTaskGroup(of: AppIcon.self) { group in
            var results = [AppIcon]()
            for icon in icons {
                group.addTask { try await self.iconResizedData(from: image, appIcon: icon) }
            }
            
            for try await iconData in group {
                results.append(iconData)
            }
            
            return results
        }
    }
    
    private func iconResizedData(from image: Image, appIcon: AppIcon) async throws -> AppIcon {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<AppIcon, Swift.Error>) in 
            let size = CGSize(width: appIcon.point * appIcon.scale, height: appIcon.point * appIcon.scale)
            guard let thumbnail = image.resizedTo(width: Int(size.width), height: Int(size.height)),
                let data = try? thumbnail.export(as: .png)
            else {
                continuation.resume(throwing: NSError(domain: "XCA", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to generate thumbnail data"]))
                return
            }
            continuation.resume(returning: AppIcon(idiom: appIcon.idiom, point: appIcon.point, scale: appIcon.scale, data: data, watchRole: appIcon.watchRole, watchSubtype: appIcon.watchSubtype))
        
        }
    }
    
}
