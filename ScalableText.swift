
import SwiftUI

struct ScalableText: View {
  
  private enum Constants {
    
    static let minZoom: CGFloat = 1
    static let maxZoom: CGFloat = 1.7
    static let maxOffSet: CGSize = CGSize(width: 150, height: 150)
    static let minOffSet: CGSize = CGSize(width: -150, height: -150)
    
  }
  
  @State private var scale: CGFloat = 1.0
  @State private var lastScale: CGFloat = 1.0
  @State private var offSet: CGSize = .zero
  @State private var lastOffSet: CGSize = .zero
  
  let text: String
  
  init(_ text: String) {
    self.text = text
  }
 
  var body: some View {
    Text(text)
      .scaleEffect(scale)
      .offset(offSet)
      .highPriorityGesture(
        DragGesture()
          .onChanged { value in
            offSet = lastOffSet + value.translation
          }
          .onEnded { value in
            lastOffSet = lastOffSet + value.translation
            lastOffSet.centerise(min: Constants.minOffSet, max: Constants.maxOffSet)
            withAnimation(.easeInOut) {
              offSet = lastOffSet
            }
          }
      )
      .gesture(
        MagnificationGesture()
          .onChanged { value in
            let magnification = lastScale + value.magnitude - 1.0
            if magnification >= Constants.minZoom && magnification <= Constants.maxZoom {
              scale = magnification
            }
            else if magnification < Constants.minZoom {
              scale = Constants.minZoom
            }
            else if magnification > Constants.maxZoom {
              scale = Constants.maxZoom
            }
          }
          .onEnded { value in
            let magnification = lastScale + value.magnitude - 1.0
            if magnification >= Constants.minZoom && magnification <= Constants.maxZoom {
              lastScale = magnification
            } else if magnification < Constants.minZoom {
              lastScale = Constants.minZoom
            } else if magnification > Constants.maxZoom {
              lastScale = Constants.maxZoom
            }
            scale = lastScale
          }
      )
      .gesture(
        TapGesture(count: 2)
          .onEnded {
            withAnimation(.easeInOut) {
              scale = 1
              offSet = .zero
            }
          }
      )
      .clipped()
  }
  
}

struct ScalableText_Previews: PreviewProvider {
  static var previews: some View {
    ScalableText(
      """
       Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
      Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
      Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
      Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
      """
    )
  }
  
}

//MARK: - Helper methods(can move to another file)
extension CGSize {
  
  static func + (left: CGSize, right: CGSize) -> CGSize {
    CGSize(width: left.width + right.width, height: left.height + right.height)
  }
  
  mutating func centerise(min: CGSize, max: CGSize) {
    switch self.width {
    case ..<min.width:
      self.width = min.width
    case max.width...:
      self.width = max.width
    default:
      break
    }
    switch self.height {
    case ..<min.height:
      self.height = min.height
    case max.height...:
      self.height = max.height
    default:
      break
    }
  }
  
}

