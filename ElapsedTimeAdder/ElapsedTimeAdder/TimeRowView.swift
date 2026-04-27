//
//  TimeRowView.swift
//  ElapsedTimeAdder
//
//  UI for a single time-entry row.

import SwiftUI

struct TimeRowView: View {
    @Bindable var row: TimeRow

    var body: some View {
        HStack(spacing: 8) {

            // Title
            TextField("title (opt)", text: $row.title)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: .infinity)

            // Hours
            TextField("0", text: $row.hours)
                .textFieldStyle(.roundedBorder)
                .frame(width: 70)
                .multilineTextAlignment(.center)
#if os(iOS)
                .keyboardType(.decimalPad)
#endif

            // Minutes
            TextField("0", text: $row.minutes)
                .textFieldStyle(.roundedBorder)
                .frame(width: 70)
                .multilineTextAlignment(.center)
#if os(iOS)
                .keyboardType(.decimalPad)
#endif

            // Seconds
            TextField("0", text: $row.seconds)
                .textFieldStyle(.roundedBorder)
                .frame(width: 70)
                .multilineTextAlignment(.center)
#if os(iOS)
                .keyboardType(.decimalPad)
#endif

            // +/− toggle (right side, matching web app)
            Button {
                row.isSubtracting.toggle()
            } label: {
                Text(row.isSubtracting ? "−" : "+")
                    .font(.title3.bold())
                    .frame(width: 44, height: 34)
                    .foregroundColor(row.isSubtracting ? .red : .blue)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(row.isSubtracting ? Color.red : Color.blue, lineWidth: 1.5)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 2)
    }
}
