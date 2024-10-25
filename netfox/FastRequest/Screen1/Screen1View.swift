
import SwiftUI
import Kingfisher
import SwiftDraw

struct MockInfoItem: Hashable {
    let title: String
    let imageName: ImageResource
}

public struct SVGImgProcessor: ImageProcessor {
    public var identifier: String = "com.appidentifier.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            return UIImage(svgData: data)
        }
    }
}

public struct Screen1View: View {
    @Environment(\.dismiss) var dismiss
    
    private let redMockArray: [MockInfoItem]
    private let model: DataOfferObjectLib?
    
    public init(model: DataOfferObjectLib?) {
        self.model = model
        
        self.redMockArray = [
            .init(title: model?.benefitDescriptions[0] ?? "", imageName: .screen1Icon),
            .init(title: model?.benefitDescriptions[1] ?? "", imageName: .screen1Icon2),
            .init(title: model?.benefitDescriptions[2] ?? "", imageName: .screen1Icon3)
        ]
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                ZStack {
                    Image(.fonPic)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 340)
                    
                    KFImage(URL(string: model?.imageUrl ?? ""))
                        .placeholder({
                            Image(.screen1IMG)
                        })
                        .setProcessor(SVGImgProcessor())
                        .resizable()
                        .frame(width: 300, height: 300)
                        .aspectRatio(contentMode: Constants.smallScreen ? .fill : .fit)
                        .padding(.top)
                }
                
                VStack {
                    Text("\(model?.settings?.count ?? 20)" + " " + (model?.scn?.title_anim_unp ?? ""))
                        .font(.system(size: Constants.smallScreen ? 24 : 30, weight: .bold, design: .default))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(model?.subtitle ?? "")
                        .font(.system(size: Constants.smallScreen ? 16 : 18, weight: .medium, design: .default))
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 5)
                    
                    Text(model?.benefitTitle ?? "")
                        .textCase(.uppercase)
                        .font(.system(size: Constants.smallScreen ? 14 : 16, weight: .semibold, design: .default))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                    
                    ScrollView {
                        ForEach(redMockArray,
                                id: \.title) { item in
                            InfoCellView(title: item.title, iconName: item.imageName)
                                .padding(.horizontal, 1)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .frame(minHeight: 50)
                    
                    Button(action: {
                        
                    }) {
                        HStack() {
                            Spacer()
                            Text(model?.btnTitle ?? "")
                                .font(.system(size: 16, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .padding()
                            
                            
                            Spacer()
                        }
                        .frame(height: 50)
                        .background(.blue)
                        .cornerRadius(10)
                        
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 0)
                .padding(.bottom)
                
            }
            .background(Color.white)
            .ignoresSafeArea(.all)
            .navigationBarHidden(true)
            
            Spacer()
            
            VStack {
                HStack {
                    Button(action: {
                        closeVC()
                    }, label: {
                        Image("close")
                    })
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
    
    private func closeVC() {
        dismiss()
    }
}

#Preview {
    Screen1View(model: nil)
}