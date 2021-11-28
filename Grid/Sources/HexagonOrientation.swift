public enum HexagonOrientation: String, Codable {
    
    /// Hexagons are positioned in a way that their base is a vertice (e.g. hexagons are "staying on a vertice" - ⬢).
    ///
    /// In this orientation a cubic coordinate system is aligned with three-dimensional axes, so that:
    /// - X-axis corresponds to `q-axis` (direction: `-↙↗+`)
    /// - Y-axis corresponds to `s-axis` (direction: `+↖↘-`)
    /// - Z-axis corresponds to `r-axis` (direction: `+↓↑-`)
    case vertice
    
    /// Hexagons are positioned in a way that their base is an edge (e.g. hexagons are "laying on the edge" - ⬣).
    ///
    /// In this orientation cubic coordinate system described in `vertice` orientation is rotated clockwise so that `q-axis` is horizontally aligned.
    /// This rotation slightly changes directions at which axes point:
    /// - X-axis corresponds to `q-axis` (direction: `-←→+`)
    /// - Y-axis corresponds to `s-axis` (direction: `+↖↘-`)
    /// - Z-axis corresponds to `r-axis` (direction: `+↙↗-`)
    case edge
}
