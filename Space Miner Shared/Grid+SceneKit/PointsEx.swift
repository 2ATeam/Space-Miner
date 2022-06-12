import SceneKit
import CoreGraphics

extension CGPoint {
    
    func distance(to other: CGPoint) -> CGFloat {
        sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
    }
}

extension CGPoint {
    
    static func + (_ lhs: CGPoint, _ rhs: CGVector) -> CGPoint {
        .init(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
    
    static func - (_ lhs: CGPoint, _ rhs: CGVector) -> CGPoint {
        .init(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }
    
    static func += (lhs: inout CGPoint, rhs: CGVector) {
        lhs.x += rhs.dx
        lhs.y += rhs.dy
    }

    static func -= (lhs: inout CGPoint, rhs: CGVector) {
        lhs.x -= rhs.dx
        lhs.y -= rhs.dy
    }
    
    static func * (point: CGPoint, constant: CGFloat) -> CGPoint {
        .init(x: point.x * constant,
              y: point.y * constant)
    }

    static func / (point: CGPoint, constant: CGFloat) -> CGPoint {
        .init(x: point.x / constant,
              y: point.y / constant)
    }
    
    static func * (constant: CGFloat, point: CGPoint) -> CGPoint {
        point * constant
    }

    static func / (constant: CGFloat, point: CGPoint) -> CGPoint {
        point / constant
    }
    
    static func *= (point: inout CGPoint, constant: CGFloat) {
        point.x *= constant
        point.y *= constant
    }

    static func /= (point: inout CGPoint, constant: CGFloat) {
        point.x /= constant
        point.y /= constant
    }
}

extension CGVector {
    
    static func + (_ lhs: CGVector, _ rhs: CGVector) -> CGVector {
        .init(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    
    static func - (_ lhs: CGVector, _ rhs: CGVector) -> CGVector {
        .init(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
    
    static func += (lhs: inout CGVector, rhs: CGVector) {
        lhs.dx += rhs.dx
        lhs.dy += rhs.dy
    }

    static func -= (lhs: inout CGVector, rhs: CGVector) {
        lhs.dx -= rhs.dx
        lhs.dy -= rhs.dy
    }
    
    static func * (vector: CGVector, constant: CGFloat) -> CGVector {
        .init(dx: vector.dx * constant,
              dy: vector.dy * constant)
    }

    static func / (vector: CGVector, constant: CGFloat) -> CGVector {
        .init(dx: vector.dx / constant,
              dy: vector.dy / constant)
    }
    
    static func * (constant: CGFloat, vector: CGVector) -> CGVector {
        vector * constant
    }

    static func / (constant: CGFloat, vector: CGVector) -> CGVector {
        vector / constant
    }
    
    static func *= (vector: inout CGVector, constant: CGFloat) {
        vector.dx *= constant
        vector.dy *= constant
    }

    static func /= (vector: inout CGVector, constant: CGFloat) {
        vector.dx /= constant
        vector.dy /= constant
    }
}

extension SCNVector3 {
    
    func distance(to vector: SCNVector3) -> CGFloat {
        CGFloat(simd_distance(simd_float3(self), simd_float3(vector)))
    }
}

extension SCNVector3 {
    
    static func + (_ lhs: SCNVector3, _ rhs: SCNVector3) -> SCNVector3 {
        .init(lhs.x + rhs.x,
              lhs.y + rhs.y,
              lhs.z + rhs.z)
    }
    
    static func - (_ lhs: SCNVector3, _ rhs: SCNVector3) -> SCNVector3 {
        .init(lhs.x - rhs.x,
              lhs.y - rhs.y,
              lhs.z - rhs.z)
    }
    
    static func += (_ lhs: inout SCNVector3, _ rhs: SCNVector3) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }
    
    static func -= (_ lhs: inout SCNVector3, _ rhs: SCNVector3) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }
    
    static func * (_ vector: SCNVector3, _ constant: CGFloat) -> SCNVector3 {
        .init(vector.x * constant,
              vector.y * constant,
              vector.z * constant)
    }
    
    static func * (_ constant: CGFloat, _ vector: SCNVector3) -> SCNVector3 {
        .init(vector.x * constant,
              vector.y * constant,
              vector.z * constant)
    }
    
    static func / (_ vector: SCNVector3, _ constant: CGFloat) -> SCNVector3 {
        .init(vector.x / constant,
              vector.y / constant,
              vector.z / constant)
    }
    
    static func / (_ constant: CGFloat, _ vector: SCNVector3) -> SCNVector3 {
        .init(vector.x / constant,
              vector.y / constant,
              vector.z / constant)
    }
    
    static func *= (_ lhs: inout SCNVector3, _ rhs: CGFloat) {
        lhs.x *= rhs
        lhs.y *= rhs
        lhs.z *= rhs
    }
    
    static func /= (_ lhs: inout SCNVector3, _ rhs: CGFloat) {
        lhs.x /= rhs
        lhs.y /= rhs
        lhs.z /= rhs
    }
}


extension CGPoint {
    
    var vector: SCNVector3 {
        .init(x, y, 0)
    }
    
    var vectorXZ: SCNVector3 {
        .init(0, y, x)
    }
    
    var vectorYZ: SCNVector3 {
        .init(x, 0, y)
    }
}

extension SCNVector3 {
    
    init(_ point: CGPoint) {
        self.init(point.x, point.y, 0)
    }
}
