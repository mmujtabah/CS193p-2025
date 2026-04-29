//
//  MatchMarkers.swift
//  CodeBreaker-Stanford
//
//  Created by Muhammad Mujtaba Hussain on 3/27/26.
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    var matches: [Match]

    var body: some View {
        let cols = (matches.count + 1) / 2
        
        HStack {
            ForEach(0..<cols, id: \.self) { col in
                VStack {
                    matchMarker(peg: col * 2)
                    matchMarker(peg: col * 2 + 1)
                }
            }
        }
    }

    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count { $0 == .exact }
        let foundCount = matches.count { $0 != .nomatch }
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(
                foundCount > peg ? Color.primary : Color.clear,
                lineWidth: 2
            ).aspectRatio(contentMode: .fit)
            .opacity(peg < foundCount ? 1 : 0)
    }
}

struct MatchMarkersPreview: View {
    var matches: [Match]

    var body: some View {
        let cells = matches.count

        HStack {
            ForEach(0..<cells, id: \.self) { _ in
                Circle()
                    .fill(.primary)
            }
            MatchMarkers(matches: matches)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    VStack {
        MatchMarkersPreview(matches: [.exact, .inexact, .nomatch])

        MatchMarkersPreview(matches: [.exact, .nomatch, .nomatch])

        MatchMarkersPreview(matches: [.exact, .exact, .inexact, .inexact])

        MatchMarkersPreview(matches: [.exact, .exact, .inexact, .nomatch])

        MatchMarkersPreview(matches: [.exact, .inexact, .nomatch, .nomatch])

        MatchMarkersPreview(matches: [.exact, .exact, .exact, .inexact, .nomatch, .nomatch])

        MatchMarkersPreview(matches: [.exact, .exact, .exact, .inexact, .inexact, .inexact])

        MatchMarkersPreview(matches: [.exact, .exact, .inexact, .inexact, .inexact])

        MatchMarkersPreview(matches: [.exact, .inexact, .inexact, .nomatch, .nomatch])
    }
    .padding()
}
