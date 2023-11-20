//
//  Register-extension.swift
//  Pickle
//
//  Created by 박형환 on 11/20/23.
//

import SwiftUI

// MARK: View modifier extension
extension View {
    func differentTypeAlerts(alert condition: Binding<AlertCondition>,
                             delete: Binding<Bool>,
                             deleteAction: @escaping () -> Void) -> some View {
        modifier(RegisterView.DifferentTypeAlerts(condition: condition,
                                                  delete: delete,
                                                  deleteAction: deleteAction))
    }
}

struct AlertCondition {
    var showFailedAlert: Bool = false
    var showUpdateEqual: Bool = false
    var showUpdateSuccessAlert: Bool = false
    var showSuccessAlert: Bool = false
    // var successDelete: Bool = false
    var isShowingEditTodo: Bool = true
}

// MARK: Show Alert View Modifier
extension RegisterView {
    struct DifferentTypeAlerts: ViewModifier {
        
        @Environment(\.dismiss) var dissmiss
        @Binding var condition: AlertCondition
        @Binding var delete: Bool
        let deleteAction: () -> Void
        
        private var notMeedContent: AlertContent {
            .init(isPresented: $condition.showFailedAlert,
                  title: "실패",
                  alertContent: "1글자 이상 입력해주세요",
                  primaryButtonTitle: "확인",
                  secondaryButtonTitle: "",
                  primaryAction: { /* 알럿 확인 버튼 액션 */  },
                  secondaryAction: { })
        }
        
        private var equalContent: AlertContent {
            .init(isPresented: $condition.showUpdateEqual,
                  title: "실패",
                  alertContent: "같은 내용입니다.",
                  primaryButtonTitle: "확인",
                  secondaryButtonTitle: "뒤로가기",
                  primaryAction: {   },
                  secondaryAction: { dissmiss() })
        }
        
        private var updateContent: AlertContent {
            .init(isPresented: $condition.showUpdateSuccessAlert,
                  title: "수정 성공",
                  alertContent: "성공적으로 수정했습니다",
                  primaryButtonTitle: "수정하기",
                  secondaryButtonTitle: "뒤로가기",
                  primaryAction: {   },
                  secondaryAction: { dissmiss() })
        }
        
        private var saveContent: AlertContent {
            .init(isPresented: $condition.showSuccessAlert,
                  title: "저장 성공",
                  alertContent: "성공적으로 할일을 등록했습니다",
                  primaryButtonTitle: "계속 추가하기",
                  secondaryButtonTitle: "뒤로가기",
                  primaryAction: {   },
                  secondaryAction: { dissmiss() })
        }
        
        private var deleteContent: AlertContent {
            .init(isPresented: $delete,
                  title: "삭제",
                  alertContent: "삭제 하시겠습니까?",
                  primaryButtonTitle: "삭제하기",
                  secondaryButtonTitle: "취소하기",
                  primaryAction: { deleteAction(); condition.isShowingEditTodo.toggle() },
                  secondaryAction: { })
        }
        
        func body(content: Content) -> some View {
            content
                .successAlert(content: saveContent)
                .successAlert(content: deleteContent)
                .successAlert(content: updateContent)
                .failedAlert(content: equalContent)
                .failedAlert(content: notMeedContent)
        }
    }
}
