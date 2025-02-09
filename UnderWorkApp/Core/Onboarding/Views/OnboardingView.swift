//
//  OnboardingView.swift
//  UnderWorkApp
//
//  Created by newgaoxin on 2025/2/2.
//

import SwiftUI
import Foundation

struct OnboardingView: View {
    @EnvironmentObject private var settings : UserSettings
    @State private var currentStep = 0
    @State private var isSalaryFocused: Bool = false
    @State private var workStartTime =  Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
    @State private var workEndTime =  Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!
    @State private var salaryInput: String = "0"
    



    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 步骤指示器
                StepIndicator(currentStep: currentStep)
                    .padding(.top, 50)
                    .padding(.bottom,20)
                
                Group {
                    switch currentStep {
                    case 0: salaryStep
                    case 1: timeStep
                    case 2: restStep
                    default: EmptyView()
                    }
                }
                .frame(height: geometry.size.height * 0.7)
                
                Spacer()
                
                // 底部操作按钮部分
                HStack(spacing: 15) {
                    if currentStep > 0 {
                        // 返回按钮（仅在非第一步显示）
                        Button(action: goBack) {
                            Text("返回")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.accentColor)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.accentColor, lineWidth: 1.5)
                                )
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .frame(maxWidth: .infinity)
                       
                    }
                    
                    // 主操作按钮
                    Button(action: handleButtonAction) {
                        Text(buttonText)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentColor)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 40)
                .padding(.horizontal, 30)
            }
            .padding(.horizontal, 30)
            .background(Color.background.edgesIgnoringSafeArea(.all))
        }
    }
    
    // 新增第三步视图
    private var restStep: some View {
        RestDaysView(
            restType: $settings.restType,
            customRestDays: $settings.customRestDays
        )
    }
    
    // 自定义字体扩展（需在Assets中添加字体文件）
    private var buttonText: String {
           currentStep == 2 ? "完成" : "下一步"
    }

    private func goBack() {
        guard currentStep > 0 else { return }
        withAnimation(.spring) {
            currentStep -= 1
        }
    }
    
    // MARK: - 薪资输入步骤
    private var salaryStep: some View {
        ZStack {
            VStack(spacing: 40) {
                // 标题
                Text("💰 你的月薪")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                // 输入区域
               ZStack(alignment: .center) {
                   // 可视文本
                   Text(salaryInput)
                       .font(.system(size: 48, weight: .bold))
                       .foregroundColor(.accentColor)
                   
                   // 透明输入框
                   SalaryTextField(
                        text: $salaryInput,
                       isActive: $isSalaryFocused
                   )
                   .frame(width: 200, height: 60)
               }
               .overlay(
                   Rectangle()
                       .frame(height: 2)
                       .foregroundColor(.accentColor)
                       .padding(.horizontal, 20)
                       .offset(y: 30)
               )
                
                Text("输入月薪开始计算摸鱼价值")
                    .font(.system(size: 14))
                    .foregroundColor(.secondaryText)
                
                Spacer()
                Spacer()
            }
            .onTapGesture {
                hideKeyboard()  // 隐藏键盘
            }
        }

    }
    
    // MARK: - 时间选择步骤
    private var timeStep: some View {
        VStack(spacing: 40) {
            Text("⏰ 工作时间")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            VStack(alignment: .center, spacing: 30) {
                TimePickerView(title: "上班时间", selectedTime: $workStartTime)
                TimePickerView(title: "下班时间", selectedTime: $workEndTime)
            }
            Text("设置你的常规工作时间")
                .font(.system(size: 14))
                .foregroundColor(.secondaryText)
            
            Spacer()
            Spacer()
        }
    }
    
    // MARK: - 按钮操作
    private func handleButtonAction() {
           if currentStep < 2 {
               withAnimation(.spring()) {
                   currentStep += 1
               }
           } else {
               settings.saveToUserDefaults()
               UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
           }
    }
}

// MARK: - 自定义TextField（兼容iOS 14）
struct SalaryTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isActive: Bool
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        textField.textColor = .clear // 透明文字
        textField.tintColor = .clear  // 透明光标
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if isActive {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: SalaryTextField
        
        init(_ textField: SalaryTextField) {
            self.parent = textField
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isActive = true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.isActive = false
        }
    }
}

// 预览
#Preview {
    OnboardingView()
        .environmentObject(UserSettings.shared)
}


// MARK: - 步骤指示器
struct StepIndicator: View {
    let currentStep: Int
    private let totalSteps = 3
    private let dotSize: CGFloat = 10
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<totalSteps, id: \.self) { step in
                Circle()
                    .frame(width: dotSize, height: dotSize)
                    .foregroundColor(step <= currentStep ? .accentColor : .progressInactive)
                    .scaleEffect(step == currentStep ? 1.2 : 1.0)
            }
        }
        .animation(.easeInOut, value: currentStep)
    }
}

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
