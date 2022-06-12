import SceneKit
import TSKit_Core
import Grid

class GridNode: SCNNode, AnyDebuggableNode {
        
    let radius: Int
    
    convenience override init() {
        self.init(radius: 1)
    }
    
    var outline: SCNColor {
        didSet {
            childNodes.forEach {
                $0.geometry?.firstMaterial?.diffuse.contents = outline
            }
        }
    }
    
    private var hexagons: [CubicCoordinate: HexagonNode]!
    
    /// - Parameter radius: Number of layers (circles) of hexagons that will compose the grid.
    init(radius: Int, outline: SCNColor = .red) {
        self.radius = radius
        self.outline = outline
        super.init()
        
        let hexagon = HexagonGeometry(radius: 8)
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
        
        var nodes = [CubicCoordinate: HexagonNode]()
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
            }.forEach {
                addChildNode($0)
                nodes[$0.coordinate] = $0
                $0.neighbors = .init(sr: nodes[$0.coordinate + .sr],
                                     qr: nodes[$0.coordinate + .qr],
                                     qs: nodes[$0.coordinate + .qs],
                                     rs: nodes[$0.coordinate + .rs],
                                     rq: nodes[$0.coordinate + .rq],
                                     sq: nodes[$0.coordinate + .sq])
            }
        }
        
        hexagons = nodes
    }
    
    required init?(coder: NSCoder) {
        fatalError("GridNode cannot be created in Scene Editor")
    }
    
    private func hexagonNode(with hexagon: HexagonGeometry,
                     at coordinate: CubicCoordinate,
                     placedAt position: SCNVector3) -> HexagonNode {
        let node = HexagonNode(coordinate: coordinate, geometry: hexagon)
        node.geometry?.firstMaterial?.diffuse.contents = outline
        node.position = position
        return node
    }
}
