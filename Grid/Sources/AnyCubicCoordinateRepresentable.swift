/// An object that can be represented in cubic coordinate system using 3 coordinates `(q, r, s)`.
/// - Seealso: https://www.redblobgames.com/grids/hexagons/#coordinates-cube
public protocol AnyCubicCoordinateRepresentable: Hashable, CustomStringConvertible {
    
    associatedtype CoordinateUnit where CoordinateUnit: Hashable,
                                        CoordinateUnit: SignedNumeric
    
    /// Coordinate on a q-axis in cubic system.
    /// - Seealso: `HexagonOrientation`.
    var q: CoordinateUnit { get }
    
    /// Coordinate on a r-axis in cubic system.
    /// - Seealso: `HexagonOrientation`.
    var r: CoordinateUnit { get }
    
    /// Coordinate on a s-axis in cubic system.
    /// - Seealso: `HexagonOrientation`.
    var s: CoordinateUnit { get }
}

// MARK: - CustomStringConvertible
extension AnyCubicCoordinateRepresentable {
    
    public var description: String {
        "[q: \(q), r: \(r), s: \(s)]"
    }
}

// MARK: - Hashable
extension AnyCubicCoordinateRepresentable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(q)
        hasher.combine(r)
        hasher.combine(s)
    }
}

// MARK: - Operators
public func == <T> (_ lhs: T, _ rhs: T) -> Bool where T: AnyCubicCoordinateRepresentable{
    lhs.q == rhs.q && lhs.r == rhs.r && lhs.s == rhs.s
}
