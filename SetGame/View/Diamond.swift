//
// Created by 梁昊 on 2021/12/8.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let left = CGPoint(x: rect.minX, y: rect.midY)
        let top = CGPoint(x: rect.midX, y: rect.maxY)
        let right = CGPoint(x: rect.maxX, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: rect.minY)
        p.addLines([top, right, bottom, left, top])
        return p
    }


}
