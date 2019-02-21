import React from 'react'
import {
    Text,
    View,
    Image,
    StyleSheet
} from 'react-native'

const jiaotong = [
    '车龄违法',
    '车龄违法',
    '车龄违法',
    '车龄违法',
    '车龄违法',
]

const huanjing = [
    '车龄违法',
    '车龄违法',
    '车龄违法'
]

const styles = StyleSheet.create({
    tools: {
        // marginTop: 44
    },
    jiaotonghead: {
        flexDirection: 'row',
        paddingTop: 10,
        paddingBottom: 10
    },
    jiaotongbody: {
        flexDirection: 'row',
        flexWrap: 'wrap',
    },
    jiaotongitem: {
        borderWidth: 1
    }
})

class Tool extends React.Component{
    static navigationOptions = {
        title: `工具助手`,
        headerBackTitle: null,
    } 
    render(){
        return (
            <View style={styles.tools}>
                <View>
                    <View style={styles.jiaotonghead}>
                        <Image source={require('../img/gjzs_1jt.png')}/>
                        <Text>交通出行</Text>
                    </View>
                    <View style={styles.jiaotongbody}>
                        {
                            jiaotong.map((item, index)=>
                                <View style={styles.jiaotongitem} key={index}>
                                    <Text>{item}</Text>
                                </View>
                            )
                        }
                    </View>
                </View>
                <View>
                    <View style={styles.jiaotonghead}>
                        <Image source={require('../img/gjzs_2hj.png')}/>
                        <Text>环境气象</Text>
                    </View>
                    <View style={styles.jiaotongbody}>
                        {
                            huanjing.map((item, index)=>
                                <View style={styles.jiaotongitem} key={index}>
                                    <Text>{item}</Text>
                                </View>
                            )
                        }
                    </View>
                </View>
            </View>
        )
    }
}

export default Tool