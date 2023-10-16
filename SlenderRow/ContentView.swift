//
//  ContentView.swift
//  SlenderRow
//
//  Created by Maxim Keegan on 16.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State var isDiagonal = false
    let colors: [Color] = [.yellow, .orange, .red, .pink, .purple, .blue, .cyan]
    
    var body: some View {
        let layout = isDiagonal ? AnyLayout(DiagonalLayout()) : AnyLayout(HStackLayout(spacing: 10))
        
        layout {
            ForEach(0..<colors.count, id: \.self) { idx in
                Button {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        isDiagonal.toggle()
                    }
                    
                } label: {
                    Text("\(idx+1)")
                        .frame(width: 20, height: 30)
                }
                .tint(colors[idx%colors.count].opacity(0.7))
                .buttonStyle(.bordered)
            }
        }
    }
}

struct DiagonalLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        // 1
          let subviewSizes = subviews.map { proxy in
              return proxy.sizeThatFits(.unspecified)
          }
          
          // 2
          let combinedSize = subviewSizes.reduce(.zero) { currentSize, subviewSize in
              return CGSize(
                  width: currentSize.width + subviewSize.width,
                  height: currentSize.height + subviewSize.height)
          }
          
          // 3
          return combinedSize
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ())
    {
            let subviewSizes = subviews.map { proxy in
                return proxy.sizeThatFits(.unspecified)
            }
            var x = bounds.minX
            var y = bounds.maxY
            
            for index in subviews.indices {
                let subviewSize = subviewSizes[index]
                let sizeProposal = ProposedViewSize(
                    width: subviewSize.width,
                    height: subviewSize.height)
                
                subviews[index]
                    .place(
                        at: CGPoint(x: x, y: y),
                        anchor: .topLeading,
                        proposal: sizeProposal
                    )

                x += subviewSize.width
                y -= subviewSize.height
            }
    }
}

#Preview {
    ContentView()
}
