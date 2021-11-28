/// A coordinate that represents location of the hexagonal grid cell in a Cubic coordinate system.
/// - Seealso: https://www.redblobgames.com/grids/hexagons/#coordinates-cube
public struct CubicCoordinate: AnyCubicCoordinateRepresentable {
    
    public static let zero = try! CubicCoordinate(q: 0, s: 0, r: 0)
    
    public fileprivate(set) var q: GridUnit
  
    public fileprivate(set) var s: GridUnit
    
    public fileprivate(set) var r: GridUnit
    
    public init(q: GridUnit, s: GridUnit, r: GridUnit) throws {
        if let constraint = CubicSystemConstraint(q: q, s: s, r: r) {
            throw constraint
        }
        self.q = q
        self.s = s
        self.r = r
    }
}

// MARK: - Operators
public func += (coord: inout CubicCoordinate, vector: CubicVector) {
    coord.q += vector.q
    coord.s += vector.s
    coord.r += vector.r
}

public func -= (coord: inout CubicCoordinate, vector: CubicVector) {
    coord.q -= vector.q
    coord.s -= vector.s
    coord.r -= vector.r
}

public func + (coord: CubicCoordinate, vector: CubicVector) -> CubicCoordinate {
    // Adding a valid cubic vector to a valid coordinate will always result in valid coordinate.
    try! .init(q: coord.q + vector.q,
               s: coord.s + vector.s,
               r: coord.r + vector.r)
}

public func - (coord: CubicCoordinate, vector: CubicVector) -> CubicCoordinate {
    // Subtracting a valid cubic vector to a valid coordinate will always result in valid coordinate.
    try! .init(q: coord.q - vector.q,
               s: coord.s - vector.s,
               r: coord.r - vector.r)
}
