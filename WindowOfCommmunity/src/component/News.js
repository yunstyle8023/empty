import React from 'react'
import {
    Image,
    Text,
    View,
    StyleSheet,
} from 'react-native'

const styles = StyleSheet.create({
    news: {
        flexDirection: 'row',
        paddingTop: 15,
        paddingBottom: 15,
        borderRightWidth: 1,
        borderRightColor: '#dfdfdf',
        borderBottomWidth: 8,
        borderBottomColor: '#efefef',
        flexShrink: 1
    },
    newsTitle: {
        color: '#333333',
        fontSize: 18,  
        marginBottom: 8,
        fontWeight: 'bold',
        flexShrink: 1,
    },
    newsInfo: {
        color:'#999999',
        fontSize: 16,
    }
})

export default class News extends React.Component {
    render(){
        return (
            <View style={styles.news}>
                 <View style={{ paddingLeft: 22, paddingRight: 22, borderRightColor: '#dfdfdf', borderRightWidth: 1}}>
                     <Image source={require('../img/home_jrgz.png')} style={{width: 36, height: 36}}/>
                 </View>
                 <View style={{paddingLeft: 10, flexShrink: 1}}>
                     <Text style={styles.newsTitle} numberOfLines={1}>政协北京市昌平区第五届委员会委员</Text>
                     <View style={{flexDirection: 'row'}}>
                         <Text style={styles.newsInfo}>来源：北京政务网</Text>
                         <Text style={styles.newsInfo}>2018-11-26</Text>
                     </View>
                 </View>
            </View>
        )
    }
}

