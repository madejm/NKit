import Foundation

public struct NRectangleCornerRadii {
    public let topLeading: CGFloat
    public let topTrailing: CGFloat
    public let bottomLeading: CGFloat
    public let bottomTrailing: CGFloat
    
    public init(
        topLeading: CGFloat = 0,
        bottomLeading: CGFloat = 0,
        bottomTrailing: CGFloat = 0,
        topTrailing: CGFloat = 0
    ) {
        self.topLeading = topLeading
        self.topTrailing = topTrailing
        self.bottomLeading = bottomLeading
        self.bottomTrailing = bottomTrailing
    }
    
    public subscript(corner: NEdge.Corner) -> CGFloat {
        switch corner {
        case .bottomLeading:  bottomLeading
        case .bottomTrailing: bottomTrailing
        case .topLeading:     topLeading
        case .topTrailing:    topTrailing
        }
    }
}
