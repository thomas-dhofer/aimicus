//
//  ShareViewController.swift
//  aimicusSendImage
//
//  Created by Thomas Dornhofer on 06.07.26.
//

import Cocoa
import UniformTypeIdentifiers

class ShareViewController: NSViewController {

    override var nibName: NSNib.Name? {
        return NSNib.Name("ShareViewController")
    }

    // Hier speichern wir die gefundene Bild-URL zwischen
    var sharedImageURL: URL?

    override func loadView() {
        super.completeLoadView() // Falls im Ursprung super.loadView() stand, beibehalten
        
        // 1. Hole das erste geteilte Element
        guard let item = self.extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = item.attachments else { return }
        
        // 2. Suche nach einem Bild (public.image) in den Anhängen
        let imageType = UTType.image.identifier
        
        for provider in attachments {
            if provider.hasItemConformingToTypeIdentifier(imageType) {
                // Das System lädt die Datei im Hintergrund
                provider.loadItem(forTypeIdentifier: imageType, options: nil) { [weak self] (item, error) in
                    if let url = item as? URL {
                        // Hier hast du die fertige URL des Bildes!
                        self?.sharedImageURL = url
                        NSLog("Erfolgreich Bild-URL geladen: %@", url.path)
                    }
                }
                break // Wir haben unser Bild gefunden
            }
        }
    }

    @IBAction func send(_ sender: AnyObject?) {
        // 3. Wenn der Nutzer auf "Senden" klickt, verarbeiten wir das Bild
        if let imageURL = self.sharedImageURL {
            
            // WEG A: Direkt an den OllamaService übergeben (Falls das Target verknüpft ist)
            // OllamaService.deineStatischeMethode(mit: imageURL)
            
            // WEG B: Die Haupt-App via URL-Scheme öffnen und das Bild übergeben
            var components = URLComponents()
            components.scheme = "aimicus"
            components.host = "open-image"
            components.queryItems = [URLQueryItem(name: "path", value: imageURL.path)]
            
            if let customURL = components.url {
                NSWorkspace.shared.open(customURL)
            }
        }
        
        // Schließt das Teilen-Fenster erfolgreich
        let outputItem = NSExtensionItem()
        self.extensionContext!.completeRequest(returningItems: [outputItem], completionHandler: nil)
    }

    @IBAction func cancel(_ sender: AnyObject?) {
        // Schließt das Fenster, wenn der Nutzer auf "Abbrechen" klickt
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequest(withError: cancelError)
    }
}
