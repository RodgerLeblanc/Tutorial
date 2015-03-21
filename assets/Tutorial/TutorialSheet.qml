import bb.cascades 1.2

Sheet {
    id: tutorialSheet
    onOpened: {
        listView.scrollToItem([0], ScrollAnimation.Smooth)
    }
    
    Page {
        id: tutorialPage
        titleBar: TitleBar {
            id: titleBar
            title: qsTr("Tutorial")
            acceptAction: ActionItem {
                title: tutorialPage.pageShown == 5 ? qsTr("Done") : qsTr("Next")
                onTriggered: {
                    if (tutorialPage.pageShown == 5) {
//                        if (_settings.value("showFirstTimeTutorial", true))
//                            _settings.setValue("showFirstTimeTutorial", false)
                            
                        tutorialSheet.close()
                    }
                    else 
                        listView.scrollToItem([tutorialPage.pageShown + 1], ScrollAnimation.Smooth)
                }
            }
            dismissAction: ActionItem {
                title: qsTr("Dismiss")
                onTriggered: {
                    tutorialSheet.close()
                }
            }
        }
                
        property int pageShown
        
        Container {
            id: tutorialContainer
            layout: DockLayout {}
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            background: Color.Magenta
            ListView {
                id: listView
                
                property int deviceWidth: mainPage.deviceWidth
                property int deviceHeight: mainPage.deviceHeight 
                property variant background: tutorialContainer.background
                
                dataModel: XmlDataModel { source: "asset:///Tutorial/tutorialModel.xml" }
                layout: StackListLayout { orientation: LayoutOrientation.LeftToRight }
                flickMode: FlickMode.SingleItem
                
                function updatePageShown(page) {
                    tutorialPage.pageShown = page
                }
                
                listItemComponents: [
                    ListItemComponent {
                        type: "item"
                        Container {
                            id: itemContainer
                            layout: DockLayout {}
                            preferredWidth: itemContainer.ListItem.view.deviceWidth
                            preferredHeight: itemContainer.ListItem.view.deviceHeight
                            attachedObjects: LayoutUpdateHandler {
                                id: luhPosition
                                onLayoutFrameChanged: {
                                    if (luhPosition.layoutFrame.x >= - itemContainer.preferredWidth / 2 && luhPosition.layoutFrame.x <= itemContainer.preferredWidth / 2) {
                                        itemContainer.ListItem.view.updatePageShown(ListItemData.page)
                                    } 
                                }
                            }
                            Container {
                                layout: DockLayout {}
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Fill
                                ImageView {
                                    imageSource: ListItemData.image
                                    horizontalAlignment: HorizontalAlignment.Center
                                    verticalAlignment: VerticalAlignment.Center
                                    maxHeight: itemContainer.ListItem.view.deviceHeight * 0.7
                                    maxWidth: itemContainer.ListItem.view.deviceWidth * 0.7
                                    scalingMethod: ScalingMethod.AspectFit
                                }
                                Container {
                                    horizontalAlignment: HorizontalAlignment.Fill
                                    verticalAlignment: VerticalAlignment.Top
                                    opacity: 0.8
                                    background: itemContainer.ListItem.view.background
                                    Label {
                                        text: ListItemData.description
                                        multiline: true
                                        horizontalAlignment: HorizontalAlignment.Center
                                    }
                                }
                            }
                        }
                    }
                ]    
            }
        }
    }
}
