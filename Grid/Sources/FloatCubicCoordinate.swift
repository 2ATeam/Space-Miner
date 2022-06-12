import Foundation

/// An intermediate coordinate that represents interpolated point on a hexagonal grid cell in a Cubic coordinate system.
///
/// Float cubic coordinate can be converted to a regular `CubicCoordinate` using rounding.
/// - Seealso: https://www.redblobgames.com/grids/hexagons/#rounding
public struct FloatCubicCoordinate: AnyCubicCoordinateRepresentable {
    
    public static let zero = FloatCubicCoordinate(q: 0, r: 0, s: 0)
    
    public fileprivate(set) var q: Float
  
    public fileprivate(set) var r: Float
    
    public fileprivate(set) var s: Float
    
    public init(q: Float, r: Float, s: Float) {
        // Add a tiny fraction to correct behavior
        // when FloatCubicCoordinate is exactly on the edge of a hexagon.
        // In such cases such correction will guarantee precise and consistent result.
        self.q = q + 1e-6
        self.r = r + 1e-6
        self.s = s + 1e-6
    }
    
    public init(_ coordinate: CubicCoordinate) {
        
        self.init(q: Float(coordinate.q),
                  r: Float(coordinate.r),
                  s: Float(coordinate.s))
    }
}

// MARK: - Rounding
public extension FloatCubicCoordinate {
    
    /// Rounds given floating-point cubic coordinate to the nearest valid `CubicCoordinate`.
    func rounded() -> CubicCoordinate {
        // 1. Round float coordinates to the nearest integer
        var q = round(self.q)
        var r = round(self.r)
        var s = round(self.s)
        
        // 2. Rounding might violate CubicSystemConstraint.zeroSum,
        //    so we need to correct the result by evaluating one of the coordinates using zeroSum's equation.
        let qDiff = abs(q - self.q)
        let rDiff = abs(r - self.r)
        let sDiff = abs(s - self.s)
        
        // 3. The coordinate that will be evaluated is determined by the largest differential after the rounding.
        if qDiff > rDiff && q > sDiff {
            q = CubicSystemConstraint.q(r: r, s: s)
        } else if rDiff > sDiff {
            r = CubicSystemConstraint.r(q: q, s: s)
        } else {
            s = CubicSystemConstraint.s(q: q, r: r)
        }
        
        // 4. With corrected coordinate it is guaranteed to have a valid CubicCoordinate.
        return try! .init(q: GridUnit(q),
                          r: GridUnit(r),
                          s: GridUnit(s))
    }
}
