import QtQuick 2.0
import QtQuick.Particles 2.0
import QtGraphicalEffects 1.0
import org.gathering.ghostly 1.0

Item {
    id: startScreen

    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation {
            duration: 1500
        }
    }

    Image {
        anchors.top: parent.top
        anchors.bottom: titleText.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: height
        source: "qrc:///sprites/logo.png"
        visible: !main.effectsEnabled
        smooth: false

    }

    Loader {
        anchors.top: parent.top
        anchors.bottom: titleText.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        active: main.effectsEnabled
        sourceComponent: Component{
            Emitter {
                width: height
                enabled: startScreen.opacity > 0.5
                emitRate: 1000
                lifeSpan: startScreen.opacity == 1 ? 1000 : 500
                size: 50
                //        sizeVariation: startScreen.opacity == 1 ? 5 : 100

                shape: MaskShape {
                    source: "qrc:///sprites/logo.png"
                }

                velocity: AngleDirection{ magnitude: startScreen.opacity == 1 ? 2 : 2; magnitudeVariation: 1; angleVariation: 360}

                system: particles
                group: "Logo"
            }
        }
    }

    Text {
        id: titleText
        anchors {
            bottom: settingsList.top
            bottomMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        verticalAlignment: Text.AlignVCenter
        text: "ghostly"
        color: "white"
        font.pixelSize: 160
        antialiasing: false
        renderType: Text.NativeRendering
    }

    Rectangle {
        id: settingsList
        height: 100

        anchors {
            bottom: playerList.top
            right: playerList.right
            left: playerList.horizontalCenter
            leftMargin: 5
            bottomMargin: 10
        }

        border.width: 4
        border.color: "white"
        color: "#7f000000"

        Checkbox {
            id: humanPlayerCheckbox
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 10
            opacity: (GameManager.players.length < GameManager.maxPlayers || checked) ? 1 : 0
            enabled: GameManager.players.length < GameManager.maxPlayers || checked
            onClicked: {
                if (checked) {
                    GameManager.removeHumanPlayer()
                    checked = false
                } else {
                    if (GameManager.players.length >= GameManager.maxPlayers) return;

                    GameManager.addPlayer()
                    checked = true
                }
            }

            Text {
                anchors {
                    right: parent.left
                    rightMargin: 10
                    bottom: parent.bottom
                }
                text: "Enable human"
                color: "white"
                opacity: humanPlayerCheckbox.opacity
                antialiasing: false
                renderType: Text.NativeRendering
            }
        }

        Checkbox {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            checked: Settings.getValue(Settings.EnableEffects, true)

            function handleValue() {
                // Force kill all particles
                particles.stop()
                if (checked) {
                    particles.start()
                }
                particles.visible = checked
                main.effectsEnabled = checked
            }

            Component.onCompleted: handleValue()

            onClicked: {
                checked = !checked
                Settings.setValue(Settings.EnableEffects, checked)
                handleValue()
            }

            Text {
                anchors.right: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10
                text: "Enable effects"
                color: "white"
                antialiasing: false
                renderType: Text.NativeRendering
            }
        }

        Checkbox {
            anchors {
                bottom: parent.bottom
                bottomMargin: 10
                right: parent.right
                rightMargin: 10
            }
            checked: Settings.getValue(Settings.EnableRetro, false)

            function handleValue() {
                if (checked) {
                    retroShaderLoader.sourceComponent = retroShaderComponent
                } else {
                    retroShaderLoader.sourceComponent = undefined
                }
            }

            Component.onCompleted: handleValue()

            onClicked: {
                checked = !checked
                Settings.setValue(Settings.EnableRetro, checked)
                handleValue()
            }

            Text {
                anchors.right: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10
                text: "Go retro"
                color: "white"
                antialiasing: false
                renderType: Text.NativeRendering
            }
        }
    }

    Rectangle {
        id: speedSelect
        anchors {
            top: settingsList.top
            left: playerList.left
            right: playerList.horizontalCenter
            bottomMargin: 10
            rightMargin: 5
        }
        height: 40
        color: "#7f000000"
        border.width: 4
        border.color: "white"

        property int tickInterval: 100
        onTickIntervalChanged: GameManager.setTickInterval(tickInterval)

        Rectangle {
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width / 3
            color: speedSelect.tickInterval === 500 ? "white" : "transparent"
            Text {
                anchors.centerIn: parent
                text: "Slow"
                color: speedSelect.tickInterval === 500 ? "black" : "white"
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: MouseArea.PointingHandCursor
                onClicked: speedSelect.tickInterval = 500
            }
        }
        Rectangle {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width / 3
            color: speedSelect.tickInterval === 100 ? "white" : "transparent"
            Text {
                anchors.centerIn: parent
                text: "Med"
                color: speedSelect.tickInterval === 100 ? "black" : "white"
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: MouseArea.PointingHandCursor
                onClicked: speedSelect.tickInterval = 100
            }
        }
        Rectangle {
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width / 3
            color: speedSelect.tickInterval === 50 ? "white" : "transparent"
            Text {
                anchors.centerIn: parent
                text: "Fast"
                color: speedSelect.tickInterval === 50 ? "black" : "white"
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: MouseArea.PointingHandCursor
                onClicked: speedSelect.tickInterval = 50
            }
        }
    }

    Rectangle {
        id: playerCount
        anchors {
            bottom: playerList.top
            left: playerList.left
            right: playerList.horizontalCenter
            bottomMargin: 10
            rightMargin: 5
        }
        height: 40
        color: "#7f000000"
        border.width: 4
        border.color: "white"

        Text {
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.margins: 10
            text: "Connected: " + GameManager.players.length + "/" + GameManager.maxPlayers;
            antialiasing: false
            renderType: Text.NativeRendering
        }
    }


    // List of players
    Rectangle {
        id: playerList
        color: "#7f000000"
        anchors.centerIn: parent
        width: 640
        height: 400
        anchors.bottomMargin: 100
        border.color: "white"
        border.width: 4

        Column {
            id: userListColumn
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            Repeater {
                model: GameManager.players
                delegate: Item {
                    height: 40
                    width: userListColumn.width
                    Image {
                        source: "qrc:///sprites/players/player" + modelData.id + "-" + modelData.direction + "-" + "0" + ".png"
                        width: 30
                        height: width
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }

                        Text {
                            anchors {
                                left: parent.right
                                leftMargin: 20
                                verticalCenter: parent.verticalCenter
                            }
                            color: "white"
                            font.pixelSize: 32
                            font.family: "Perfect DOS VGA 437 Win"
                            text: modelData.name
                            antialiasing: false
                            renderType: Text.NativeRendering
                        }
                    }

                    Button {
                        visible: !modelData.isHuman()
                        anchors.right: parent.right
                        width: 60
                        height: 30
                        text: "Kick"
                        fontSize: 10
                        onClicked: GameManager.kick(index)
                    }
                }
            }
        }
    }

    // Start button
    Button {
        id: startButton
        anchors {
            top: playerList.bottom
            right: playerList.right
            left: playerList.left
            topMargin: 10
        }
        height: 60
        text: "Start game"
        active: (GameManager.players.length > 0)
        onClicked: {
            if (GameManager.players.length < 1) {
                return
            }
            GameManager.startGame()
        }
    }



    Button {
        id: quitButton
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 10
        }
        height: 50
        width: 200
        text: "Quit"
        onClicked: {
            Qt.quit()
        }
    }
}

