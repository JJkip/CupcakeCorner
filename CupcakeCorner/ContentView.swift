//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Joseph Langat on 30/06/2023.
//

import SwiftUI
//import URLImage

class User: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
        case name
    }
    
    @Published var name = "JJ Kip"
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
    var releaseDate: String
    var artworkUrl100: String
    
    enum CodingKeys: String, CodingKey {
        case trackId, trackName, collectionName, releaseDate
        case artworkUrl100 = "artworkUrl100"
    }
}

struct ContentView: View {
    @State private var results = [Result]()
    @State private var username = ""
    @State private var email = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }
            Section {
                Button("Create account") {
                    print("Creating account")
                }
            }
            .disabled(disabledForm)
        }
        
        List(results, id: \.trackId) { item in
            HStack {
                AsyncImage(url: URL(string: item.artworkUrl100)) { phase in
                    if let disImage = phase.image {
                        disImage
                            .resizable()
                        //                        .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    } else if phase.error != nil {
                        Text("There was an error loading the image")
                    } else {
                        ProgressView()
                    }
                }
//                .frame(width: 100, height: 100)
                VStack(alignment: .leading) {
                    
                    Text(item.trackName)
                        .font(.headline)
                    Text(item.collectionName)
                    Text(formatDate(item.releaseDate))
                        .font(.callout)
                        .foregroundColor(Color.gray)
                }
            }
            
        }
        .task {
            await loadData()
        }
        
    }
    
    var disabledForm: Bool {
        username.count < 5 || email.count < 5
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
