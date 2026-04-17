//
//  ContentView.swift
//  MyFirstCloud
//

import SwiftUI

struct ContentView: View {
    @State private var notes: [CloudNote] = []
    @State private var newNoteText = ""

    private let firebase = FirebaseManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ny anteckning")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    TextField("Skriv något…", text: $newNoteText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(2 ... 4)
                    // Task behövs här eftersom knappens action är synkron, medan saveNote()
                    // är async (väntar på nätverket). Task startar det asynkrona arbetet utan
                    // att frysa UI, så SwiftUI kan fortsätta uppdatera skärmen.
                    Button {
                        Task { await saveNote() }
                    } label: {
                        Label("Spara", systemImage: "icloud.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newNoteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))

                List {
                    Section {
                        if notes.isEmpty {
                            ContentUnavailableView(
                                "Inga anteckningar än",
                                systemImage: "note.text",
                                description: Text("Spara en rad ovan när du har kopplat Firestore.")
                            )
                        } else {
                            ForEach(notes) { note in
                                Text(note.text)
                            }
                        }
                    } header: {
                        Text("Alla anteckningar")
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("MyFirstCloud")
            .background(Color(.systemGroupedBackground))
            .task {
                await reloadNotes()
            }
        }
    }

    private func reloadNotes() async {
        notes = await firebase.fetchNotes()
    }

    private func saveNote() async {
        let trimmed = newNoteText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        await firebase.saveNote(text: trimmed)
        newNoteText = ""
        await reloadNotes()
    }
}

#Preview {
    ContentView()
}
