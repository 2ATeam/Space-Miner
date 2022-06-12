import CoreGraphics

public class Grid {
    
    private var range: CubicRange = .init(center: .zero)
    
    let renderer: AnyGridRenderer
    
    init(renderer: AnyGridRenderer) {
        self.renderer = renderer
    }
}

public protocol AnyGridRenderer {
    
}
