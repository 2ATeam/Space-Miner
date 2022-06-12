import Foundation

public protocol AnyCubicRange {
    
    var allCoordinates: Set<CubicCoordinate> { get }
    
    func contains(_ coordinate: CubicCoordinate) -> Bool
    
//    func intersection(_ other: AnyCubicRange) -> AnyCubicRange
}

public struct CubicRange: AnyCubicRange {
    
    
    public var center: CubicCoordinate
    
    public var radius: UnsignedGridUnit
    
    public init(center: CubicCoordinate, radius: UnsignedGridUnit = 0) {
        self.center = center
        self.radius = radius
        invalidate()
    }
    
    public func contains(_ coordinate: CubicCoordinate) -> Bool {
        allCoordinates.contains(coordinate)
    }
    
    public var allCoordinates: Set<CubicCoordinate> = []
    
    private mutating func invalidate() {
        allCoordinates = calculateCoordinates()
    }
    
    private func calculateCoordinates() -> Set<CubicCoordinate> {
        let radius = GridUnit(self.radius)

        return Set((-radius...radius).flatMap { (q: GridUnit) -> [CubicCoordinate] in
            let minR = max(-radius, CubicSystemConstraint.r(q: q, s: radius))
            let maxR = min(radius, CubicSystemConstraint.r(q: q, s: -radius))
            return (minR...maxR).map { r in
                try! CubicCoordinate(q: q,
                                     r: r,
                                     s: CubicSystemConstraint.s(q: q, r: r))
            }
        })
    }
}
