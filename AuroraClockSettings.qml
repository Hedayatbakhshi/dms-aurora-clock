import QtQuick
import qs.Common
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "auroraClock"

    SliderSetting {
        settingKey: "backgroundOpacity"
        label: "Background Opacity"
        description: "Rounded background behind the clock. Set to 0 for fully transparent."
        defaultValue: 0
        minimum: 0
        maximum: 100
        unit: "%"
    }

    ToggleSetting {
        settingKey: "showSeconds"
        label: "Show Seconds"
        description: "Display the seconds column next to the time."
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "showDate"
        label: "Show Day & Month"
        description: "Display the weekday and month under the seconds."
        defaultValue: true
    }

    SelectionSetting {
        id: fontFamilySetting
        settingKey: "fontFamily"
        label: "Font Family"
        description: "Pick from your installed fonts. Select System Default to use the theme font."
        options: {
            var opts = [{ label: "System Default", value: "" }];
            var families = Qt.fontFamilies();
            for (var i = 0; i < families.length; i++) {
                if (families[i].charAt(0) === ".")
                    continue;
                opts.push({ label: families[i], value: families[i] });
            }
            return opts;
        }
        defaultValue: ""
    }

    ToggleSetting {
        settingKey: "force24Hour"
        label: "Force 24-Hour Clock"
        description: "Override the system clock format and always use 24-hour time."
        defaultValue: false
    }
}
