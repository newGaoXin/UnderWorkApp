//
//  RestDaysView.swift
//  UnderWorkApp
//
//  Created by newgaoxin on 2025/2/9.
//

import SwiftUI

struct RestDaysView: View {
    @Binding var restType: UserSettings.RestType
    @Binding var customRestDays: Set<UserSettings.Weekday>
    
    var body: some View {
        VStack(spacing: 30) {
            Text("📅 休息类型")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                RestTypeButton(
                    title: "双休",
                    subtitle: "周六、周日休息",
                    isSelected: restType == .doubleRest
                ) {
                    restType = .doubleRest
                }
                
                RestTypeButton(
                    title: "单休",
                    subtitle: "周日休息",
                    isSelected: restType == .singleRest
                ) {
                    restType = .singleRest
                }
                
                RestTypeButton(
                    title: "自定义",
                    subtitle: "自由选择休息日",
                    isSelected: restType == .custom
                ) {
                    restType = .custom
                }
                
                // 优化后的自定义区域
               if restType == .custom {
                   weekdaysGrid
                       .transition(.opacity) // 简化动画
               } else {
                   Spacer().frame(height: 20) // 保持占位高度
               }
            }
            .animation(.easeInOut(duration: 0.25), value: restType) // 添加统一动画
            .padding(.bottom, restType == .custom ? 0 : 20) // 动态底部间距
            
            Spacer()
        }
    }
    
    private var weekdaysGrid: some View {
        VStack(spacing: 15) {
            Text("选择休息日")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondaryText)
            
            HStack(spacing: 10) {
                ForEach(UserSettings.Weekday.allCases, id: \.self) { weekday in
                    WeekdayButton(
                        weekday: weekday,
                        isSelected: customRestDays.contains(weekday)
                    ) {
                        if customRestDays.contains(weekday) {
                            customRestDays.remove(weekday)
                        } else {
                            customRestDays.insert(weekday)
                        }
                    }
                }
            }
            .fixedSize() // 固定尺寸防止布局变化
            .frame(width: 300)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
        )
    }
}

#Preview(body: {
    let restType = UserSettings.RestType.custom
    RestDaysView(
        restType: .constant(restType),
        customRestDays: .constant(Set())
    )
})

struct RestTypeButton: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primaryText)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .accentColor : .secondaryText)
                    .font(.system(size: 24))
            }
            .contentShape(Rectangle()) // 新增关键代码
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor : Color.cardBackground, lineWidth: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct WeekdayButton: View {
    let weekday: UserSettings.Weekday
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
            Button(action: action) {
                ZStack {
                    // 背景圆形
                    Circle()
                        .fill(isSelected ? Color.accentColor : Color.clear)
                        .frame(width: 35, height: 35)
                    
                    // 边框（始终显示主色调）
                    Circle()
                        .stroke(
                            isSelected ? Color.accentColor : Color.accentColor.opacity(0.3),
                            lineWidth: isSelected ? 3 : 2 // 选中时加粗线条
                        )
                        .frame(width: 35, height: 35)
                    
                    // 文字
                    Text(weekdayDisplay)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSelected ? .white : .accentColor) // 统一使用主色调
                }
                .contentShape(Circle()) // 精确点击区域
            }
            .buttonStyle(ScaleButtonStyle())
            .animation(.easeInOut(duration: 0.2), value: isSelected) // 添加状态切换动画
    }
    
    private var weekdayDisplay: String {
        switch weekday {
        case .mon: return "一"
        case .tue: return "二"
        case .wed: return "三"
        case .thu: return "四"
        case .fri: return "五"
        case .sat: return "六"
        case .sun: return "日"
        }
    }
}
