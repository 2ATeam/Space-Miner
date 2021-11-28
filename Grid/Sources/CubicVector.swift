/// A vector that represents a direction in a Cubic coordinate system.
/// - Seealso: https://www.redblobgames.com/grids/hexagons/#coordinates-cube
public struct CubicVector: AnyCubicCoordinateRepresentable {
    
    /// *Unit vector* that points to the upper
    public static let up = try! CubicVector(s: 1, r: -1)
    public static let upLeft = try! CubicVector(q: -1, s: 1)
    public static let upRight = try! CubicVector(q: 1, r: -1)
    public static let down = try! CubicVector(s: -1, r: 1)
    public static let downLeft = try! CubicVector(q: -1, r: 1)
    public static let downRight = try! CubicVector(q: 1, s: -1)
    
    public fileprivate(set) var q: GridUnit
  
    public fileprivate(set) var s: GridUnit
    
    public fileprivate(set) var r: GridUnit
    
    public init(q: GridUnit, r: GridUnit) throws {
        try self.init(q: q, s: 0, r: r)
    }
    
    public init(q: GridUnit, s: GridUnit) throws {
        try self.init(q: q, s: s, r: 0)
    }
    
    public init(s: GridUnit, r: GridUnit) throws {
        try self.init(q: 0, s: s, r: r)
    }
    
    fileprivate init(q: GridUnit, s: GridUnit, r: GridUnit) throws {
        if let constraint = CubicSystemConstraint(q: q, s: s, r: r) {
            throw constraint
        }
        self.q = q
        self.s = s
        self.r = r
    }
}

// MARK: - Operators
public func * (_ vector: CubicVector, _ multiplier: GridUnit) -> CubicVector {
    // Multiplication of a valid cubic vector will always result in valid vector.
    try! .init(q: vector.q * multiplier,
               s: vector.s * multiplier,
               r: vector.r * multiplier)
}

public func *= (_ vector: inout CubicVector, _ multiplier: GridUnit) {
    vector.q *= multiplier
    vector.s *= multiplier
    vector.r *= multiplier
}
