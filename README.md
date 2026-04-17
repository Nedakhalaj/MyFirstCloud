# MyFirstCloud

Ett pedagogiskt iOS-startprojekt för att koppla **SwiftUI** till **Cloud Firestore** via Firebase. Du har redan jobbat med `@State`, `List` och navigation — här får du för första gången prova **async/await**, **nätverksanrop** och **Firebase**.

---

## Inlämningsuppgift (kort)

1. Följ guiden nedan **steg för steg** (Firebase-projekt, iOS-app, SDK, Firestore-regler).
2. Öppna `FirebaseManager.swift` och **fyll i alla TODO-rader** enligt kommentarerna (koppla ihop databasen, hämta och spara anteckningar).
3. **Kör appen** i simulator eller på fysisk enhet och kontrollera att du kan spara text och se den i listan.
4. I Firestore (eller via appen om du sparar namnet som text): **lägg till ditt namn** i databasen så att läraren ser att det är ditt konto (t.ex. ett dokument i `notes` med texten `Namn: …` — följ ev. instruktion från lärare).
5. **Pusha** ditt repo till **GitHub** och lämna in enligt kursens rutin.

> **Säkerhet:** I labben används Firestore *Test Mode* (öppen databas under begränsad tid). Det är **endast för utbildning**. I en riktig app måste du ha autentisering och strikta säkerhetsregler.

---

## A) Skapa ett projekt i Firebase Console

1. Gå till [https://console.firebase.google.com/](https://console.firebase.google.com/) och logga in med ditt Google-konto.
2. Klicka **Add project** / **Lägg till projekt**.
3. **Projektnamn:** välj valfritt namn (t.ex. `MyFirstCloud-DittNamn`).
4. **Google Analytics:** du kan stänga av Analytics för det här labbet om du vill hålla det enkelt — det behövs inte för Firestore-grunderna. Om du slår på det får du välja eller skapa ett Analytics-konto.
5. Klicka **Create project** / **Skapa projekt** och vänta tills Firebase är klart.
6. Du landar på projektets **översiktssida (Project Overview)**.

---

## B) Lägga till en iOS-app och ladda ner `GoogleService-Info.plist`

1. I Firebase-konsolen, leta efter ikonen **iOS+** (eller **Add app** / **Lägg till app**) på projektets startsida.
2. Välj **iOS**.
3. **Apple bundle ID:** måste **exakt** matcha det som står i Xcode för din app.
   - Öppna Xcode → välj projektet **MyFirstCloud** → target **MyFirstCloud** → fliken **General**.
   - Kopiera värdet under **Bundle Identifier** (t.ex. `com.dittnamn.MyFirstCloud`).
   - Klistra in samma värde i Firebase när du registrerar iOS-appen.
4. **App nickname** och **App Store ID** kan du lämna tomma för labben.
5. Klicka **Register app** / **Registrera app**.
6. På nästa steg: ladda ner filen **`GoogleService-Info.plist`** till din dator.
7. I **Finder**: dra `GoogleService-Info.plist` in i Xcode-projektet **MyFirstCloud** (samma grupp som `ContentView.swift`).
   - Kryssa i **Copy items if needed**.
   - Kryssa i att filen ska ingå i target **MyFirstCloud**.
8. Fortsätt guiden i Firebase (du kan hoppa över stegen om CocoaPods om du följer SPM nedan) och klicka **Continue** tills du är klar.

**Kontroll:** I Xcode ska du se `GoogleService-Info.plist` i projektnavigatorn. Utan den här filen startar inte Firebase korrekt i appen.

---

## C) Lägga till Firebase SDK via Swift Package Manager (SPM) i Xcode

Det här projektet kan redan ha Firebase kopplat via SPM. Om du klonar en ren kopia eller skapar projekt själv, gör så här:

1. Öppna `MyFirstCloud.xcodeproj` i Xcode.
2. Välj **File → Add Package Dependencies…** (eller **Add Packages…** beroende på Xcode-version).
3. I fältet för URL, klistra in:  
   `https://github.com/firebase/firebase-ios-sdk`
4. Välj **Dependency Rule:** t.ex. **Up to Next Major Version** med en lämplig lägsta version (t.ex. `11.0.0` eller nyare).
5. Klicka **Add Package**.
6. I produktlistan, markera minst:
   - **FirebaseCore**
   - **FirebaseFirestore**
7. Lägg till dem till target **MyFirstCloud** och bekräfta.

**Kontroll:** Projektet ska bygga utan att `import FirebaseCore` / `import FirebaseFirestore` ger fel.

---

## D) Aktivera Cloud Firestore och sätta regler till Test Mode

1. I [Firebase Console](https://console.firebase.google.com/), välj ditt projekt.
2. I vänstermenyn: **Build** → **Firestore Database** (eller **Firestore**).
3. Klicka **Create database** / **Skapa databas**.
4. Välj **Start in test mode** / **Starta i testläge** (för labben).
5. Välj en **Cloud Firestore location** (välj en region nära dig om du får frågan). Vissa val går **inte** att ändra senare.
6. När databasen är skapad: gå till fliken **Rules** / **Regler**.

Du ska se regler i stil med (exakt formulering kan variera något):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(YYYY, MM, DD);
    }
  }
}
```

Det betyder ungefär: **vem som helst kan läsa och skriva** tills ett **slutdatum** — därför är det bara för **utbildning** och **inte** för riktiga användardata.

**Appens kollektion:** koden förväntar sig en kollektion som heter **`notes`**. Varje dokument kan ha fältet **`text`** (sträng). När du fyllt i `fetchNotes` och `saveNote` skapas dokument automatiskt när du sparar från appen.

---

## Kod du ska fylla i (TODO)

Öppna `FirebaseManager.swift`:

1. **TODO 1:** `let db = Firestore.firestore()`
2. **TODO 2:** `let snapshot = try? await db.collection("notes").getDocuments()`
3. Efter steg 2 måste du **bygga en `[CloudNote]`** från `snapshot` (t.ex. loopa `snapshot.documents` och använda `data(as: CloudNote.self)`).
4. I **`saveNote`:** innan raden som sparar med `db.collection("notes")…` måste du ha samma **`let db = Firestore.firestore()`** som i steg 1 (annars finns ingen `db`).
5. **TODO 3:** `try? await db.collection("notes").addDocument(data: ["text": text])`

Kör appen igen efter varje ändring och använd **Firestore → Data** i konsolen för att se att dokument dyker upp.

---

## Felsökning (kort)

| Problem | Vad du kan prova |
|--------|-------------------|
| Build-fel på `import Firebase…` | Kontrollera att SPM-paketet är tillagt och att **FirebaseCore** + **FirebaseFirestore** är länkade till target. |
| Krasch vid start | Finns `GoogleService-Info.plist` i projektet och i rätt target? Stämmer **Bundle ID** mot Firebase? |
| Tom lista / inget sparas | Har du implementerat **både** hämtning och sparning? Stämmer kollektionsnamnet `notes`? |
| Permission denied i konsolen | Regler i Test Mode? Är datumet i reglerna inte redan passerat? |

---

## Repo och GitHub

1. Initiera git i projektmappen om du inte redan gjort det: `git init`
2. Lägg till `.gitignore` om kursen rekommenderar det (t.ex. ignorera `xcuserdata/`, byggartefakter).
3. **Obs:** många väljer **inte** att committa `GoogleService-Info.plist` till ett publikt repo eftersom den innehåller projektnycklar. Följ **lärarens** anvisning — vissa kurser vill att du committar den för enkel rättning, andra vill att du använder hemliga variabler eller delar filen separat.

Lycka till med din första moln-app.
