/// A vector that represents a direction in a Cubic coordinate system.
/// - Seealso: https://www.redblobgames.com/grids/hexagons/#coordinates-cube
public struct CubicVector: AnyCubicCoordinateRepresentable {
    
    /// *Unit vector* that points in the positive direction of `s-axis` and negative `r-axis`.
    ///
    /// This corresponds to:
    /// - *Up* direction in `edge` (⬣) orientation
    /// - *Up-left* direction in `vertice` (⬢) orientation.
    public static let sr = try! CubicVector(r: -1, s: 1)
    
    /// *Unit vector* that points in the positive direction of `s-axis` and negative `q-axis`.
    ///
    /// This corresponds to:
    /// - *Up-left* direction in `edge` (⬣) orientation
    /// - *Left* direction in `vertice` (⬢) orientation.
    public static let sq = try! CubicVector(q: -1, s: 1)
    
    /// *Unit vector* that points in the positive direction of `q-axis` and negative `r-axis`.
    ///
    /// This corresponds to *Up-right* direction in both `edge` (⬣) and `vertice` (⬢) orientations.
    public static let qr = try! CubicVector(q: 1, r: -1)
    
    /// *Unit vector* that points in the positive direction of `r-axis` and negative `s-axis`.
    ///
    /// This corresponds to:
    /// - *Down* direction in `edge` (⬣) orientation
    /// - *Down-right* direction in `vertice` (⬢) orientation.
    public static let rs = try! CubicVector(r: 1, s: -1)
    
    /// *Unit vector* that points in the positive direction of `r-axis` and negative `q-axis`.
    ///
    /// This corresponds to *Down-left* direction in both `edge` (⬣) and `vertice` (⬢) orientations.
    public static let rq = try! CubicVector(q: -1, r: 1)
    
    /// *Unit vector* that points in the positive direction of `q-axis`.
    ///
    /// This corresponds to "diagonal" direction that is parallel to:
    /// - *Top* and *Bottom* edges in `edge` (⬣)  orientation
    /// - *Top-left* and *Bottom-right* edges in `vertice` (⬢) orientation.
    /// - Note: Use `-q` to point in the opposite direction.
    public static let q = try! CubicVector(q: 2, r: -1, s: -1)
    
    /// *Unit vector* that points in the positive direction of `r-axis`.
    ///
    /// This corresponds to "diagonal" direction that is parallel to:
    /// - *Top-left* and *Bottom-right* edges in `edge` (⬣)  orientation
    /// - *Left* and *Right* edges in `vertice` (⬢) orientation.
    /// - Note: Use `-r` to point in the opposite direction.
    public static let r = try! CubicVector(q: -1, r: 2, s: -1)
    
    /// *Unit vector* that points in the positive direction of `s-axis`.
    ///
    /// This corresponds to "diagonal" direction that is parallel to *Top-right* and *Bottom-left*
    /// in both `edge` (⬣) and `vertice` (⬢) orientations.
    /// - Note: Use `-s` to point in the opposite direction.
    public static let s = try! CubicVector(q: -1, r: -1, s: 2)
    
    /// *Unit vector* that points in the positive direction of `q-axis` and negative `s-axis`.
    ///
    /// This corresponds to:
    /// - *Down-right* direction in `edge` (⬣) orientation
    /// - *Right* direction in `vertice` (⬢) orientation.
    public static let qs = try! CubicVector(q: 1, s: -1)
    
    public fileprivate(set) var q: GridUnit
  
    public fileprivate(set) var r: GridUnit
    
    public fileprivate(set) var s: GridUnit
    
    public init(q: GridUnit, r: GridUnit) throws {
        try self.init(q: q, r: r, s: 0)
    }
    
    public init(q: GridUnit, s: GridUnit) throws {
        try self.init(q: q, r: 0, s: s)
    }
    
    public init(r: GridUnit, s: GridUnit) throws {
        try self.init(q: 0, r: r, s: s)
    }
    
    fileprivate init(q: GridUnit, r: GridUnit, s: GridUnit) throws {
        try CubicSystemConstraint.validate(q: q, r: r, s: s)
        self.q = q
        self.r = r
        self.s = s
    }
}

// MARK: - Operators
public func * (_ vector: CubicVector, _ multiplier: GridUnit) -> CubicVector {
    var new = vector
    new *= multiplier
    return new
}

public func * (_ multiplier: GridUnit, _ vector: CubicVector) -> CubicVector {
    vector * multiplier
}

public func *= (_ vector: inout CubicVector, _ multiplier: GridUnit) {
    vector.q *= multiplier
    vector.r *= multiplier
    vector.s *= multiplier
}

public prefix func - (_ vector: CubicVector) -> CubicVector {
    vector * -1
}

// Placed here to due to fileprivate access to CubicVector's init.
public func - (_ lhs: CubicCoordinate, _ rhs: CubicCoordinate) -> CubicVector {
    // Subtracting a valid cubic coordinate from another valid coordinate will always result in a valid cubic vector.
    try! .init(q: lhs.q - rhs.q,
               r: lhs.r - rhs.r,
               s: lhs.s - rhs.s)
}
