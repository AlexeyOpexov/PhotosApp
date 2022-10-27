//
//  Tab.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 22.10.2022.
//

import SwiftUI

enum CurrentScreen: String {
    case search, collection
}

class Coordinator: ObservableObject {
    @Published var path: CurrentScreen = .search
}

struct CustomTabView: View {
    
    @ObservedObject var coordinator: Coordinator
    
    var body: some View {
        HStack {
            Group {
                Button { coordinator.path = .search } label: {
                    Image(systemName: "magnifyingglass")
                }
                
                Button { coordinator.path = .collection } label: {
                    Image(systemName: "photo.on.rectangle.angled")
                }
            }
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(.black)
        .opacity(0.9)
    }
    
}


struct Tab_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(coordinator: Coordinator())
    }
}


