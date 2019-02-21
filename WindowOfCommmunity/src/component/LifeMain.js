import React from 'react'
import {
    Image,
    Text,
    View,
    TouchableOpacity,
    StyleSheet
} from 'react-native'

const lifeimg = [
    {img: require('../img/home_1bs.png'), text: '我要办事'},
    {img: require('../img/home_2dt.png'), text: '昌平动态'},
    {img: require('../img/home_3zmhd.png'), text: '政民互动'},
    {img: require('../img/home_4jdhy.png'), text: '街道黄页'},
    {img: require('../img/home_1bs.png'), text: '我要办事'},
    {img: require('../img/home_2dt.png'), text: '昌平动态'},
    {img: require('../img/home_3zmhd.png'), text: '政民互动'},
    {img: require('../img/home_4jdhy.png'), text: '街道黄页'}
]

const styles = StyleSheet.create({
    main: {
        borderBottomWidth: 20,
        borderBottomColor: '#eeeeee',
     },
    mainTop: {
        flexDirection: 'row',
    },
    mainBot: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        flexWrap: 'wrap',
        // height: 200
    },
    mainbotbox: {
        justifyContent: 'center',
        alignItems: 'center',
        padding: 13,
        borderRightWidth: 1,
        borderRightColor: '#efefef',
        borderBottomWidth: 1,
        borderBottomColor: '#efefef'
    },
    mainbotimg: {
        marginBottom: 5,
        width: 30,
        height: 30
    },
    mainbottext: {
        fontSize: 16,
        color: '#333333'
    },
})

export default class LifeMain extends React.Component {
    
    constructor(props){
        super(props)
    }
    
    render(){
        return (
            <TouchableOpacity style={styles.main} onPress={()=> this.props.navigation.push('LifeList')}>
                <View style={styles.mainTop}>
                    <Image source={require('../img/home_bj.jpg')} style={{height: 140}}/>
                </View>
                <View style={styles.mainBot}>
                    {
                        lifeimg.map((item, index)=>
                            <View style={styles.mainbotbox} key={index}>
                                <Image source={item.img} style={styles.mainbotimg}/>
                                <Text style={styles.mainbottext}>{item.text}</Text>
                            </View>
                        )
                    }
                </View>
            </TouchableOpacity>
        )
    }
}
