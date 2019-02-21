import React from 'react'
import {
    View,
    Image,
    Text,
    StyleSheet
} from 'react-native'

const localimg = [
    {img: require('../img/home-bdth.png'), text1: '烤肉披萨', text2: '￥61', text3: '￥61'},
    {img: require('../img/home-bdth.png'), text1: '烤肉披萨', text2: '￥61', text3: '￥61'},
    {img: require('../img/home-bdth.png'), text1: '烤肉披萨', text2: '￥61', text3: '￥61'},
    {img: require('../img/home-bdth.png'), text1: '烤肉披萨', text2: '￥61', text3: '￥61'},
]

const styles = StyleSheet.create({
    local: {
        paddingLeft: 20,
        paddingRight: 20,
        borderBottomWidth: 1,
        borderBottomColor: '#b2b2b2'
    },
    head: {
        flexDirection: 'row',
        paddingTop: 10,
        paddingBottom: 10,
        justifyContent: 'space-between'
    },
    localbox: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        justifyContent: 'space-between'
    },
    localitem:{
        justifyContent: 'center',
        alignItems: 'center'
    },
    localimg: {
        width: 78,
        height: 64,
    }

})

export default class Local extends React.Component{
    render(){
        return (
            <View style={styles.local}>
                <View style={styles.head}>
                    <Text style={{fontSize: 16, fontWeight: 'bold', color: '#5d5d5d'}}>本地特惠</Text>
                    <Text style={{fontSize: 12, color:'#666666'}}>查看全部</Text>
                </View>
                <View style={styles.localbox}>
                    {
                        localimg.map((item, index)=> 
                            <View style={styles.localitem} key={index}>
                                <Image source={item.img} style={styles.localimg}/>
                                <Text style={{fontSize: 12, marginTop: 7, marginBottom: 4}}>{item.text1}</Text>
                                <View style={{flexDirection: 'row', alignItems: 'flex-end', marginBottom: 12}}>
                                    <Text style={{fontSize: 16, color: '#f05633'}}>{item.text2}</Text>
                                    <Text style={{fontSize: 12, color: '#999999', textDecorationLine:'line-through'}}>{item.text3}</Text>
                                </View>
                            </View>
                        )
                    }
                </View>
            </View>
        )
    }
}