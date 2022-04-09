import SceneKit
import Grid

class HexagonNode: SCNNode {
    
    class Neighbors {
        
        fileprivate(set) var sr: HexagonNode?
        fileprivate(set) var qr: HexagonNode?
        fileprivate(set) var qs: HexagonNode?
        fileprivate(set) var rs: HexagonNode?
        fileprivate(set) var rq: HexagonNode?
        fileprivate(set) var sq: HexagonNode?
        
        fileprivate convenience init() {
            self.init(sr: nil, qr: nil, qs: nil, rs: nil, rq: nil, sq: nil)
        }
        
        init(sr: HexagonNode?,
             qr: HexagonNode?,
             qs: HexagonNode?,
             rs: HexagonNode?,
             rq: HexagonNode?,
             sq: HexagonNode?) {
            self.sr = sr
            self.qr = qr
            self.qs = qs
            self.rs = rs
            self.rq = rq
            self.sq = sq
        }
    }
    
    let coordinate: CubicCoordinate
    
    var neighbors: Neighbors = .init() {
        didSet {
            neighbors.sr?.neighbors.rs = self
            neighbors.qr?.neighbors.rq = self
            neighbors.qs?.neighbors.sq = self
            neighbors.rs?.neighbors.sr = self
            neighbors.rq?.neighbors.qr = self
            neighbors.sq?.neighbors.qs = self
        }
    }
     
    init(coordinate: CubicCoordinate, geometry: HexagonGeometry) {
        self.coordinate = coordinate
        super.init()
        self.geometry = geometry
        addDebugInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("HexagonNode cannot be created in Scene Editor")
    }
    
    private func addDebugInfo() {
        func label(_ text: String) -> SCNNode {
            let labelGeometry = SCNText(string: text, extrusionDepth: 0)
            labelGeometry.font = .systemFont(ofSize: 1)
            let label = SCNNode(geometry: labelGeometry)
            label.scale = .init(0.3, 0.3, 0.3)
            return label
        }
        
        let q = label("\(coordinate.q)")
        q.geometry?.firstMaterial?.diffuse.contents = SCNColor.systemGreen
        q.position = .init(-0.1, 0.1, 0)
        self.addChildNode(q)
        
        let r = label("\(coordinate.r)")
        r.geometry?.firstMaterial?.diffuse.contents = SCNColor.systemBlue
        r.position = .init(0.4, -0.7, 0)
        self.addChildNode(r)
        
        let s = label("\(coordinate.s)")
        s.geometry?.firstMaterial?.diffuse.contents = SCNColor.purple
        s.position = .init(-0.6, -0.7, 0)
        self.addChildNode(s)
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
