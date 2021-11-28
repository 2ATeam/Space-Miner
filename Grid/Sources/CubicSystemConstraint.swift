/// Constraint off the Cubic coordinate system.
///
/// To validate given coordinates use failable `init`.
enum CubicSystemConstraint: Error {
    
    /// Sum of all coordinates should be always `0`.
    ///
    /// This constraint is common for all variations of Cubic system and is written as following:
    /// `q + s + r = 0`
    case zeroSum
    
    init?(q: GridUnit, s: GridUnit, r: GridUnit) {
        if (q + s + r) != 0 {
            self = .zeroSum
        } else {
            return nil
        }
    }
}
