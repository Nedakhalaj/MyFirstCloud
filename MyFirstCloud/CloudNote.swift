//
//  CloudNote.swift
//  MyFirstCloud
//

import FirebaseFirestore

/// En anteckning som sparas i Firestore-kollektionen `notes`.
struct CloudNote: Identifiable, Codable {
    /// Dokumentets ID i Firestore (fylls i automatiskt när du läser med Codable).
    @DocumentID var id: String?
    var text: String
}
