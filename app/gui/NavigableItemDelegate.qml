import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

ItemDelegate {
    id: control
    property GridView grid

    // OLED theme: where the glow ring sits. Defaults to the whole tile;
    // AppView points it at the box art so only the poster glows.
    property Item glowTarget: null
    property real glowRadius: 14

    highlighted: grid.activeFocus && grid.currentItem === this

    // OLED theme: no grey fill behind tiles. The selected tile gets a thin
    // accent ring with a soft halo, which reads clearly on true black.
    background: Item {
        id: glowRoot
        readonly property bool lit: control.highlighted || control.visualFocus
        readonly property real gx: control.glowTarget ? control.glowTarget.x : 0
        readonly property real gy: control.glowTarget ? control.glowTarget.y : 0
        readonly property real gw: control.glowTarget ? control.glowTarget.width : control.width
        readonly property real gh: control.glowTarget ? control.glowTarget.height : control.height

        // Soft halo: a few widening, fading rings
        Repeater {
            model: 4
            Rectangle {
                visible: glowRoot.lit
                x: glowRoot.gx - (index + 1) * 3
                y: glowRoot.gy - (index + 1) * 3
                width: glowRoot.gw + (index + 1) * 6
                height: glowRoot.gh + (index + 1) * 6
                radius: control.glowRadius + (index + 1) * 3
                color: "transparent"
                border.width: 3
                border.color: Material.accent
                opacity: 0.22 - index * 0.05
            }
        }

        // Crisp ring (hover gets a faint grey one)
        Rectangle {
            x: glowRoot.gx - 1
            y: glowRoot.gy - 1
            width: glowRoot.gw + 2
            height: glowRoot.gh + 2
            radius: control.glowRadius
            color: "transparent"
            border.width: glowRoot.lit ? 2 : 1
            border.color: glowRoot.lit ? Material.accent : "#3A3A3A"
            visible: glowRoot.lit || control.hovered
        }
    }

    Keys.onLeftPressed: {
        grid.moveCurrentIndexLeft()
    }
    Keys.onRightPressed: {
        grid.moveCurrentIndexRight()
    }
    Keys.onDownPressed: {
        grid.moveCurrentIndexDown()
    }
    Keys.onUpPressed: {
        grid.moveCurrentIndexUp()

        // If we've reached the top of the grid, move focus to the toolbar
        if (grid.currentItem === this) {
            nextItemInFocusChain(false).forceActiveFocus(Qt.TabFocus)
        }
    }
    Keys.onReturnPressed: {
        clicked()
    }
    Keys.onEnterPressed: {
        clicked()
    }
}
