

import Foundation

protocol FileIconServiceProtocol {
    
    func deleteExistingTemporaryDirectoryURL()
    func saveIconsToTemporaryDir(icons: [AppIcon], appIconType: AppIconType) async throws
    func archiveTemporaryDirectoryToPath(_ path: String) async throws
}

struct FileIconService: FileIconServiceProtocol {
    
    let fileManager = FileManager.default
    
    private var temporaryDirectoryURL: URL {
        fileManager.temporaryDirectory.appendingPathComponent("AppIcons")
    }
    
    func deleteExistingTemporaryDirectoryURL() {
        try? fileManager.removeItem(at: temporaryDirectoryURL)
    }

    private func isExportPathCurrentDirectory(_ path: String) -> Bool {
        path == "." || path == "/" || path == "./"
    }
    
    func archiveTemporaryDirectoryToPath(_ path: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            do {
                let result = try safeShell("""
                rm -rf \(path)/AppIcons.zip
                pwd=`pwd`
                cd \(fileManager.temporaryDirectory.path)
                zip -r -X AppIcons.zip ./AppIcons
                mv AppIcons.zip $pwd
                cd $pwd
                \(!isExportPathCurrentDirectory(path) ? "mv AppIcons.zip \(path)" : "")
                """)
                print(result)
                continuation.resume(returning: ())
            } catch {
                print(error.localizedDescription)
                continuation.resume(throwing: error)
            }
        }
    }
    
    func saveIconsToTemporaryDir(icons: [AppIcon], appIconType: AppIconType) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            do {
             
                let dirURL = self.temporaryDirectoryURL
                    .appendingPathComponent(appIconType.folderName)
                    .appendingPathComponent("AppIcon.appiconset")
                try self.fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true)
                for icon in icons {
                    let url = dirURL.appendingPathComponent(icon.filename)
                    try icon.data?.write(to: url)
                }
                
                let jsonData = try JSONSerialization.data(withJSONObject: appIconType.json, options: [.prettyPrinted, .sortedKeys])
                try jsonData.write(to: dirURL.appendingPathComponent("Contents.json"))
                continuation.resume()
            } catch let error as NSError {
                continuation.resume(throwing: error)
            }
        }
    }
    
}

