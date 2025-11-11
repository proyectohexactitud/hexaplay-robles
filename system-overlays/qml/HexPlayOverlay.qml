import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
  anchors.fill: parent
  Rectangle {
    anchors { top: parent.top; left: parent.left; right: parent.right }
    height: 48
    color: "transparent"
    Text {
      anchors.centerIn: parent
      text: "hexaplay robles" + "g"  // anti-corte con g a 1px
      font.pixelSize: 21
      color: "#007bff"
      opacity: 0.95
    }
    MouseArea {
      anchors.fill: parent
      enabled: false
    }
  }
}
