//
//  ShareViewController.swift
//  aimicusShare
//
//  Created by Thomas Dornhofer on 11.06.26.
//

import UIKit
import Social
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let provider = item.attachments?.first,
              provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) else {
            cancel()
            return
        }

        provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { [weak self] (data, error) in
            guard let self = self, error == nil else { self?.cancel(); return }

            if let url = data as? URL, let imageData = try? Data(contentsOf: url) {
                self.saveAndOpen(imageData)
            } else if let image = data as? UIImage, let imageData = image.jpegData(compressionQuality: 0.8) {
                self.saveAndOpen(imageData)
            } else {
                self.cancel()
            }
        }
    }

    private func saveAndOpen(_ data: Data) {
        if let defaults = UserDefaults(suiteName: "group.com.deinefirma.kiapp") {
            defaults.set(data, forKey: "sharedScreenshot")
            defaults.synchronize()
        }
        
        if let url = URL(string: "kiapp://new") {
            var responder: UIResponder? = self
            while responder != nil {
                if let application = responder as? UIApplication {
                    application.perform(Selector(("openURL:")), with: url)
                    break
                }
                responder = responder?.next
            }
        }
        complete()
    }

    private func cancel() {
        extensionContext?.cancelRequest(withError: NSError(domain: "ShareError", code: 0))
    }

    private func complete() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
