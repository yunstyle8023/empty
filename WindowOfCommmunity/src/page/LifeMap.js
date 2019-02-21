import React from 'react'
import {
    Text,
    Image,
    View,
    TouchableOpacity,
    // StyleSheet
} from 'react-native'

export default class LifeMap extends React.Component{
    // constructor(props){
    //     super(props)
    // }
    static navigationOptions = ({navigation}) => {
        return {
            title: `生活服务地图`,
            headerTitleStyle: {color: '#ffffff', fontSize: 18},
            headerLeft: 
            <TouchableOpacity onPress={()=> navigation.pop()}>
                <Image source={require('../img/back.png')} style={{marginLeft: 15}}/>
            </TouchableOpacity>,
            headerRight: <Text style={{marginRight: 15, color: '#ffffff'}}>列表</Text>,
            headerStyle: {
                backgroundColor: '#e5322e',
                color: '#ffffff'
            }
        }
    }
    render(){
        return <View><Text>生活服务地图</Text></View>
    }
}