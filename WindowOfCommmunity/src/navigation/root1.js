import React from 'react'
import {
    StyleSheet,
    View,
    Text,
    Image,
    Button,
    TouchableOpacity
} from 'react-native'
import {
    createBottomTabNavigator,
    createAppContainer,
    createStackNavigator,
    createMaterialTopTabNavigator
} from 'react-navigation'

import FirstPage from '../page/FirstPage'
import Guideline from '../page/Guideline'
import Life from '../page/Life'
import Tool from '../page/Tool'
import GuidelineNext from '../page/GuidelineNext'
import Addtheme from '../page/Addtheme'
import TodoDetail from '../page/TodoDetail'
import DetailCondition from '../page/DetailInfor'
import DetailInfor from '../page/DetailMaterial'
import DetailMaterial from '../page/DetailMaterial'
import LifeMap from '../page/LifeMap'
import LifeDetail from '../page/LifeDetail'
import LifeDetailTransfer from '../page/LifeDetailTransfer'
import LifeList from '../page/LifeList'

const styles = StyleSheet.create({
    StytabBarIconStyle: {
        width: 30,
        height: 30,
    },
})

let show = true;

// 页面上方的首页（对应底下第一个）、以及点击首页的Body组件后所跳转到的Addtheme页面
const FirstpageStack = createStackNavigator({
    FirstPage: {
        screen: FirstPage,
        navigationOptions:  ({navigation}) => ({
            header: null,
        }),
    },
    Addtheme: {
        screen: Addtheme,
        navigationOptions:  ({navigation}) => {
            show = false;
            return ({
            title:  `添加办事主题`,
            headerLeft:  
            <TouchableOpacity onPress={()=>{
                show = true;
                navigation.pop();
                }} style={{marginLeft: 20}}>
                <Image source={require('../img/gb.png')}/>
            </TouchableOpacity>,
            // headerRight: <Button title="完成" onPress={()=> navigation.goBack()}/>,
            headerStyle: {
                backgroundColor: '#e5322e',
                color: '#ffffff'
            }
        })},
    }
}, {
    initialRouteName: 'FirstPage',
})

// 写GuidelineNext的下一个页面TodoDetail详情
// STACK的嵌套会使得页面变得有两层的返回按钮
// const GuidelineNextStack = createStackNavigator({
//     GuidelineNext: {
//         screen: GuidelineNext
//     },
//     TodoDetail: {
//         screen: TodoDetail
//     }
// }, {
//     initialRouteName: 'GuidelineNext'
// })

// TodoDetail页面上方有三个选项卡进行切换
const TodoDetailStack = createMaterialTopTabNavigator({
    DetailInfor: {
        screen: DetailInfor,
        navigationOptions: ({navigation}) => ({
            // title: `基本信息`,
            tabBarLabel: "基本信息"
        }),
    },
    DetailCondition: {
        screen: DetailCondition,
        navigationOptions: () => ({
            title: `申报材料`
        })
    },
    DetailMaterial: {
        screen: DetailMaterial,
        navigationOptions: () => ({
            title: `受理条件`
        })
    }
}, {
    innitialRouteName: 'DetailInfor',
    tabBarOptions: {
        activeTintColor: '#333333',
        // 标签栏
        style: {
            backgroundColor: '#ffffff',
        },
        // 选项卡底部的行
        indicatorStyle: {
            backgroundColor: 'red'
        },
        // 选项卡标签
        labelStyle: {
            fontSize: 16,
            color: '#333333',
        }
    }
})

const  TodoDetailTab = createAppContainer(TodoDetailStack)

