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

public extension CubicCoordinate {
    
    /// Calculates distance between `self` and the `other` coordinate.
    func distance(to other: CubicCoordinate) -> UnsignedGridUnit {
        let vector = self - other
        return UnsignedGridUnit(max(abs(vector.q), abs(vector.r), abs(vector.s)))
    }
    
    /// Calculates shortest path between `self` and the `other` coordinate.
    func line(to other: CubicCoordinate) -> [CubicCoordinate] {
        let distance = self.distance(to: other)
        
        let fSelf = FloatCubicCoordinate(self)
        let fOther = FloatCubicCoordinate(other)
        let fDistance = Float(distance)
        
        func interpolate(from: Float, to: Float, portion: Float) -> Float {
            from + (from - to) * portion
        }
        
        return (0...distance).lazy
            .map { Float($0)/fDistance }
            .map { FloatCubicCoordinate(q: interpolate(from: fSelf.q,
                                                       to: fOther.q,
                                                       portion: $0),
                                        r: interpolate(from: fSelf.r,
                                                       to: fOther.r,
                                                       portion: $0),
                                        s: interpolate(from: fSelf.s,
                                                       to: fOther.s,
                                                       portion: $0)) }
            .map { $0.rounded() }
    }
    
    func range(within radius: UnsignedGridUnit) -> CubicRange {
        .init(center: self, radius: radius)
    }
}
