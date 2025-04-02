import QtQuick 2.15
import QtQml 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents

Rectangle {
    id: rectangle
    color: "transparent"

    /******
     We need to gain space to display the shadow so we reduce top and bottom margins to avoid cut elements
     in small widgets such as UserAvatar 
    *******/
    property bool smallTopMargins: false
    property bool smallBottomMargins: false
    property bool smallLeftMargins: false
    property bool smallRightMargins: false
    /******
     This is used to manage widget background color so we can change the color depending on widget status(Command Run) 
    *******/
    property alias customBgColor: cardBg.color


    property bool flat: false

    property bool noMargins: false

    property var margins: shadowContainer.margins
    default property alias content: dataContainer.data
    radius: 12

    Item {
        id: shadowContainer
        visible: !flat
        
        anchors.fill: parent
        anchors.margins: 0
        layer.enabled: true

        opacity: 0.2 // This controls the opcity of the shadow
        clip: true

        /*
        * This is the real widget where the the shadow is drawn around, we applied some margins
        * to separate it from it's parent(container) so the shadow could be displayed
        */
        Rectangle {
            id: shadowWidget
            anchors.fill: parent
            anchors.margins: 6
            color: root.themeBgColor
            radius: 12
                
        }
        DropShadow {
            anchors.fill: shadowWidget
            source: shadowWidget
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 2
            radius: 12
            samples: 25
            color: "black"
        }
    }

    Rectangle {
        id: cardBg; 
        color: root.enableTransparency ? 
                Qt.rgba(root.themeBgColor.r, root.themeBgColor.g, root.themeBgColor.b, root.transparencyLevel/100)
                : root.themeBgColor

        border.color: root.showBorders ? root.disabledBgColor : "transparent"
        anchors.centerIn: shadowContainer
        visible: !flat
        width: shadowWidget.width
        height: shadowWidget.height
        radius: 12
        z: -1
    }

    Item {
        id: dataContainer
        anchors.fill: parent
        anchors.topMargin: noMargins ? -1 : smallTopMargins ? 2 : 5
        anchors.bottomMargin: noMargins ? -1 : smallBottomMargins ? 2 : 5
        anchors.leftMargin: (noMargins || smallLeftMargins) ? -1 : 5
        anchors.rightMargin: (noMargins || smallRightMargins) ? -1 : 5
    }
}