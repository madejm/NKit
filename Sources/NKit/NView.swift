import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

/// Abstraction over a view or collection of views (in `ForEach`)
/// Think as of SwiftUI's `View`
@MainActor
public protocol NView {}
extension _View: NView {}

extension Array: NView where Element == NView {}

#if canImport(SwiftUI)
extension SwiftUI.View {
    private var nView: NView {
        NSHostingView(rootView: self)
    }
}
extension SwiftUI.AngularGradient: NView {}
@available(macOS 13.0, *)
extension SwiftUI.AnyShape: NView {}
extension SwiftUI.AnyView: NView {}
@available(macOS 12.0, *)
extension SwiftUI.AsyncImage: NView {}
extension SwiftUI.Button: NView {}
@available(macOS 12.0, *)
extension SwiftUI.ButtonBorderShape: NView {}
extension SwiftUI.ButtonStyleConfiguration.Label: NView {}
@available(macOS 12.0, *)
extension SwiftUI.Canvas: NView {}
extension SwiftUI.Capsule: NView {}
extension SwiftUI.Circle: NView {}
extension SwiftUI.Color: NView {}
@available(macOS 11.0, *)
extension SwiftUI.ColorPicker: NView {}
//@available(macOS 26.0, *)
//extension SwiftUI.ConcentricRectangle: NView {}
@available(macOS 11.0, *)
extension SwiftUI.ContainerRelativeShape: NView {}
@available(macOS 14.0, *)
extension SwiftUI.ContentUnavailableView: NView {}
@available(macOS 12.0, *)
extension SwiftUI.ControlGroup: NView {}
@available(macOS 12.0, *)
extension SwiftUI.ControlGroupStyleConfiguration.Content: NView {}
@available(macOS 13.0, *)
extension SwiftUI.ControlGroupStyleConfiguration.Label: NView {}
extension SwiftUI.DatePicker: NView {}
@available(macOS 13.0, *)
extension SwiftUI.DatePickerStyleConfiguration.Label: NView {}
@available(macOS 26.0, *)
extension SwiftUI.DebugReplaceableView: NView {}
@available(macOS 26.0, *)
extension SwiftUI.DefaultButtonLabel: NView {}
@available(macOS 13.0, *)
extension SwiftUI.DefaultDateProgressLabel: NView {}
@available(macOS 15.0, *)
extension SwiftUI.DefaultDocumentGroupLaunchActions: NView {}
//@available(macOS 26.0, *)
//extension SwiftUI.DefaultGlassEffectShape: NView {}
@available(macOS 14.0, *)
extension SwiftUI.DefaultSettingsLinkLabel: NView {}
@available(macOS 13.0, *)
extension SwiftUI.DefaultShareLinkLabel: NView {}
@available(macOS 15.0, *)
extension SwiftUI.DefaultTabLabel: NView {}
@available(macOS 15.0, *)
extension SwiftUI.DefaultWindowVisibilityToggleLabel: NView {}
@available(macOS 11.0, *)
extension SwiftUI.DisclosureGroup: NView {}
@available(macOS 13.0, *)
extension SwiftUI.DisclosureGroupStyleConfiguration.Content: NView {}
@available(macOS 13.0, *)
extension SwiftUI.DisclosureGroupStyleConfiguration.Label: NView {}
extension SwiftUI.Divider: NView {}
@available(macOS, unavailable)
extension SwiftUI.DocumentLaunchView: NView {}
@available(macOS, unavailable)
extension SwiftUI.EditButton: NView {}
@available(macOS 13.0, *)
extension SwiftUI.EditableCollectionContent: NView {}
extension SwiftUI.Ellipse: NView {}
@available(macOS 12.0, *)
extension SwiftUI.EllipticalGradient: NView {}
extension SwiftUI.EmptyView: NView {}
extension SwiftUI.EquatableView: NView {}
@available(macOS 14.0, *)
extension SwiftUI.FillShapeView: NView {}
extension SwiftUI.ForEach: NView {}
extension SwiftUI.Form: NView {}
@available(macOS 13.0, *)
extension SwiftUI.FormStyleConfiguration.Content: NView {}
@available(macOS 13.0, *)
extension SwiftUI.Gauge: NView {}
@available(macOS 13.0, *)
extension SwiftUI.GaugeStyleConfiguration.CurrentValueLabel: NView {}
@available(macOS 13.0, *)
extension SwiftUI.GaugeStyleConfiguration.Label: NView {}
@available(macOS 13.0, *)
extension SwiftUI.GaugeStyleConfiguration.MarkedValueLabel: NView {}
@available(macOS 13.0, *)
extension SwiftUI.GaugeStyleConfiguration.MaximumValueLabel: NView {}
@available(macOS 13.0, *)
extension SwiftUI.GaugeStyleConfiguration.MinimumValueLabel: NView {}
extension SwiftUI.GeometryReader: NView {}
//@available(macOS 26.0, *)
//extension SwiftUI.GeometryReader3D: NView {}
//@available(macOS 26.0, *)
//extension SwiftUI.GlassBackgroundEffectConfiguration.Content: NView {}
@available(macOS 26.0, *)
extension SwiftUI.GlassEffectContainer: NView {}
@available(macOS 13.0, *)
extension SwiftUI.Grid: NView {}
@available(macOS 13.0, *)
extension SwiftUI.GridRow: NView {}
extension SwiftUI.Group: NView {}
extension SwiftUI.GroupBox: NView {}
@available(macOS 11.0, *)
extension SwiftUI.GroupBoxStyleConfiguration.Content: NView {}
@available(macOS 11.0, *)
extension SwiftUI.GroupBoxStyleConfiguration.Label: NView {}
@available(macOS 15.0, *)
extension SwiftUI.GroupElementsOfContent: NView {}
@available(macOS 15.0, *)
extension SwiftUI.GroupSectionsOfContent: NView {}
extension SwiftUI.HSplitView: NView {}
extension SwiftUI.HStack: NView {}
@available(macOS 14.0, *)
extension SwiftUI.HelpLink: NView {}
extension SwiftUI.Image: NView {}
@available(macOS 14.0, *)
extension SwiftUI.KeyframeAnimator: NView {}
@available(macOS 11.0, *)
extension SwiftUI.Label: NView {}
@available(macOS 11.0, *)
extension SwiftUI.LabelStyleConfiguration.Icon: NView {}
@available(macOS 11.0, *)
extension SwiftUI.LabelStyleConfiguration.Title: NView {}
@available(macOS 13.0, *)
extension SwiftUI.LabeledContent: NView {}
@available(macOS 13.0, *)
extension SwiftUI.LabeledContentStyleConfiguration.Content: NView {}
@available(macOS 13.0, *)
extension SwiftUI.LabeledContentStyleConfiguration.Label: NView {}
@available(macOS 13.0, *)
extension SwiftUI.LabeledControlGroupContent: NView {}
@available(macOS 13.0, *)
extension SwiftUI.LabeledToolbarItemGroupContent: NView {}
@available(macOS 11.0, *)
extension SwiftUI.LazyHGrid: NView {}
@available(macOS 11.0, *)
extension SwiftUI.LazyHStack: NView {}
@available(macOS 11.0, *)
extension SwiftUI.LazyVGrid: NView {}
@available(macOS 11.0, *)
extension SwiftUI.LazyVStack: NView {}
extension SwiftUI.LinearGradient: NView {}
@available(macOS 11.0, *)
extension SwiftUI.Link: NView {}
extension SwiftUI.List: NView {}
@available(macOS 11.0, *)
extension SwiftUI.Menu: NView {}
extension SwiftUI.MenuButton: NView {}
@available(macOS 11.0, *)
extension SwiftUI.MenuStyleConfiguration.Content: NView {}
@available(macOS 11.0, *)
extension SwiftUI.MenuStyleConfiguration.Label: NView {}
@available(macOS 15.0, *)
extension SwiftUI.MeshGradient: NView {}
extension SwiftUI.ModifiedContent: NView {}
@available(macOS, unavailable)
extension SwiftUI.MultiDatePicker: NView {}
extension SwiftUI.NavigationLink: NView {}
@available(macOS 13.0, *)
extension SwiftUI.NavigationSplitView: NView {}
@available(macOS 13.0, *)
extension SwiftUI.NavigationStack: NView {}
extension SwiftUI.NavigationView: NView {}
@available(macOS 15.0, *)
extension SwiftUI.NewDocumentButton: NView {}
extension SwiftUI.OffsetShape: NView {}
@available(macOS 11.0, *)
extension SwiftUI.OutlineGroup: NView {}
@available(macOS 11.0, *)
extension SwiftUI.OutlineSubgroupChildren: NView {}
extension SwiftUI.PasteButton: NView {}
extension SwiftUI.Path: NView {}
@available(macOS 14.0, *)
extension SwiftUI.PhaseAnimator: NView {}
extension SwiftUI.Picker: NView {}
@available(macOS 14.0, *)
extension SwiftUI.PlaceholderContentView: NView {}
@available(macOS 13.0, *)
extension SwiftUI.PresentedWindowContent: NView {}
@available(macOS 15.0, *)
extension SwiftUI.PreviewModifierContent: NView {}
extension SwiftUI.PrimitiveButtonStyleConfiguration.Label: NView {}
@available(macOS 11.0, *)
extension SwiftUI.ProgressView: NView {}
@available(macOS 11.0, *)
extension SwiftUI.ProgressViewStyleConfiguration.CurrentValueLabel: NView {}
@available(macOS 11.0, *)
extension SwiftUI.ProgressViewStyleConfiguration.Label: NView {}
extension SwiftUI.RadialGradient: NView {}
extension SwiftUI.Rectangle: NView {}
@available(macOS 13.0, *)
extension SwiftUI.RenameButton: NView {}
extension SwiftUI.RotatedShape: NView {}
extension SwiftUI.RoundedRectangle: NView {}
extension SwiftUI.ScaledShape: NView {}
extension SwiftUI.ScrollView: NView {}
@available(macOS 11.0, *)
extension SwiftUI.ScrollViewReader: NView {}
@available(macOS 14.0, *)
extension SwiftUI.SearchUnavailableContent.Actions: NView {}
@available(macOS 14.0, *)
extension SwiftUI.SearchUnavailableContent.Description: NView {}
@available(macOS 14.0, *)
extension SwiftUI.SearchUnavailableContent.Label: NView {}
extension SwiftUI.Section: NView {}
@available(macOS 15.0, *)
extension SwiftUI.SectionConfiguration.Actions: NView {}
extension SwiftUI.SecureField: NView {}
@available(macOS 14.0, *)
extension SwiftUI.SettingsLink: NView {}
@available(macOS 13.0, *)
extension SwiftUI.ShareLink: NView {}
extension SwiftUI.Slider: NView {}
extension SwiftUI.Spacer: NView {}
extension SwiftUI.Stepper: NView {}
@available(macOS 14.0, *)
extension SwiftUI.StrokeBorderShapeView: NView {}
@available(macOS 14.0, *)
extension SwiftUI.StrokeShapeView: NView {}
extension SwiftUI.SubscriptionView: NView {}
@available(macOS 15.0, *)
extension SwiftUI.Subview: NView {}
@available(macOS 15.0, *)
extension SwiftUI.SubviewsCollection: NView {}
@available(macOS 15.0, *)
extension SwiftUI.SubviewsCollectionSlice: NView {}
@available(macOS 15.0, *)
extension SwiftUI.TabContentBuilder.Content: NView {}
extension SwiftUI.TabView: NView {}
@available(macOS 12.0, *)
extension SwiftUI.Table: NView {}
extension SwiftUI.Text: NView {}
@available(macOS 11.0, *)
extension SwiftUI.TextEditor: NView {}
extension SwiftUI.TextField: NView {}
@available(macOS, unavailable)
extension SwiftUI.TextFieldLink: NView {}
@available(macOS 12.0, *)
extension SwiftUI.TimelineView: NView {}
extension SwiftUI.Toggle: NView {}
extension SwiftUI.ToggleStyleConfiguration.Label: NView {}
extension SwiftUI.TransformedShape: NView {}
extension SwiftUI.TupleView: NView {}
@available(macOS 13.0, *)
extension SwiftUI.UnevenRoundedRectangle: NView {}
extension SwiftUI.VSplitView: NView {}
extension SwiftUI.VStack: NView {}
@available(macOS 13.0, *)
extension SwiftUI.ViewThatFits: NView {}
@available(macOS 15.0, *)
extension SwiftUI.WindowVisibilityToggle: NView {}
extension SwiftUI.ZStack: NView {}
//@available(macOS 26.0, *)
//extension SwiftUI.ZStackContent3D: NView {}
#endif
