//
//  TimePickerView.swift
//  UnderWorkApp
//
//  Created by newgaoxin on 2025/2/9.
//

import SwiftUI

// 修改后的TimePickerView组件
struct TimePickerView: View {
    @Binding var selectedTime: Date
    let title: String
    @State private var showingPicker = false
    @State private var tempTime: Date
    
    init(title: String, selectedTime: Binding<Date>) {
        self.title = title
        self._selectedTime = selectedTime
        self._tempTime = State(initialValue: selectedTime.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: { showingPicker = true }) {
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.gray)
                    
                    Text(timeString(from: selectedTime))
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color.primary)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 1.5)
                        )
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .sheet(isPresented: $showingPicker) {
            timePickerModal
        }
    }
    
    private var timePickerModal: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 16) {
                DatePicker("", selection: $tempTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                
                HStack(spacing: 20) {
                    Button("取消") {
                        showingPicker = false
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button("确认") {
                        selectedTime = tempTime
                        showingPicker = false
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .cornerRadius(20)
        }
        .frame(maxHeight: 350)
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hans_CN")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerView(title: "上班时间", selectedTime: .constant(Date()))
    }
}
