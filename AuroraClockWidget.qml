import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

DesktopPluginComponent {
    id: root

    minWidth: 360
    minHeight: 130
    widgetWidth: 520
    widgetHeight: 220

    readonly property real bgOpacity: (pluginData?.backgroundOpacity ?? 0) / 100
    readonly property bool showSeconds: pluginData?.showSeconds ?? true
    readonly property bool showDate: pluginData?.showDate ?? true
    readonly property bool force24Hour: pluginData?.force24Hour === true
    readonly property string fontFamilySetting: pluginData?.fontFamily ?? ""

    readonly property bool use24Hour: force24Hour || (typeof SettingsData !== "undefined" && SettingsData.use24HourClock === true)
    readonly property string resolvedFontFamily: fontFamilySetting !== "" ? fontFamilySetting : Theme.fontFamily
    readonly property string timePattern: use24Hour ? "HH:mm" : "h:mm AP"

    readonly property var now: systemClock.date ?? new Date()
    readonly property string timeText: now.toLocaleTimeString(I18n.locale(), timePattern)
    readonly property string dayText: now.toLocaleDateString(I18n.locale(), "dddd")
    readonly property string monthText: now.toLocaleDateString(I18n.locale(), "MMMM")

    readonly property real contentMargin: Theme.spacingL
    readonly property real labelFontSize: Theme.fontSizeSmall
    readonly property real detailFontSize: Theme.fontSizeSmall

    SystemClock {
        id: systemClock
        precision: root.showSeconds ? SystemClock.Seconds : SystemClock.Minutes
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.cornerRadius
        color: Theme.withAlpha(Theme.surfaceContainer, root.bgOpacity)
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: root.contentMargin
        anchors.rightMargin: root.contentMargin
        spacing: Theme.spacingL

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            StyledText {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.fontSizeLarge
                text: "LOCAL TIME"
                font.family: root.resolvedFontFamily
                font.pixelSize: root.labelFontSize
                font.weight: Font.DemiBold
                font.letterSpacing: 2
                color: Theme.surfaceVariantText
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
            }

            StyledText {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: root.timeText
                font.family: root.resolvedFontFamily
                font.pixelSize: root.height * 0.72
                fontSizeMode: Text.Fit
                minimumPixelSize: Theme.fontSizeLarge * 2
                font.weight: Font.Bold
                color: Theme.primary
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
            }
        }

        ColumnLayout {
            Layout.preferredWidth: Math.max(root.detailFontSize * 8, root.width * 0.17)
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: Theme.spacingXXS
            visible: root.showSeconds || root.showDate

            StyledText {
                Layout.fillWidth: true
                text: root.showSeconds ? root.now.toLocaleTimeString(I18n.locale(), "ss") : ""
                font.family: root.resolvedFontFamily
                font.pixelSize: root.height * 0.3
                fontSizeMode: Text.Fit
                minimumPixelSize: Theme.fontSizeLarge
                font.weight: Font.Bold
                color: Theme.surfaceText
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
            }

            StyledText {
                Layout.fillWidth: true
                text: root.dayText
                visible: root.showDate
                font.family: root.resolvedFontFamily
                font.pixelSize: root.detailFontSize
                font.weight: Font.DemiBold
                color: Theme.surfaceVariantText
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
            }

            StyledText {
                Layout.fillWidth: true
                text: root.monthText
                visible: root.showDate
                font.family: root.resolvedFontFamily
                font.pixelSize: root.detailFontSize
                font.weight: Font.DemiBold
                color: Theme.surfaceVariantText
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
            }
        }
    }
}