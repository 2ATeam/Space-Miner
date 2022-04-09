import SceneKit
import TSKit_Core
import Grid

class GridNode: SCNNode {
        
    let radius: Int
    
    convenience override init() {
        self.init(radius: 1)
    }
    
    var outline: SCNColor {
        didSet {
            childNodes.forEach {
                $0.geometry?.materials.first?.diffuse.contents = outline
            }
        }
    }
    
    /// - Parameter radius: Number of layers (circles) of hexagons that will compose the grid.
    init(radius: Int, outline: SCNColor = .red) {
        self.radius = radius
        self.outline = outline
        super.init()
        
        let hexagon = HexagonGeometry()
        let hexHeight = hexagon.height
        let hexRadius = hexagon.radius
        
        typealias Movement = (position: CGVector, coordinate: CubicVector)
        typealias Position = (position: CGPoint, coordinate: CubicCoordinate)
        
        let up: Movement = (CGVector(dx: 0, dy: 2 * hexHeight), .sr)
        let down: Movement = (CGVector(dx: 0, dy: -2 * hexHeight), .rs)
        let upRight: Movement = (CGVector(dx: 1.5 * hexRadius, dy: hexHeight), .qr)
        let upLeft: Movement = (CGVector(dx: -1.5 * hexRadius, dy: hexHeight), .sq)
        let downRight: Movement = (CGVector(dx: 1.5 * hexRadius, dy: -hexHeight), .qs)
        let downLeft: Movement = (CGVector(dx: -1.5 * hexRadius, dy: -hexHeight), .rq)
        
        let root: Position = (position: .zero, coordinate: .zero)
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
            let startingHexPosition: Position = (position: root.position + (up.position * CGFloat(steps)),
                                                 coordinate: root.coordinate + up.coordinate * GridUnit(steps))
            let points = path.flatMap { Array(repeating: $0, count: steps) }
                .reduce([Position]()) { res, direction in
                    let latest = (res.last ?? startingHexPosition)
                    return res.appending((position: latest.position + direction.position,
                                          coordinate: latest.coordinate + direction.coordinate))
                }.nonEmpty ?? [startingHexPosition] // The first iteration is the center of the grid,
            // there will be no path, only one hex
            points.map {
                hexagonNode(with: hexagon, at: $0.coordinate, placedAt: $0.position.vector)
            }.forEach(addChildNode)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("GridNode cannot be created in Scene Editor")
    }
    
    func hexagonNode(with hexagon: HexagonGeometry,
                     at coordinate: CubicCoordinate,
                     placedAt position: SCNVector3) -> HexagonNode {
        let node = HexagonNode(coordinate: coordinate, geometry: hexagon)
        node.geometry?.materials.first?.diffuse.contents = outline
        node.position = position
        return node
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

extension CGVector {
    
    static func + (_ lhs: CGPoint, _ rhs: CGVector) -> CGPoint {
        .init(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
    
    static func * (_ point: CGVector, _ constant: CGFloat) -> CGVector {
        .init(dx: point.dx * constant, dy: point.dy * constant)
    }
}
