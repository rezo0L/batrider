import SwiftUI

struct VehicleView: View {
    @StateObject private var viewModel: VehicleViewModel
    @Environment(\.presentationMode) var presentationMode

    init(viewModel: VehicleViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }

            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(35)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 15) {
                        Image(systemName: "xmark.octagon.fill")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await viewModel.fetchVehicle()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .padding(30)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding()
                } else if viewModel.vehicle != nil {
                    vehicleContentView()
                        .onTapGesture {
                            // This empty gesture prevents the background tap from firing
                            // when the user interacts with the content card itself.
                        }
                }
            }
            .padding()
        }
        .task {
            if viewModel.vehicle == nil {
                await viewModel.fetchVehicle()
            }
        }
    }

    @ViewBuilder
    private func vehicleContentView() -> some View {
        VStack(spacing: 0) {
            // Header Section
            VStack(spacing: 4) {
                Text(viewModel.name ?? "Vehicle Name")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text(viewModel.category ?? "Category")
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 20)

            // Price Section
            Text(viewModel.formattedPrice ?? "$0.00")
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundColor(.accentColor)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(.quaternary)

            // Details Section
            VStack(spacing: 16) {
                detailRow(title: "Vehicle ID", value: viewModel.id ?? "N/A")
            }
            .padding(20)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }
}
