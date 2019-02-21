import React from 'react'
import {
    Text,
    Image,
    View,
    Modal,
    TouchableOpacity,
    TouchableHighlight,
    StyleSheet
} from 'react-native'

const styles = StyleSheet.create({
    lifelist: {
        // marginTop: 44
    },
    modal: {
        width: '100%',
        height: 115,
        marginTop: 620,
        backgroundColor: '#dcdcdc',
        paddingLeft: 20,
        paddingRight: 20,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
    },
    img: {
        marginRight: 10
    },
    text: {
        fontSize: 16,
        color: '#333333'
    },
    close: {
        backgroundColor: '#ffffff',
        height: 50,
        justifyContent: 'center',
        alignItems: 'center'
    }
})

export default class LifeList extends React.Component {
    constructor(props){
        super(props)
        this.state = {
            modalVisible: false
        }
    }

    handleVisible() {
        this.setState({modalVisible: !this.state.modalVisible})
    }

    static navigationOptions = ({navigation}) => {
        return {
            title: `详情`,
            headerTitleStyle: {
                color: '#ffffff'
            },
            headerLeft: <Image source={require('../img/back.png')} style={{marginLeft: 10}}/>,
            headerRight: <View style={{flexDirection: 'row', alignItems: 'center'}}>
                            <Image source={require('../img/sc.png')}  style={{marginRight: 15}}/>
                            <TouchableHighlight
                                onPress={
                                   navigation.getParam('handleVisible')
                                }
                                style={{marginRight: 15}}
                            >
                                <Image source={require('../img/zf.png')}/>
                            </TouchableHighlight>
                        </View>,
            headerStyle: {
                backgroundColor: '#e5322e'
            }
        }
    }

    componentDidMount(){
        this.props.navigation.setParams({
            handleVisible: this.handleVisible.bind(this)
        })
    }
    render(){
        return  <View style={styles.lifelist}>
                    <Text>生活服务详情</Text>
                    <Modal
                        animationType="none"
                        transparent={true}
                        visible={this.state.modalVisible}
                        // presentationStyle='pageSheet'
                        onRequestClose={() => {
                            alert("Modal has been closed.");
                        }}>
                            <View>
                                <View style={styles.modal}>
                                    <Image source={require('../img/fx_wx.png')} style={styles.img}/> 
                                    <Image source={require('../img/fx.em.png')} style={styles.img}/>  
                                    <Image source={require('../img/fx.qq.png')} style={styles.img}/>  
                                    <Image source={require('../img/fx_pyq.png')} style={styles.img}/>  
                                </View>
                                <TouchableOpacity style={styles.close} onPress={()=> this.handleVisible(!this.state.modalVisible)}>
                                    <Text>关闭</Text>
                                </TouchableOpacity>
                            </View>
                    </Modal>
                    {/* <TouchableHighlight
                        onPress={() => 
                            this.handleVisible(!this.state.modalVisible)
                        }
                    ></TouchableHighlight> */}
                </View>
    }
}