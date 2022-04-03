import SceneKit
import TSKit_Core

class GridNode: SCNNode {
        
    convenience override init() {
        self.init(radius: 1)
    }
    
    /// - Parameter radius: Number of layers (circles) of hexagons that will compose the grid.
    init(radius: Int) {
        super.init()
        func hexagonNode(_ hexagon: HexagonGeometry, at position: SCNVector3) -> SCNNode {
            let node = SCNNode(geometry: hexagon)
            node.geometry?.materials.first?.diffuse.contents = SCNColor.red
            node.position = position
            return node
        }
        let hexagon = HexagonGeometry()
        let hexHeight = hexagon.height
        let hexRadius = hexagon.radius
        let root = CGPoint()
        let up = CGPoint(x: 0, y: 2 * hexHeight)
        let down = CGPoint(x: 0, y: -2 * hexHeight)
        let upRight = CGPoint(x: 1.5 * hexRadius, y: hexHeight)
        let upLeft = CGPoint(x: -1.5 * hexRadius, y: hexHeight)
        let downRight = CGPoint(x: 1.5 * hexRadius, y: -hexHeight)
        let downLeft = CGPoint(x: -1.5 * hexRadius, y: -hexHeight)
        
        let path = [
            downRight,
            down,
            downLeft,
            upLeft,
            up,
            upRight
        ]
        for circleIndex in 0..<radius {
            /// Number of hexagons that should be added per side.
            let steps = circleIndex
            
            let startingHexPosition = root + (up * CGFloat(steps))
            let points = path.flatMap { Array(repeating: $0, count: steps) }
                .reduce([CGPoint]()) { res, direction in
                    res.appending((res.last ?? startingHexPosition) + direction)
                }
                
                points.map {
                    hexagonNode(hexagon, at: $0.vector)
                }.forEach(addChildNode)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("GridNode cannot be created in Scene Editor")
    }
    
}

class HexagonGeometry: SCNGeometry {
    
    /// Distance from the center of hexagon to its vertices.
    ///
    /// It is the radius of the circle enclosing this hexagon.
    var radius: CGFloat {
        sources.compactMap { $0 as? HexagonGeometrySource }.first?.radius ?? 0
    }
        
    /// An array of points corresponding to the vertices of hexagon.
    ///
    /// Vertices are enumerated counterclockwise starting from the right vertice.
    var vertices: [CGPoint] {
        sources.compactMap { $0 as? HexagonGeometrySource }.first?.vertices ?? []
    }
    
    /// Length of the normal from the center of hexagon to its edge.
    var height: CGFloat {
        sources.compactMap { $0 as? HexagonGeometrySource }.first?.height ?? 0
    }
    
    convenience override init() {
        self.init(radius: 1)
    }
    
    init(radius: CGFloat) {
        super.init()
        let source = HexagonGeometrySource(radius: radius)
        self.init(sources: [source],
                  elements: [.init(indices: source.indices, primitiveType: .line)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("HexagonGeometry cannot be created in Scene Editor")
    }
                             
    private class func height(for radius: CGFloat) -> CGFloat {
        radius * sqrt(3) / 2
    }
    
    private class func vertices(for radius: CGFloat, _ height: CGFloat) -> [CGPoint] {
        let halfRadius = radius / 2
        return [
            .init(x: radius, y: 0),
            .init(x: halfRadius, y: height),
            .init(x: -halfRadius, y: height),
            .init(x: -radius, y: 0),
            .init(x: -halfRadius, y: -height),
            .init(x: halfRadius, y: -height)]
    }
        
    private class HexagonGeometrySource: SCNGeometrySource {
   
        var radius: CGFloat!
            
        /// An array of points corresponding to the vertices of hexagon.
        ///
        /// Vertices are enumerated counterclockwise starting from the right vertice.
        var vertices: [CGPoint]!
        
        /// Length of the normal from the center of hexagon to its edge.
        var height: CGFloat!
        
        // Important to specify Int32 type explicitly!
        var indices: [Int32] {
            [
                0, 1,
                1, 2,
                2, 3,
                3, 4,
                4, 5,
                5, 0
            ]
            
        }
        
        convenience init(radius: CGFloat) {
            let height = HexagonGeometry.height(for: radius)
            let vertices = HexagonGeometry.vertices(for: radius, height)
            self.init(vertices: vertices.map(SCNVector3.init))
            self.radius = radius
            self.height = height
            self.vertices = vertices
        }
    }
}

extension CGPoint {
    
    static func + (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func * (_ point: CGPoint, _ constant: CGFloat) -> CGPoint {
        .init(x: point.x * constant, y: point.y * constant)
    }
}

extension CGPoint {
    
    var vector: SCNVector3 {
        .init(self)
    }
}

extension SCNVector3 {
    
    init(_ point: CGPoint) {
        self.init(point.x, point.y, 0)
    }
}
