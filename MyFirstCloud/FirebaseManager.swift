//
//  FirebaseManager.swift
//  MyFirstCloud
//

import FirebaseFirestore


final class FirebaseManager {

  private let db = Firestore.firestore()

    
    func fetchNotes() async -> [CloudNote] {
        do {
            let snapshot = try await db.collection("notes").getDocuments()
            return snapshot.documents.compactMap{ doc in
                try? doc.data(as: CloudNote.self)}
        } catch  {
            print("fetchNotes failed:" , error.localizedDescription)
            return []
        }
        
    }

    
    func saveNote(text: String) async {
        do {
            try await db.collection("notes").addDocument(data: ["text": text])
        } catch  {
            print("savedNote failed: " ,error.localizedDescription)
        }
    }
}
