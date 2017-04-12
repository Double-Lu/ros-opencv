import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Extras 1.4
import QtCharts 2.0
import QtQuick.Templates 2.0

GroundSystemLayout {
    id:rootLayout
    myVar: "hello sensor var"

    Rectangle {
        anchors.fill: parent
        color: rootLayout.colors["light"]

        ColumnLayout {
            anchors.fill: parent

            Rectangle {
                id: leftColRect
                Layout.fillWidth: true
                Layout.preferredHeight:parent.height * 0.5
                color: rootLayout.colors["light"]

                ColumnLayout {
                    anchors.fill: parent

                    Rectangle {
                        id: sensorSectionLabelRect
                        Layout.fillWidth: true
                        Layout.preferredHeight: sensorRectLabel.implicitHeight
                        color: rootLayout.colors["dark"]

                        Label {
                            text: "ACTIVE SENSORS"
                            id: sensorRectLabel
                            anchors.margins: 10
                            color: rootLayout.colors["light"]
                            anchors.centerIn: parent
                            font.pixelSize: 30
                            font.bold: true
                            font.family: "Nimbus Mono L"
                        }


                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height - sensorSectionLabelRect.height



                        Flickable {
                            width:parent.width * 2
                            height: parent.height
                            flickableDirection: Flickable.HorizontalFlick
                            contentWidth: flickRect.width

                            Rectangle {
                                id: flickRect
                                width: sensorLayout.implicitWidth
                                height: parent.height
                                color: rootLayout.colors["neutral"]

                                RowLayout{
                                    id: sensorLayout
                                    height: parent.height

                                    SensorGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                    }
                                    SensorVerticalGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                        gaugeBarColor: "#18FFFF"
                                    }

                                    SensorGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                    }

                                    SensorVerticalGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                        gaugeBarColor: "#D50000"
                                    }

                                    SensorGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                    }

                                    SensorVerticalGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                        gaugeBarColor: "#FFA000"
                                    }

                                    SensorGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                    }

                                    SensorVerticalGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                        gaugeBarColor: "#18FFFF"
                                    }

                                    SensorGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Temperature")
                                        masterColors: rootLayout.colors
                                    }
                                }
                            }
                        }

                    }

                }


            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight:parent.height * 0.5
                color: rootLayout.colors["light"]




                ColumnLayout {
                    anchors.fill: parent

                    Rectangle {
                        id: healthSectionLabelRect
                        Layout.fillWidth: true
                        Layout.preferredHeight: healthRectLabel.implicitHeight
                        color: rootLayout.colors["dark"]

                        Label {
                            text: "MACHINE HEALTH"
                            id: healthRectLabel
                            anchors.margins: 10
                            color: rootLayout.colors["light"]
                            anchors.centerIn: parent
                            font.pixelSize: 30
                            font.bold: true
                            font.family: "Nimbus Mono L"
                        }


                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height - healthSectionLabelRect.height
                        color: rootLayout.colors["neutral"]




                        Flickable {
                            width: parent.width
                            height: parent.height
                            flickableDirection: Flickable.HorizontalFlick

                            Rectangle {
                                width: sensorGraphLayout.implicitWidth
                                height: parent.height
                                color: rootLayout.colors["neutral"]

                                RowLayout{
                                    id: sensorGraphLayout
                                    height: parent.height

                                    SensorGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Fuel")
                                        masterColors: rootLayout.colors
                                    }

                                    SensorGaugeView {
                                        rectColor: rootLayout.colors["light"]
                                        sensorName: qsTr("Battery")
                                        masterColors: rootLayout.colors
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
