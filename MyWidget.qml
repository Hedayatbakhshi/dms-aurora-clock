import QtQuick
import QtQuick.Layouts
import qs.Common
import qs.Modules.Plugins

DesktopPluginComponent {
    id: root

    minWidth: 360
    minHeight: 130
    widgetWidth: 520
    widgetHeight: 220

    property string timeZoneLabel: "LOCAL TIME"
    property string hourMinute: "00:00"
    property string seconds: "00"
    property string amPm: ""
    property string dayName: ""
    property string monthName: ""

    readonly property real bgOpacity: (pluginData?.backgroundOpacity ?? 0) / 100
    readonly property bool showSeconds: pluginData?.showSeconds ?? true
    readonly property bool showDate: pluginData?.showDate ?? true
    readonly property string fontFamilySetting: pluginData?.fontFamily ?? ""

    function refresh() {
        const now = new Date();

        const force24 = pluginData?.force24Hour === true;
        const use24 = force24 ? true : (typeof SettingsData !== "undefined" ? SettingsData.use24HourClock : true);
        let h = now.getHours();
        amPm = "";
        if (!use24) {
            amPm = h >= 12 ? "PM" : "AM";
            h = h % 12;
            if (h === 0)
                h = 12;
        }
        const m = now.getMinutes();
        hourMinute = h + ":" + (m < 10 ? "0" : "") + m;
        const s = now.getSeconds();
        seconds = (s < 10 ? "0" : "") + s;
        dayName = Qt.formatDateTime(now, "dddd");
        monthName = Qt.formatDateTime(now, "MMMM");
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()

    Rectangle {
        anchors.fill: parent
        radius: Theme.cornerRadius
        color: Theme.withAlpha(Theme.surfaceContainer, root.bgOpacity)
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Math.max(18, width * 0.035)
        anchors.rightMargin: Math.max(18, width * 0.035)
        spacing: Math.max(16, width * 0.035)

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.max(16, root.height * 0.16)
                text: root.timeZoneLabel + (root.amPm !== "" ? "  ·  " + root.amPm : "")
                font.family: root.fontFamilySetting !== "" ? root.fontFamilySetting : Theme.fontFamily
                font.pixelSize: Math.max(10, root.height * 0.075)
                font.weight: Font.DemiBold
                font.letterSpacing: 3
                color: Theme.surfaceText
                opacity: 0.88
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: root.hourMinute
                font.family: root.fontFamilySetting !== "" ? root.fontFamilySetting : Theme.fontFamily
                font.pixelSize: root.height * 0.72
                fontSizeMode: Text.Fit
                minimumPixelSize: 36
                font.weight: Font.Black
                color: Theme.primary
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        ColumnLayout {
            Layout.preferredWidth: Math.max(76, root.width * 0.17)
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 0
            visible: root.showSeconds || root.showDate

            Text {
                Layout.fillWidth: true
                text: root.seconds
                visible: root.showSeconds
                font.family: root.fontFamilySetting !== "" ? root.fontFamilySetting : Theme.fontFamily
                font.pixelSize: root.height * 0.34
                fontSizeMode: Text.Fit
                minimumPixelSize: 22
                font.weight: Font.Black
                color: Theme.surfaceText
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
            }

            Text {
                Layout.fillWidth: true
                text: root.dayName
                visible: root.showDate
                font.family: root.fontFamilySetting !== "" ? root.fontFamilySetting : Theme.fontFamily
                font.pixelSize: Math.max(11, root.height * 0.085)
                font.weight: Font.DemiBold
                color: Theme.surfaceText
                horizontalAlignment: Text.AlignLeft
            }

            Text {
                Layout.fillWidth: true
                text: root.monthName
                visible: root.showDate
                font.family: root.fontFamilySetting !== "" ? root.fontFamilySetting : Theme.fontFamily
                font.pixelSize: Math.max(11, root.height * 0.085)
                font.weight: Font.DemiBold
                color: Theme.surfaceText
                horizontalAlignment: Text.AlignLeft
            }
        }
    }
}
