/// Constraint of the Cubic coordinate system.
enum CubicSystemConstraint: Error {
    
    /// Sum of all coordinates should be always `0`.
    ///
    /// This constraint is common for all variations of Cubic system and is written as following:
    /// `q + r + s = 0`
    case zeroSum
    
    /// Validates given Cubic coordinates and throws the first violated constraint if any.
    static func validate(q: GridUnit, r: GridUnit, s: GridUnit) throws {
        if (q + r + s) != 0 {
            throw CubicSystemConstraint.zeroSum
        }
    }
    
    /// Validates given Cubic coordinates and throws the first violated constraint if any.
    static func validate<CubicCoordinateRepresentable>(_ coordinate: CubicCoordinateRepresentable) throws where CubicCoordinateRepresentable: AnyCubicCoordinateRepresentable {
        try validate(q: coordinate.q, r: coordinate.r, s: coordinate.s)
    }
    
    /// Calculates `q` coordinate that will satisfy Cubic system constraints with given `r` and `s` coordinates.
    static func q<Unit>(r: Unit, s: Unit) -> Unit where Unit: AdditiveArithmetic & SignedNumeric  {
        -r-s
    }
    
    /// Calculates `r` coordinate that will satisfy Cubic system constraints with given `q` and `s` coordinates.
    static func r<Unit>(q: Unit, s: Unit) -> Unit where Unit: AdditiveArithmetic & SignedNumeric  {
        -q-s
    }
    
    /// Calculates `s` coordinate that will satisfy Cubic system constraints with given `q` and `r` coordinates.
    static func s<Unit>(q: Unit, r: Unit) -> Unit where Unit: AdditiveArithmetic & SignedNumeric  {
        -q-r
    }
}
