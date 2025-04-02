import QtQuick 2.15
import QtQuick.Layouts 1.15
//import QtGraphicalEffects 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import Qt5Compat.GraphicalEffects


Item
{
    property alias sourceColor:rect.color
    property alias source: icon.source
    property alias selected: icon.selected

    property color highlightColor: root.useSystemColorsOnToggles ? root.themeHighlightColor : root.toggleButtonsColor

    Rectangle {
        id: rect
        radius: width/2
        color: icon.selected ? highlightColor : root.disabledBgColor
        anchors.fill: parent
        

        Kirigami.Icon {
            id: icon
            visible: true
            anchors.fill: parent
            anchors.margins: root.smallSpacing
            anchors.centerIn: parent
            selected: false
            isMask: true
            color: selected ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
        }
    }
}
