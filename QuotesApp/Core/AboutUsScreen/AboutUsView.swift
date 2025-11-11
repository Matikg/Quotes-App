import SwiftUI

struct AboutUsView: View {
    var body: some View {
        BaseView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 8) {
                        QText("about_us_mission", type: .bold, size: .medium)
                        QText("about_us_header1", type: .regular, size: .small)
                        QText("about_us_header2", type: .regular, size: .small)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        QText("about_us_team", type: .bold, size: .medium)
                        
                        VStack(spacing: 24) {
                            TeamMemberView(avatarName: "bartsonAvatar", name: "Bartek", description: "bartson_description")
                            TeamMemberView(avatarName: "matikgAvatar", name: "Mateusz", description: "matikg_description")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 30)
            }
        }
        .navBar {
            QText("about_us_title", type: .bold, size: .medium)
        }
    }
    
    //MARK: - View Builders
    
    private struct TeamMemberView: View {
        let avatarName: String
        let name: String
        let description: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Image(avatarName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 114, height: 114)
                    .clipShape(.circle)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                QText(name, type: .bold, size: .small)
                QText(description, type: .regular, size: .small)
            }
        }
    }
}

#Preview {
    AboutUsView()
}
