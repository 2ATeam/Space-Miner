/// A coordinate that represents location of the hexagonal grid cell in a Cubic coordinate system.
/// - Seealso: https://www.redblobgames.com/grids/hexagons/#coordinates-cube
public struct CubicCoordinate: AnyCubicCoordinateRepresentable {
    
    public static let zero = try! CubicCoordinate(q: 0, r: 0, s: 0)
    
    public fileprivate(set) var q: GridUnit
  
    public fileprivate(set) var r: GridUnit
    
    public fileprivate(set) var s: GridUnit
    
    public init(q: GridUnit, r: GridUnit, s: GridUnit) throws {
        try CubicSystemConstraint.validate(q: q, r: r, s: s)
        self.q = q
        self.r = r
        self.s = s
    }
}

// MARK: - Operators
public func += (coord: inout CubicCoordinate, vector: CubicVector) {
    coord.q += vector.q
    coord.r += vector.r
    coord.s += vector.s
}

public func -= (coord: inout CubicCoordinate, vector: CubicVector) {
    coord.q -= vector.q
    coord.r -= vector.r
    coord.s -= vector.s
}

public func + (coord: CubicCoordinate, vector: CubicVector) -> CubicCoordinate {
    // Adding a valid cubic vector to a valid coordinate will always result in a valid coordinate.
    try! .init(q: coord.q + vector.q,
               r: coord.r + vector.r,
               s: coord.s + vector.s)
}

public func - (coord: CubicCoordinate, vector: CubicVector) -> CubicCoordinate {
    // Subtracting a valid cubic vector from a valid coordinate will always result in a valid coordinate.
    try! .init(q: coord.q - vector.q,
               r: coord.r - vector.r,
               s: coord.s - vector.s)
}
