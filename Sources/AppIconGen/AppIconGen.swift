import ArgumentParser
import Foundation
import SwiftGD

@main
struct AppIconGen: AsyncParsableCommand {

    static let configuration = CommandConfiguration(abstract: "App Icon Sets Generator for iOS, Mac, & Apple Watch",
                                                    usage: """
                                                    Pass input image file path (1024x1024) and export path arguments. Optionally, you can pass options to generate iconsets only for specific platform. If you don't pass, it will generate for all platforms. The zip contains folders specific to each platform. It contains AppIcon.iconset folder which you can just drag and drop to Xcode XCAssets panel.
                                                    """
    )


    @Argument(help: "Input image file path")
    var inputImagePath: String

    @Argument(help: "Export path")
    var exportPath: String

    @Flag(help: "passing this flag will overrides all the other flags")
    var all = false

    @Flag(name: .customLong("iOS"), help: "Generate iPhone and iPad icons in single iOS folder")
    var iOS = false

    @Flag(name: .customLong("iPhone"))
    var iPhone = false

    @Flag(name: .customLong("iPad"))
    var iPad = false

    @Flag var mac = false
    @Flag var watch = false

    func run() async throws {
        let location = URL(fileURLWithPath: inputImagePath)
        guard let image = Image(url: location) else {
            fatalError("Image failed to initialize. Please provide a valid image file")
        }
        
        do {

            var appIconType = [AppIconType]()
            if all {
                appIconType = [.iPhoneAndiPad, .mac, .appleWatch]
            } else {
                if iOS {
                    appIconType.append(.iPhoneAndiPad)
                } else if iPhone {
                    appIconType.append(.iphone)
                } else if iPad {
                    appIconType.append(.ipad)
                }
                
                if mac {
                    appIconType.append(.mac)
                }
                
                if watch {
                    appIconType.append(.appleWatch)
                }
            }
            
            if appIconType.count == 0 {
                appIconType = [.iPhoneAndiPad, .mac, .appleWatch]
            }
            let iconFileGeneratorService = IconFileGeneratorService(fileService: FileIconService(), resizeService: IconResizerService())
            try await iconFileGeneratorService.generateIconsURL(for: appIconType, with: image, path: exportPath)

        } catch {
            print(error.localizedDescription)
        }
    }

}


  