import React, {Component} from 'react';
import { Text, View, Image} from 'react-native';
import {StyleSheet} from 'react-native'

const styles = StyleSheet.create({
    banner: {
        flexDirection: 'row', 
        backgroundColor: '#e5322e',
        paddingTop: 44,
        alignItems: 'center',
        color: '#e5322e',
        paddingLeft: 20,
        paddingRight: 20,
    },
    banner_left: {
        flexDirection: 'row',
        marginRight: 46,
    },
    banner_mid: {
        color: '#ffffff',
        alignItems: 'center',
        marginRight: 80,
    },
    banner_right: {
        alignItems: 'center',
        color: '#ffffff'
    }
})

export default class Banner extends Component {
  render() {
    return (
        <View style={styles.banner}>
            <View style={styles.banner_left}>
                <Image source={require('../img/home_wz.png')}/>
                <Text style={{marginLeft: 9, color: '#ffffff'}}>回龙观</Text>
            </View>
            <View style={styles.banner_mid}>
                <Text style={{color: '#ffffff', fontSize: 16}}>社区之窗</Text>
                <Text style={{color: '#ffffff', fontSize: 12}}>SMART CHANGPING</Text>
            </View>
            <View>
                <Image source={require('../img/home_hy.png')}/>
            </View>
        </View>
    );
  }
}


