//
//  FormatStartTextField.swift
//  AnyFormatKitSwiftUI
//
//  Created by Oleksandr Orlov on 03.02.2021.
//

import SwiftUI
import AnyFormatKit

/// SwiftUI TextField with formatting and setting caret at begin editing
/// Can be usefull for PlaceholderTextInputFormatter
@available(iOS 13.0, *)
public struct FormatStartTextField: UIViewRepresentable {

    // MARK: - Typealiases

    public typealias UIViewType = UITextField
    public typealias FormatterType = (TextInputFormatter & TextFormatter & TextUnformatter & CaretPositioner)

    // MARK: - Data

    private let placeholder: String?
    @Binding public var unformattedText: String
    private let prePasteCleaner: ((String) -> String)?

    // MARK: - Appearence

    private var font: UIFont?
    private var textColor: UIColor?
    private var placeholderColor: UIColor?
    private var accentColor: UIColor?
    private var clearButtonMode: UITextField.ViewMode = .never
    private var borderStyle: UITextField.BorderStyle = .none
    private var textAlignment: NSTextAlignment?
    private var keyboardType: UIKeyboardType = .default
    private var textContentType: UITextContentType?
    private var disableAutocorrection: Bool = false
    private var autoCapitalizationType: UITextAutocapitalizationType = .sentences
    
    // MARK: - Private actions

    private var onEditingBeganHandler: TextAction?
    private var onEditingEndHandler: TextAction?
    private var onTextChangeHandler: TextAction?
    private var onClearHandler: VoidAction?
    private var onReturnHandler: VoidAction?

    // MARK: - Dependencies

    private let formatter: FormatterType

    // MARK: - Life cycle

    public init(unformattedText: Binding<String>,
                placeholder: String? = nil,
                formatter: FormatterType,
                prePasteCleaner: ((String) -> String)? = nil
    ) {
        self._unformattedText = unformattedText
        self.placeholder = placeholder
        self.formatter = formatter
        self.prePasteCleaner = prePasteCleaner
    }

    // MARK: - UIViewRepresentable

    public func makeUIView(context: Context) -> UIViewType {
        let uiView = UITextField()
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.delegate = context.coordinator
        context.coordinator.formatter = formatter
        return uiView
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
        let formattedText = formatter.format(unformattedText)
        if uiView.text != formattedText {
            uiView.text = formattedText
        }
        uiView.textColor = textColor
        uiView.font = font
        updateUIViewPlaceholder(uiView)
        uiView.clearButtonMode = clearButtonMode
        uiView.borderStyle = borderStyle
        uiView.tintColor = accentColor
        uiView.keyboardType = keyboardType
        uiView.textContentType = textContentType
        uiView.autocorrectionType = disableAutocorrection ? .no : .yes
        uiView.autocapitalizationType = autoCapitalizationType
        
        updateUIViewTextAlignment(uiView)
    }

