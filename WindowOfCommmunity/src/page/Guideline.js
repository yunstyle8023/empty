import React from 'react'
import Guideline_department from '../component/Guideline_department'
import Guideline_theme from '../component/Guideline_theme'
import {
    Text,
    TextInput,
    Image,
    View,
    Button,
    StyleSheet
} from 'react-native'
import { createMaterialTopTabNavigator, createAppContainer } from 'react-navigation'

const styles = StyleSheet.create({
    guideline: {
        // marginTop: 44,
        flex: 1,
    },
    search: {
        backgroundColor: '#efefef',
        padding: 10,
        alignItems: 'center',
        justifyContent: 'center',
    },
    searchinp: {
        backgroundColor: '#ffffff',
        borderRadius: 8,
        height: 33,
        width: '100%',
        textAlign: 'center'
    }
})

const GuidelineNavigator = createMaterialTopTabNavigator({
    Department: {
        screen:Guideline_department,
        navigationOptions: () => ({
            // tabBarLabel:  <View style={styles.headbtn1}>
            //             <Text style={{color: 'red'}}>部门服务</Text>
            //         </View>,
            title: `部门服务`,
            headerBackTitle: null
        }),
    },
    Theme: {
        screen: Guideline_theme,
        navigationOptions: () => ({
            // tabBarLabel:  <View style={styles.headbtn}>
            //             <Text style={styles.headtext}>办事主题</Text>
            //         </View>,
            title: `办事主题`,
            headerBackTitle: null
        })
    }
},{
    tabBarOptions: {
        // 选项卡文字
        activeTintColor: '#333333',
        inactiveTintColor: '#333333',
        pressColor: 'green',
        // 选项卡底部的行
        indicatorStyle: {
            backgroundColor: 'red',
            height: 3,
        },
        labelStyle: {
            fontSize: 18,
        },
        // 选项卡标签栏
        tabStyle: {
            alignItems: 'center',
            // paddingBottom: 10,
        },
        // 整体的样式
        style: {
            backgroundColor: '#ffffff',
            borderBottomWidth: 1,
            borderBottomColor: '#bababa',
        },
        // activeTintColor - 活动选项卡的标签和图标颜色。
        // inactiveTintColor - 非活动选项卡的标签和图标颜色。
        // showIcon - 是否显示选项卡的图标，默认为false。
        // showLabel - 是否为标签显示标签，默认为true。
        // upperCaseLabel - 是否使标签大写，默认为true。
        // pressColor - 材质波纹的颜色（Android> =仅限5.0）。
        // pressOpacity - 按下选项卡的不透明度（仅适用于iOS和Android <5.0）。
        // scrollEnabled - 是否启用可滚动选项卡。
        // .............................................
        // tabStyle - 选项卡的样式对象。
        // labelStyle - 选项卡标签的样式对象。
        // iconStyle - 选项卡图标的样式对象。
        // style - 标签栏的样式对象。
        // allowFontScaling - 标签字体是否应缩放以符合“文本大小”辅助功能设置，默认为true。
    }
})

const GuidelineTab = createAppContainer(GuidelineNavigator)

export default class Guideline extends React.Component{
    handlepress(){
        console.log('guideline')
    }

    render(){
        return (
            <View style={styles.guideline}>
                <View style={styles.search}>
                    <TextInput placeholder="搜索" style={styles.searchinp}/>
                </View>
                <GuidelineTab navigation={this.props.navigation}/>    
            </View>
        )
    }
}

Guideline.router = GuidelineTab.router;