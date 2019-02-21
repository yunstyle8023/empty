import React from 'react'
import {
    Text,
    View,
    Image,
    StyleSheet
} from 'react-native'

export default class TodoDetail extends React.Component{
    static navigationOptions = {
        title: `详情`,
        // headerRight: <TouchableOpacity onPress={navigation.getParam('done')}>
        //                 <Text style={{fontSize: 14, color:'#ffffff', marginRight: 20, fontWeight: 'bold'}}>完成</Text>
        //             </TouchableOpacity>,
        // headerBackTitle: null
    }
    render() {
        return (
            <View style={{flexDirection: 'row'}}>
                <View>
                    <Text style={{fontSize: 14, color: '#333333'}}>燃煤锅炉改造燃煤锅炉改造燃煤锅炉改造燃煤锅炉改造补助资金申请</Text>
                    <Text style={{fontSize: 12, color: '#999999', marginTop: 10}}>办理机构：市环保局</Text>
                </View>
                <Image source={require('../img/go.png')}/>
            </View>
        )
    }
}
