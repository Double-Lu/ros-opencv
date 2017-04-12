import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtPositioning 5.6
import QtLocation 5.6
import "mapviewer"

// import "mapviewer:/*"


GroundSystemLayout {
    id:rootLayout
    myVar: "hello command var"

//    Plugin {
//        id: osmPlugin
//        name: "osm"
//    }



    Dialog {
        id: cancelMissionDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: parent.width / 2
        height: parent.height/ 2
        parent: ApplicationWindow.overlay

        focus: true
        modal: true
        title: "Confirm Cancel Mission"
        standardButtons: Dialog.Ok

        contentItem: Rectangle {
            color: "#303030"
            implicitWidth: parent.width / 2
            implicitHeight: parent.height/ 2


            Label {
                id:selectColorLabel
                text: qsTr("Are you sure you want to cancel the current mission?")
                color: "white"
                font.pixelSize: 18
                font.bold: true
                anchors.centerIn: parent
            }

        }

    }


    Dialog {
        id: allWaypointsDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: parent.width / 2
        height: parent.height/ 2
        parent: ApplicationWindow.overlay

        focus: true
        modal: true
        title: "All Waypoints"
        standardButtons: Dialog.Ok | Dialog.Cancel

        contentItem: Rectangle {
            color: "#303030"
            implicitWidth: parent.width / 2
            implicitHeight: parent.height/ 2


            Label {
                id:waypointsTitleLabel
                text: qsTr("All Existing Waypoints")
                color: "white"
                font.pixelSize: 18
                font.bold: true
                anchors.centerIn: parent
            }

        }

    }


    Dialog {
        id: commandHelpDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: parent.width / 2
        height: parent.height/ 2
        parent: ApplicationWindow.overlay

        focus: true
        modal: true
        title: "Help"
        standardButtons: Dialog.Ok | Dialog.Cancel

        contentItem: Rectangle {
            color: "#303030"
            implicitWidth: parent.width / 2
            implicitHeight: parent.height/ 2


            Label {
                id:commandHelpDialogLabel
                text: qsTr("Command Help")
                color: "white"
                font.pixelSize: 18
                font.bold: true
                anchors.centerIn: parent
            }

        }

    }

    Dialog {
        id: immediateMoveDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: parent.width / 2
        height: parent.height/ 2
        parent: ApplicationWindow.overlay

        focus: true
        modal: true
        title: "Immediate Goal"
        standardButtons: Dialog.Ok | Dialog.Cancel

        contentItem: Rectangle {
            id: immediateMoveDialogRootRect
            color: "#303030"
            implicitWidth: parent.width / 2
            implicitHeight: parent.height/ 2

            RowLayout {
                anchors.fill: parent

                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.333
                    color: immediateMoveDialogRootRect.color
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.333
                    //color: immediateMoveDialogRootRect.color
                    color: "transparent"



                    ColumnLayout {
                        anchors.fill: parent



                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.height * 0.25
                            color: "transparent"

                            Label {
                                id:immediateMoveDialogLabel
                                text: qsTr("Set Immediate Goal")
                                color: "white"
                                font.pixelSize: 18
                                font.bold: true
                                anchors.centerIn: parent
                            }
                        }

                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.height * 0.25
                            color: "transparent"
                            TextField {
                                placeholderText: qsTr("latitude")
                            }
                        }

                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.height * 0.25
                            color: "transparent"
                            TextField {
                                placeholderText: qsTr("longitude")
                            }
                        }


                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.height * 0.25
                            color: "transparent"
                            TextField {
                                placeholderText: qsTr("altitude")
                            }
                        }


                    }


                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.333
                    //color: immediateMoveDialogRootRect.color
                    color: "transparent"
                }

            }



        }

    }

    RowLayout {
        anchors.fill: parent

        Rectangle {
            id: leftCol
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.1
            color: rootLayout.colors["dark"]


            ColumnLayout {
                anchors.fill: parent

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: leftCol.color

                    Rectangle {
                        width: parent.width
                        height: parent.width
                        anchors.margins: 30
                        anchors.centerIn: parent
                        color: rootLayout.colors["xlight"]
                        radius: 20
                        border.color: rootLayout.colors["dark"]
                        border.width: 5

                        Image {
                            id: targetIcon
                            source: "png/earth-globe.png"
                            anchors.centerIn: parent
                            height: parent.height * 0.7
                            width: parent.height * 0.7
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                allWaypointsDialog.open();
                            }
                        }
                    }



                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: leftCol.color

                    Rectangle {
                        width: parent.width
                        height: parent.width
                        anchors.margins: 30
                        anchors.centerIn: parent
                        //color: rootLayout.colors["xlight"]
                        color: parent.color
                        radius: 20
                        border.color: rootLayout.colors["dark"]
                        border.width: 5



                        Slider {
                            id: slider
                            value: 0.5
                            anchors.centerIn: parent
                            orientation: Qt.Vertical
                        }
//                        Image {
//                            id: listIcon
//                            source: "png/small-rocket-ship-silhouette.png"
//                            anchors.centerIn: parent
//                            height: parent.height * 0.7
//                            width: parent.height * 0.7
//                        }
                    }

                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: leftCol.color



                    Rectangle {
                        width: parent.width
                        height: parent.width
                        anchors.margins: 30
                        anchors.centerIn: parent
                        color: rootLayout.colors["xlight"]
                        radius: 20
                        border.color: rootLayout.colors["dark"]
                        border.width: 5


                        Image {
                            id: cancelIcon
                            source: "png/remove-button.png"
                            anchors.centerIn: parent
                            height: parent.height * 0.7
                            width: parent.height * 0.7
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                cancelMissionDialog.open();
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.8
            //color: rootLayout.colors["red"]
            color: "yellow"

            MapViewer {
                anchors.fill: parent
            }

        }

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.1
            color: rootLayout.colors["dark"]
            id: rightCol


            ColumnLayout {
                anchors.fill: parent

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: rightCol.color

                    Rectangle {
                        id: pushPinRect
                        width: parent.width
                        height: parent.width
                        anchors.margins: 30
                        anchors.centerIn: parent
                        property bool clicked: false
                        color: clicked ? rootLayout.colors["light"] : rootLayout.colors["xlight"];
                        radius: 20
                        border.color: rootLayout.colors["dark"]
                        border.width: 5

                        Image {
                            id: waypointIcon
                            source: "png/paper-push-pin.png"
                            anchors.centerIn: parent
                            height: parent.height * 0.7
                            width: parent.height * 0.7
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                pushPinRect.clicked = !pushPinRect.clicked;
                            }
                        }
                    }



                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: leftCol.color

                    Rectangle {
                        width: parent.width
                        height: parent.width
                        anchors.margins: 30
                        anchors.centerIn: parent
                        color: rootLayout.colors["xlight"]
                        radius: 20
                        border.color: rootLayout.colors["dark"]
                        border.width: 5


                        Image {
                            id: customGoalIcon
                            source: "png/move-option.png"
                            anchors.centerIn: parent
                            height: parent.height * 0.7
                            width: parent.height * 0.7
                        }


                        MouseArea {
                            anchors.fill: parent
                            onClicked: immediateMoveDialog.open()
                        }
                    }

                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.333
                    color: leftCol.color



                    Rectangle {
                        width: parent.width
                        height: parent.width
                        anchors.margins: 30
                        anchors.centerIn: parent
                        color: rootLayout.colors["xlight"]
                        radius: 20
                        border.color: rootLayout.colors["dark"]
                        border.width: 5


                        Image {
                            id: helpIcon
                            source: "png/question-sign.png"
                            anchors.centerIn: parent
                            height: parent.height * 0.7
                            width: parent.height * 0.7
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                commandHelpDialog.open();
                            }
                        }
                    }

                }

            }


        }

    }
}
