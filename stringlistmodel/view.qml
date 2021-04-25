/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick.Controls 2.0
import QtQuick 2.0
//![0]
Item {
    width: 1500
    height: 800
    property var modelFilter: myModel
    property var modelvalue: myModel.slice(0,4)
    property int numberOfFilter: myModel.length
    property int indexModel: 0
    signal completedText()
    signal coverSignal()
    Rectangle {
        width: 1500
        height: 120
        border.color: "red"
    }
    ListView {
        property real lengthOfFilter: 0
        property var filterArray: []
        id : listview
        property int chooseIndex: 0
        property int prevIndex: 0
        x : numberOfFilter > 4 ? 100 : 0
        width: numberOfFilter > 4 ? 1300 : 1500
        height: 120
        orientation : ListView.Horizontal
        interactive: false
        model: (visible)? modelvalue : ""
        onModelChanged : {
            console.log("changed", currentIndex)
            currentIndex = -1
        }
        currentIndex : -1
        delegate: Text {
            id: infoText
            font.pixelSize: 12
            wrapMode: Text.Wrap
            text: modelData
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.Text.AlignHCenter
            property int indexChoose: index + indexModel
            property bool isSelected: indexChoose === listview.chooseIndex
            MouseArea {
                id: chooseText
                anchors.fill: parent
                onClicked: {
                    console.log("Choose",index,listview.chooseIndex)
                    listview.chooseIndex = indexChoose
                }
            }
            Rectangle {
                id : coverBoder
                height: infoText.lineCount > 1 ? 30 : 20
                anchors.left: parent.left
                anchors.leftMargin: infoText.lineCount > 1 ? -20 : -15
                width: infoText.lineCount > 1 ? infoText.contentWidth+40 : infoText.contentWidth+30
                radius: 10
                border.color: "red"
                visible: isSelected
            }

            Component.onCompleted: {
                console.log(("Content length %1").arg(infoText.contentWidth))
                console.log(("width %1").arg(infoText.width))
                listview.lengthOfFilter += infoText.contentWidth
                console.log(("lengthOfFilter %1").arg(listview.lengthOfFilter))
                listview.filterArray[index] = infoText.contentWidth
                console.log(listview.filterArray)
                console.log(infoText.lineCount)
                console.log(index)
                if (index === listview.count-1) {
                    console.log("qeruanfa")
                    completedText()
                }
            }
        }
    }
    onCompletedText: {
        console.log("onClicked")
        var spacing = 0;
        var max = 0;
        var indexofmax = 0;
        if (numberOfFilter > 4) {
            spacing = (1300 - listview.lengthOfFilter - 30)/(3)
            console.log("space 1 ",spacing)
            while(spacing < 90) {
                max = Math.max.apply(Math, listview.filterArray);
                indexofmax = listview.filterArray.indexOf(max)
                listview.contentItem.children[indexofmax].width = max/2
                listview.filterArray[indexofmax] = listview.contentItem.children[indexofmax].contentWidth
                listview.lengthOfFilter = listview.filterArray.reduce(function(a,b){return(a+b)},0)
                console.log(listview.contentItem.children[0].lineCount)
                console.log(listview.contentItem.children[3].lineCount)
                if ((listview.contentItem.children[0].lineCount > 1)&&(listview.contentItem.children[3].lineCount > 1)) {
                    spacing = (1300 - listview.lengthOfFilter - 40)/(3)
                } else if ((listview.contentItem.children[0].lineCount > 1)||(listview.contentItem.children[3].lineCount > 1)){
                    spacing = (1300 - listview.lengthOfFilter - 35)/(3)
                } else {
                    spacing = (1300 - listview.lengthOfFilter - 30)/(3)
                }
                console.log(spacing)
            }
            if (listview.contentItem.children[0].lineCount > 1) {
                listview.x = 100 + 20
            } else {
                listview.x = 100 + 15
            }
            for (var i = 1; i < 4;i++) {
                listview.contentItem.children[i].anchors.leftMargin = listview.contentItem.children[i-1].anchors.leftMargin + listview.contentItem.children[i-1].contentWidth + spacing
            }
        }
        if ((numberOfFilter > 2)&&(numberOfFilter <= 4)) {
            spacing = (1500 - listview.lengthOfFilter - 30)/(listview.count-1)
            console.log("space 2 ",spacing)
            console.log("fa",listview.contentItem.children[2].text)
            while(spacing < 90) {
                max = Math.max.apply(Math, listview.filterArray);
                indexofmax = listview.filterArray.indexOf(max)
                console.log("max",max,indexofmax)
                listview.contentItem.children[indexofmax].width = max/2
                listview.filterArray[indexofmax] = listview.contentItem.children[indexofmax].contentWidth
                console.log(listview.filterArray)
                listview.lengthOfFilter = listview.filterArray.reduce(function(a,b){return(a+b)},0)
                console.log(listview.contentItem.children[0].lineCount)
                console.log("r",listview.contentItem.children[1].lineCount)
                if ((listview.contentItem.children[0].lineCount > 1)&&(listview.contentItem.children[listview.count-1].lineCount > 1)) {
                    spacing = (1500 - listview.lengthOfFilter - 40)/(listview.count-1)
                } else if ((listview.contentItem.children[0].lineCount > 1)||(listview.contentItem.children[listview.count-1].lineCount > 1)){
                    spacing = (1500 - listview.lengthOfFilter - 35)/(listview.count-1)
                } else {
                    spacing = (1500 - listview.lengthOfFilter - 30)/(listview.count-1)
                }
                console.log(spacing)
            }
            if (listview.contentItem.children[0].lineCount > 1) {
                listview.x = 20
            } else {
                listview.x = 15
            }
            console.log("rrr",listview.filterArray)
            for (i = 1;i<listview.count;i++) {
                listview.contentItem.children[i].anchors.leftMargin = listview.contentItem.children[i-1].anchors.leftMargin + listview.contentItem.children[i-1].contentWidth + spacing
                console.log(listview.contentItem.children[i].anchors.leftMargin)
            }
        }
        if (numberOfFilter <= 2) {
            var range = 15
            spacing = (1500 - listview.lengthOfFilter - 380)/2
            while(spacing < range) {
                max = Math.max.apply(Math, listview.filterArray);
                indexofmax = listview.filterArray.indexOf(max)
                listview.contentItem.children[indexofmax].width = max/2
                listview.filterArray[indexofmax] = listview.contentItem.children[indexofmax].contentWidth
                listview.lengthOfFilter = listview.filterArray.reduce(function(a,b){return(a+b)},0)
                spacing = (1500 - listview.lengthOfFilter - 380)/2
                range =  listview.contentItem.children[0].lineCount > 1 ? 20 : 15
            }
            listview.x = spacing
            listview.contentItem.children[1].anchors.leftMargin = listview.contentItem.children[0].contentWidth + 380
        }
    }

    Button {
        id: previousBut
        visible: numberOfFilter > 4
        x : 0
        width : 100
        height: 120
        onClicked: {
            if (indexModel > 0) {
                listview.lengthOfFilter = 0
                listview.filterArray = []
                modelvalue = myModel.slice(indexModel-1,indexModel+3)
                indexModel--
            }
        }
    }

    Button {
        id : nextBut
        visible: numberOfFilter > 4
        x : 1400
        width : 100
        height: 120
        onClicked: {
            if (indexModel < numberOfFilter-4) {
                listview.lengthOfFilter = 0
                listview.filterArray = []
                modelvalue = myModel.slice(indexModel+1,indexModel+5)
                indexModel++
            }
        }
    }

    Component.onCompleted: {
        console.log(("%1").arg("quan"))
    }
}
//![0]
