import SwiftUI

struct LoggingView: View {
    @ObservedObject var logger = Logger.shared
    
    func breakLogLevel(log: String) -> Color {
        if log.contains("INFO") {
            return .green
        } else if log.contains("WARNING") {
            return .yellow
        } else if log.contains("ERROR") {
            return .red
        } else {
            return .primary
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(logger.logs, id: \.self) { log in
                    Text(log)
                        .foregroundStyle(breakLogLevel(log: log))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .navigationTitle("Logs")
    }
}

#Preview {
    LoggingView()
}