    private func updateUIViewPlaceholder(_ uiView: UIViewType) {
        if let placeholder = placeholder {
            if let placeholderColor = placeholderColor {
                uiView.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: placeholderColor])
            } else {
                uiView.placeholder = placeholder
            }
        } else {
            uiView.placeholder = nil
        }
    }

    private func updateUIViewTextAlignment(_ uiView: UIViewType) {
        guard let textAlignment = textAlignment else { return }
        uiView.textAlignment = textAlignment
    }

    public func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(unformattedText: $unformattedText,
                                      prePasteCleaner: prePasteCleaner)
        coordinator.onEditingBegan = onEditingBeganHandler
        coordinator.onEditingEnd = onEditingEndHandler
        coordinator.onTextChange = onTextChangeHandler
        coordinator.onClear = onClearHandler
        coordinator.onReturn = onReturnHandler
        return coordinator
    }

    // MARK: - View modifiers

    public func font(_ font: UIFont?) -> Self {
        var view = self
        view.font = font
        return view
    }

    // foregroundColor
    @available(iOS 14.0, *)
    public func foregroundColor(_ color: Color?) -> Self {
        if let color = color {
            return foregroundColor(UIColor(color))
        } else {
            return nilForegroundColor()
        }
    }

    public func foregroundColor(_ color: UIColor?) -> Self {
        var view = self
        view.textColor = color
        return view
    }

    private func nilForegroundColor() -> Self {
        var view = self
        view.textColor = nil
        return view
    }

    // placeholderColor
    public func placeholderColor(_ color: UIColor?) -> Self {
        var view = self
        view.placeholderColor = color
        return view
    }

    @available(iOS 14.0, *)
    public func placeholderColor(_ color: Color?) -> Self {
        if let color = color {
            return placeholderColor(UIColor(color))
        } else {
            return nilPlaceholderColor()
        }
    }

    private func nilPlaceholderColor() -> Self {
        var view = self
        view.placeholderColor = nil
        return view
    }

    // accentColor
    public func accentColor(_ color: UIColor?) -> Self {
        var view = self
        view.accentColor = color
        return view
    }

    @available(iOS 14.0, *)
    public func accentColor(_ color: Color?) -> Self {
        if let color = color {
            return accentColor(UIColor(color))
        } else {
            return nilAccentColor()
        }
    }

    private func nilAccentColor() -> Self {
        var view = self
        view.accentColor = nil
        return view
    }

    // clearButtonMode
    public func clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        var view = self
        view.clearButtonMode = mode
        return view
    }

    // borderStyle
    public func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        var view = self
        view.borderStyle = style
        return view
    }

    // textAlignment
    public func textAlignment(_ alignment: TextAlignment) -> Self {
        var view = self
        switch alignment {
        case .leading:
            view.textAlignment = .left
        case .trailing:
            view.textAlignment = .right
        case .center:
            view.textAlignment = .center
        }
        return view
    }
    
    // keyboardType
    public func keyboardTypeFormattedField(_ type: UIKeyboardType) -> Self {
        var view = self
        view.keyboardType = type
        return view
    }

    // textContentType
    public func textContentTypeFormattedField(_ type: UITextContentType?) -> Self {
        var view = self
        view.textContentType = type
        return view
    }
    
    // Autocorrect
    public func disableAutocorrectFormattedField(_ disable: Bool?) -> Self {
        var view = self
        view.disableAutocorrection = disable ?? false
        return view
    }
    
    // Autocapitalization
    public func autocapitalizationTypeFormattedField(_ type: UITextAutocapitalizationType) -> Self {
        var view = self
        view.autoCapitalizationType = type
        return view
    }
    
    // MARK: - Actions

    public func onEditingBegan(perform action: TextAction?) -> Self {
        var view = self
        view.onEditingBeganHandler = action
        return view
    }

    public func onEditingEnd(perform action: TextAction?) -> Self {
        var view = self
        view.onEditingEndHandler = action
        return view
    }

    public func onTextChange(perform action: TextAction?) -> Self {
        var view = self
        view.onTextChangeHandler = action
        return view
    }

    public func onClear(perform action: VoidAction?) -> Self {
        var view = self
        view.onClearHandler = action
        return view
    }

    public func onReturn(perform action: VoidAction?) -> Self {
        var view = self
        view.onReturnHandler = action
        return view
    }

    // MARK: - Coordinator

    public class Coordinator: NSObject, UITextFieldDelegate {

        let unformattedText: Binding<String>?
        let prePasteCleaner: ((String) -> String)?
        var formatter: FormatterType?

        var onEditingBegan: TextAction?
        var onEditingEnd: TextAction?
        var onTextChange: TextAction?
        var onClear: VoidAction?
        var onReturn: VoidAction?

        init(unformattedText: Binding<String>, prePasteCleaner: ((String) -> String)?) {
            self.unformattedText = unformattedText
            self.prePasteCleaner = prePasteCleaner
        }

        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let formatter = formatter else { return true }
            var cleanedString = prePasteCleaner?(string) ?? string
            
            let result = formatter.formatInput(
                currentText: textField.text ?? "",
                range: range,
                replacementString: cleanedString
            )
            textField.text = result.formattedText
            textField.setCursorLocation(result.caretBeginOffset)
            self.unformattedText?.wrappedValue = formatter.unformat(result.formattedText) ?? ""
            return false
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            onEditingBegan?(textField.text)
            guard let formatter = formatter else { return }
            let offset = formatter.getCaretOffset(for: textField.text ?? "")
            textField.setCursorLocation(offset)
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            onEditingEnd?(textField.text)
        }

        public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            onEditingEnd?(textField.text)
        }

        public func textFieldShouldClear(_ textField: UITextField) -> Bool {
            onClear?()
            return true
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.onReturn?()
            return true
        }
    }
}