// 页面上方的办事指南（对应底下第二个）、以及点击办事指南之后的下一个页面
const GuidelineStack = createStackNavigator({
    Guideline: {
        screen: Guideline,
        navigationOptions:  ({navigation}) => ({
                                title: `办事指南`,
                                headerTitleStyle: {color: '#ffffff'},
                                headerStyle: {
                                    backgroundColor: '#e5322e'
                                }
                            }),
            
    },
    GuidelineNext: {
        screen: GuidelineNext,
        navigationOptions:  ({navigation}) => ({   
                                title: typeof navigation.state.params.themeindex === 'number'?`${navigation.state.params.themeindex}办事指南（主题）`:`${navigation.state.params.departindex}办事指南（部门）`,
                                headerTitleStyle: {color: '#ffffff'},
                                headerStyle: {
                                    backgroundColor: '#e5322e'
                                }
                            })

    },
    TodoDetail: {
        screen: TodoDetailTab,
        navigationOptions: ({navigation})=>({
            title: '详情',
            headerTitleStyle: {color: '#ffffff', fontSize: 18},
            headerLeft: <Text></Text>,
            headerRight: <TouchableOpacity onPress={()=> navigation.pop()} >
                            <Image source={require('../img/sc.png')} style={{marginRight: 20}}/>
                         </TouchableOpacity>,
            headerLeft:  <TouchableOpacity onPress={()=> navigation.pop()} style={{marginLeft: 20}}>
                            <Image source={require('../img/back.png')}/>
                        </TouchableOpacity>,
            headerStyle: {
                backgroundColor: '#e5322e'
            }
        })
    }
}, {
    initialRouteName: 'Guideline',
})


// 页面上方的生活指南（对应底下第三个）
const LifeStack = createStackNavigator({
    Life: {
        screen: Life,
        navigationOptions:  ({navigation}) => ({
                                title: `生活服务`,
                                headerTitleStyle: {color: '#ffffff'},
                                headerStyle: {
                                    backgroundColor: '#e5322e'
                                }
                            }),    
    },
    LifeMap: {
        screen: LifeMap,
    },
    LifeDetail: {
        screen: LifeDetail
    },
    LifeDetailTransfer: {
        screen: LifeDetailTransfer
    },
    LifeList: {
        screen: LifeList
    }
})

// 页面上面的工具助手（对应底下第四个）
const ToolStack = createStackNavigator({
    Tool: {
        screen: Tool,
        navigationOptions:  ({navigation}) => ({
                                title: `工具助手`,
                                headerTitleStyle: {color: '#ffffff'},
                                headerStyle: {
                                    backgroundColor: '#e5322e'
                                }
                            }),
            
    },
})


// App底下的四个stack
const routesway = createBottomTabNavigator({
    FirstPage: {
        screen: FirstpageStack,
        navigationOptions: ({navigation})=>({
            tabBarLabel: "首页",
            tabBarIcon: ({focused, tintColor}) => (
                <Image
                    source={require('../img/nav_1.png')}
                    style={styles.tabBarIconStyle}
                />
            ),
            tabBarVisible:show
         }),
    },
    Guideline: {
        screen: GuidelineStack,
        navigationOptions: ({navigation})=>({
            tabBarLabel: "办事",
            tabBarIcon: ({focused, tintColor}) => (
                <Image
                    source={require('../img/nav_2.png')}
                    style={styles.tabBarIconStyle}
                />
            ),
            tabBarVisible:navigation.getParam('hideBar')?navigation.getParam('hideBar')():true
         }),
    },
    Life: {
        screen: LifeStack,
        navigationOptions: {
            tabBarLabel: "生活",
            tabBarIcon: ({focused, tintColor}) => (
                <Image
                    source={require('../img/nav_3.png')}
                    style={styles.tabBarIconStyle}
                />
            ),
         },
    },
    Tool: {
        screen: ToolStack,
        navigationOptions: {
            tabBarLabel: "工具",
            tabBarIcon: ({focused, tintColor}) => (
                <Image
                    source={require('../img/nav_4.png')}
                    style={styles.tabBarIconStyle}
                />
            ),
         },
    }
}, {
    initialRouteName: 'FirstPage',
    lazy: true,
    tabBarOptions: {
        inactiveTintColor: "#666666",
        activeTintColor: "#252435",
        labelStyle: {
           fontSize: 11
        }
      }
})

const Tab = createAppContainer(routesway)
export default Tab