import React from 'react'
import {
    Text,
    View,
    Image,
    StyleSheet,
    TouchableOpacity
} from 'react-native'
import LifeMain from '../component/LifeMain'
import MapView, { PROVIDER_GOOGLE } from 'react-native-maps'

// const MapView = require('react-native-maps')

const styles = StyleSheet.create({
    life: {
        flex: 1,
        // marginTop: 44
    },
    lifebody: {
        borderTopColor: '#eeeeee'
    },
    transhead: {
        flexDirection: 'row',
        padding: 20,
        backgroundColor: 'rgba(255,255,255,.5)',
        justifyContent: 'space-between',
        marginTop: -310
    },
    locate: {
        // marginLeft: 20
    },
    lifemap: {
        height: 320,
        backgroundColor: 'black',
    }
})

class Life extends React.Component{
    constructor(props){
        super(props)
    }
    
    static navigationOptions = {
        title: `生活服务`,
        headerBackTitle: null
    }

    render(){
        return (
            <View style={styles.life}>
                <LifeMain navigation={this.props.navigation}/>
                <View style={styles.lifebody}>
                    <View style={styles.lifemap}>
                        <MapView
                            initialRegion={{
                            latitude: 37.78825,
                            longitude: -122.4324,
                            latitudeDelta: 0.0922,
                            longitudeDelta: 0.0421,
                            }}
                            style={{width:'100%',height:320}}
                        />
                        {/* <View></View> */}
                    </View>
                    <TouchableOpacity style={styles.transhead} onPress={()=> this.props.navigation.push('LifeMap')}>
                        <Text style={styles.locate}>广告商位置</Text>
                        <View style={{flexDirection: 'row'}}>
                            <Text>全部</Text>
                            <Image source={require('../img/go.png')} style={{marginLeft: 10}}/>
                        </View>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
}

export default Life