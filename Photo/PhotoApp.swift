//
//  PhotoApp.swift
//  Photo
//
//  Created by Dano on 26.09.23.
//

import SwiftUI



@main
struct PhotoApp: App {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    @State var img = URL(string: "file:///Users/dano/Pictures/lac et coucher de soleil.jpg.png")
    var body: some Scene {
        WindowGroup {
            ContentView(img: $img)
                .onOpenURL { url in
                    // Handle the file URL here
                    if let imageData = try? Data(contentsOf: url) {
                        // Process the image data
                        let image = Image(nsImage: NSImage(data: imageData)!)
                        img = url
                        let str = url.absoluteString
                        let filename = getDocumentsDirectory().appendingPathComponent("file.txt")

                        do {
                            try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                        } catch {
                            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                        }
                        // Display the image or perform any other actions
                    }
                }
        }
    }
}
