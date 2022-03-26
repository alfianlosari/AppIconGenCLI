//
//  IconFileGeneratorService.swift
//  XCAIconGenerator
//
//  Created by Alfian Losari on 19/03/22.
//

import Foundation
import SwiftGD

protocol IconFileGeneratorServiceProtocol {
    
    func generateIconsURL(for appIconTypes: [AppIconType], with image: Image, path: String) async throws
    
}

struct IconFileGeneratorService: IconFileGeneratorServiceProtocol {
    
    let fileService: FileIconServiceProtocol
    let resizeService: IconResizerServiceProtocol
    
    func generateIconsURL(for appIconTypes: [AppIconType], with image: Image, path: String) async throws {
        self.fileService.deleteExistingTemporaryDirectoryURL()
        
        for appIconType in appIconTypes {
            let icons = try await self.resizeService.resizeIcons(from: image, for: appIconType)
            try await self.fileService.saveIconsToTemporaryDir(icons: icons, appIconType: appIconType)
        }
        
        try await self.fileService.archiveTemporaryDirectoryToPath(path)
    }
    
}
