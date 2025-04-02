import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.bluezqt as BluezQt

import "../lib" as Lib
import "../js/funcs.js" as Funcs


Lib.CardButton {

    // BLUETOOTH
    property QtObject btManager : BluezQt.Manager

    visible: true

    Layout.fillWidth: true
    Layout.fillHeight: true
    
    title: Funcs.getBtDevice() // i18n("Bluetooth")
    Lib.Icon {
        anchors.fill: parent
        source: {
            if (BluezQt.Manager.connectedDevices.length > 0) {
                return "network-bluetooth-activated-symbolic";
            }
            if (!BluezQt.Manager.bluetoothOperational) {
                return "network-bluetooth-inactive-symbolic";
            }
            return "network-bluetooth-symbolic";
        }
        selected:  Funcs.getBtDevice() != "Disabled"
    }
    onClicked: {
       fullRep.togglePage(fullRep.defaultInitialWidth, 400, bluetoothPage);
    }
}