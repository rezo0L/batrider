import DesignSystem
import SwiftUI

struct VehicleView: View {
    @StateObject private var viewModel: VehicleViewModel
    @Environment(\.presentationMode) var presentationMode

    init(viewModel: VehicleViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            DesignSystem.Color.overlay
                .ignoresSafeArea()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }

            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(DesignSystem.Layout.largePadding)
                        .background(.thinMaterial)
                        .cornerRadius(DesignSystem.Layout.cornerRadius)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 15) {
                        Image(systemName: DesignSystem.Icon.close)
                            .font(.init(DesignSystem.Font.title))
                            .foregroundColor(DesignSystem.Color.error)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                        Button(String.retryButton) {
                            Task {
                                await viewModel.fetchVehicle()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .padding(DesignSystem.Layout.mediumPadding)
                    .background(DesignSystem.Color.background)
                    .cornerRadius(DesignSystem.Layout.cornerRadius)
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
                Text(viewModel.name ?? .vehicleNamePlaceholder)
                    .font(.init(DesignSystem.Font.title))
                    .foregroundColor(DesignSystem.Color.primaryText)

                Text(viewModel.category ?? .categoryPlaceholder)
                    .font(.init(DesignSystem.Font.body))
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Color.secondaryText)
            }
            .padding(.vertical, DesignSystem.Layout.verticalSpacing)

            // Price Section
            Text(viewModel.formattedPrice ?? .pricePlaceholder)
                .font(.init(DesignSystem.Font.price))
                .foregroundColor(DesignSystem.Color.accent)
                .padding(.vertical, DesignSystem.Layout.verticalSpacing)
                .frame(maxWidth: .infinity)
                .background(DesignSystem.Color.secondarySystemBackground)

            // Details Section
            VStack(spacing: 16) {
                detailRow(title: .vehicleIDTitle, value: viewModel.id ?? .vehicleIDPlaceholder)
            }
            .padding(DesignSystem.Layout.mediumPadding)
        }
        .background(DesignSystem.Color.background)
        .cornerRadius(DesignSystem.Layout.cornerRadius)
        .shadow(color: DesignSystem.Color.overlay25, radius: 10, x: 0, y: 5)
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.init(DesignSystem.Font.detailTitle))
                .foregroundColor(DesignSystem.Color.secondaryText)
            Spacer()
            Text(value)
                .font(.init(DesignSystem.Font.detail))
                .foregroundColor(DesignSystem.Color.primaryText)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }
}
