//
// Created by 梁昊 on 2021/12/8.
//

import SwiftUI

struct AspectVGrid<Data, ItemView>: View where ItemView: View, Data: RandomAccessCollection, Data.Element: Identifiable{

    var aspectRatio: CGFloat
    var items: Data
    @ViewBuilder var createItemView: (Data.Element) -> ItemView

    private func adaptiveGridItem(minimum: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: minimum))
        gridItem.spacing = 0
        return gridItem
    }

    var body: some View {
        GeometryReader { geometry in
            let width = widthThatFits(size: geometry.size, itemCount: items.count, itemAspectRatio: aspectRatio)
            LazyVGrid(columns: [adaptiveGridItem(minimum: width)], spacing: 0) {
                ForEach(items) { item in
                    createItemView(item).aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }

    private func widthThatFits(size: CGSize, itemCount: Int, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if (itemHeight * CGFloat(rowCount) <= size.height) {
                break
            }
            columnCount += 1
            rowCount = (itemCount + columnCount - 1) / columnCount
        } while (columnCount < itemCount)

        return floor(min(size.width / CGFloat(columnCount), size.height / CGFloat(rowCount) * itemAspectRatio))
    }
}
