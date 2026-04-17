//
//  FirebaseManager.swift
//  MyFirstCloud
//

import FirebaseFirestore

/// Hanterar alla anrop mot Firestore. Fyll i TODO-raderna enligt labbinstruktionen.
final class FirebaseManager {

    /// Hämtar alla dokument i kollektionen `notes` och gör om dem till `CloudNote`.
    func fetchNotes() async -> [CloudNote] {
        // TODO 1: Skapa referens till databasen
        // Skriv: let db = Firestore.firestore()

        // TODO 2: Hämta dokumenten
        // Skriv: let snapshot = try? await db.collection("notes").getDocuments()

        return []
    }

    /// Sparar en ny anteckning som ett nytt dokument i kollektionen `notes`.
    func saveNote(text: String) async {
        // TODO 3: Spara till databasen
        // Skriv: try? await db.collection("notes").addDocument(data: ["text": text])
    }
}
