

import SwiftUI
import Combine
import Kingfisher

public struct FastRequest2View: View {
    @Environment(\.dismiss) var dismiss
    @State private var showNextScreen = false
    
    private let mockArr: [String]
    private let model: DataOfferObjectLib?
    
    @State private var displayedItems: [String] = []
    @State private var colorsForItems: [Color] = []
    @State private var timer: Timer?
    
    public init(model: DataOfferObjectLib?) {
        self.mockArr = model?.settings ?? []
        self.model = model
    }
    
    public var body: some View {
            VStack(spacing: 0) {
                KFImage(URL(string: model?.settingsIcon ?? ""))
                    .setProcessor(SVGImgProcessor())
                    .padding(.bottom, 5)
                
                Text(String(format: model?.settingsTitle ?? "", "\(displayedItems.count)"))
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundStyle(.black)
                
                ScrollViewReader { proxy in
                    List {
                        ForEach(displayedItems.indices, id: \.self) { index in
                            Text(displayedItems[index])
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .foregroundColor(colorsForItems[index])
                                .transition(.slide)
                                .id(index)
                        }
                        .listRowBackground(Color(red: 238/255, green: 238/255, blue: 239/255))
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.never)
                    .scrollDisabled(true)
                    .padding(.top, 0)
                    .padding(.bottom)
                    .onAppear {
                        startAnimatingList()
                    }
                    .onReceive(Just(displayedItems.count)) { _ in
                        if let lastIndex = displayedItems.indices.last {
                            withAnimation {
                                proxy.scrollTo(lastIndex, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .background(.white)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showNextScreen) {
                FastRequest2DetailView()
            }
    }
    
    private func randomColor() -> Color {
        Bool.random() ? Color.black : Color.red
    }
    
    func startAnimatingList() {
        var currentIndex = 0
        let totalDuration = 2.0
        let steps = mockArr.count / 3
        
        timer = Timer.scheduledTimer(withTimeInterval: totalDuration / Double(steps), repeats: true) { _ in
            let itemsToAdd = Int.random(in: 1...3)
            let nextIndex = min(currentIndex + itemsToAdd, mockArr.count)
            
            withAnimation {
                let newItems = mockArr[currentIndex..<nextIndex]
                var newArray: [String] = []
                for item in newItems {
                    let locDate = randomDate()
                    let finalStr = locDate + " " + item
                    newArray.append(finalStr)
                }
                displayedItems.append(contentsOf: newArray)
                
                let newColors = newItems.map { _ in randomColor() }
                colorsForItems.append(contentsOf: newColors)
            }
            
            currentIndex = nextIndex
            
            if currentIndex >= mockArr.count {
                timer?.invalidate()
                timer = nil

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showNextScreen = true
                }
            }
        }
    }
    
    private func randomDate() -> String {
        let calendar = Calendar.current
        let now = Date()
        let randomDays = Int.random(in: 0...20)
        let randomDate = calendar.date(byAdding: .day, value: -randomDays, to: now) ?? now
        
        let randomHours = Int.random(in: 0...23)
        let randomMinutes = Int.random(in: 0...59)
        let randomSeconds = Int.random(in: 0...59)
        
        let finalDate = calendar.date(bySettingHour: randomHours, minute: randomMinutes, second: randomSeconds, of: randomDate) ?? randomDate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: finalDate)
    }
}

#Preview {
    FastRequest2View(model: nil)
}