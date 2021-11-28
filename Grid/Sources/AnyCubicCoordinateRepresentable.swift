/// An object that can be represented in cubic coordinate system using 3 coordinates `(q, s, r)`.
/// - Seealso: https://www.redblobgames.com/grids/hexagons/#coordinates-cube
public protocol AnyCubicCoordinateRepresentable: Hashable {
    
    /// Coordinate on a q-axis in cubic system.
    /// - Seealso: `HexagonOrientation`.
    var q: GridUnit { get }
    
    /// Coordinate on a s-axis in cubic system.
    /// - Seealso: `HexagonOrientation`.
    var s: GridUnit { get }
    
    /// Coordinate on a r-axis in cubic system.
    /// - Seealso: `HexagonOrientation`.
    var r: GridUnit { get }    
}

// MARK: - Hashable
extension AnyCubicCoordinateRepresentable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(q)
        hasher.combine(s)
        hasher.combine(r)
    }
}

// MARK: - Operators
public func == <T> (_ lhs: T, _ rhs: T) -> Bool where T: AnyCubicCoordinateRepresentable{
    lhs.q == rhs.q && lhs.r == rhs.r && lhs.s == rhs.s
}
