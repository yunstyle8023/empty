import React from 'react'
import {
    Image,
    Text,
    View,
    StyleSheet,
    Button,
    Dimensions,
} from 'react-native'

const {height,width} =  Dimensions.get('window');

const styles = StyleSheet.create({
    main: {
       borderBottomWidth: 8,
       borderBottomColor: '#eeeeee',
    },
    mainTop: {
        flexDirection: 'row',
    },
    mainLeft: {
        flexDirection: 'row',
        marginLeft: -width,
        width: 152,
        height: 75,
        backgroundColor: 'rgba(255, 255, 255, .5)',
        marginTop: 27,
        justifyContent: 'center',
        alignItems: 'center',
    },
    mainBot: {
        flexDirection: 'row',
        paddingLeft: 20,
        paddingRight: 20,
        marginTop: 15,
        justifyContent: 'space-between',
    },
    mainbotbox: {
        // width: 100,
        // height: 100
        justifyContent: 'center',
        alignItems: 'center',
        paddingBottom: 8,
    },
    mainbotimg: {
        marginBottom: 5,
    },
    mainbottext: {
        fontSize: 16,
    },
})

const mainBotimg = [
    {img: require('../img/home_1bs.png'), text: '我要办事'},
    {img: require('../img/home_2dt.png'), text: '昌平动态'},
    {img: require('../img/home_3zmhd.png'), text: '政民互动'},
    {img: require('../img/home_4jdhy.png'), text: '街道黄页'}
]
export default class Main extends React.Component {
    render(){
        return (
            <View style={styles.main}>
                <View style={styles.mainTop}>
                    <Image source={require('../img/home_bj.jpg')} style={{height: 140}}/>
                    <View style={styles.mainLeft}>
                        <Text style={{marginTop: 20, fontSize: 30, marginLeft: 10}}>9</Text>
                        <Text style={{marginTop: 30, fontSize: 20}}>℃</Text>
                        <View style={{marginLeft: 13}}>
                            <Text style={{color: '#333333'}}>晴转多云</Text>
                            <Text style={{color: '#333333'}}>-2/9℃</Text>
                            <Text style={{color: '#333333'}}>东南风2-3级</Text>
                        </View>
                    </View>
                </View>
                <View style={styles.mainBot}>
                    {mainBotimg.map((item, index)=>
                        <View style={styles.mainbotbox} key={index}>
                            <Image source={item.img} style={styles.mainbotimg}/>
                            <Text style={styles.mainbottext}>{item.text}</Text>
                        </View>
                    )}
                </View>
            </View>
        )
    }
}

