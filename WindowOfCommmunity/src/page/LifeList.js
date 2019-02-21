import React from 'react'
import {
    Text,
    Image,
    View,
    Picker,
    TouchableOpacity,
    TouchableHighlight,
    Modal,
    StyleSheet
} from 'react-native'
import { TextInput } from 'react-native-gesture-handler';

const styles = StyleSheet.create({
    lifelist: {
        // backgroundColor: '#efefef'
        
    },
    xiala: {
        width: '50%',
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        borderRightWidth: 1,
        borderBottomWidth: 1,
        borderRightColor: '#d9d9d9',
        borderBottomColor: '#d9d9d9',
        paddingTop: 20,
        paddingBottom: 20,
    },
    xialatext: {
        marginRight: 15,
        color: '#333333',
        fontSize: 16
    },
    xialaimg: {
        width: 10,
        height: 10
    },
    lifelistitem: {
        flexDirection: 'row',
        paddingTop: 10,
        paddingLeft: 10,
        paddingBottom: 10,
        paddingRight: 10,
        justifyContent: 'center',
        alignItems: 'center',
        borderBottomWidth: 1,
        borderBottomColor: '#d9d9d9'
    },
    photo: {
        width: 60,
        height: 50
    },
    shop: {
        flexShrink: 1,
        color: '#333333',
        // marginLeft: 15
    },
    locate: {
        color: '#d3d3d3',
        marginTop: 10
    }
})

export default class LifeList extends React.Component {
    constructor(props){
        super(props)
        this.state = {
            language: [1, 2, 3],
            xiala1Sure: false,
            xiala2Sure: false,            
        }
    }
    static navigationOptions = ({navigation}) => {
        return {
            title: `生活服务列表`,
            headerTitleStyle: {
                color: '#ffffff',
                fontSize: 20
            },
            headerLeft: 
                <TouchableOpacity onPress={()=> navigation.pop()}>
                    <Image source={require('../img/back.png')} style={{marginLeft: 15}}/>
                </TouchableOpacity>,
            headerStyle: {
                backgroundColor: '#e5322e'
            }
        }
    }

    setModalVisible(visible) {
        this.setState({ xiala1Sure: visible });
    }

    render(){
        // 下拉列表用到模态框和选择器两个组件
        // 需要思考为什么在这里不能改变xialaSure的值
        // let xialaSure = false
        let xiala = <Picker
                        selectedValue={this.state.language}
                        mode="dropdown"
                        style={{ height: 50, width: 100 }}
                        onValueChange={(itemValue, itemIndex) => this.setState({language: itemValue})}>
                        <Picker.Item label="Java" value="java" />
                        <Picker.Item label="JavaScript" value="js" />
                    </Picker>
        return (
            <View style={styles.lifelist}>
                <View style={{flexDirection: 'row'}}>
                    <View style={styles.xiala}>
                        <Modal
                            animationType="none"
                            transparent={true}
                            visible={this.state.xiala1Sure}
                            // presentationStyle='pageSheet'
                            onRequestClose={() => {
                                alert("Modal has been closed.");
                            }}> 
                            <View style={{ marginTop: 55 }}>
                               
                                <TouchableOpacity onPress={()=> this.setModalVisible(!this.state.xiala1Sure)}>
                                    <Text>22222</Text>
                                </TouchableOpacity>
                                {xiala}  
                            </View>
                        </Modal>
                        <Text style={styles.xialatext}>单位机构</Text>
                        {/* modal外面的为触发模态框出现的组件 */}
                        <TouchableHighlight
                            onPress={() => 
                                this.setModalVisible(!this.state.xiala1Sure)
                            }
                        >
                            <Image source={require('../img/morelist.png')} style={styles.xialaimg}/>          
                        </TouchableHighlight>  
                    </View>
                    <View style={styles.xiala}>
                        <Text style={styles.xialatext}>餐饮</Text>
                        <TouchableOpacity onPress={()=> this.setState({xiala2Sure: !this.state.xiala2Sure})}>
                            <Image source={require('../img/morelist.png')} style={styles.xialaimg}/>
                        </TouchableOpacity>
                    </View>
                </View>
                {/* 搜索框 */}
                <View style={{backgroundColor: '#efefef', paddingLeft: 15, paddingTop: 10, paddingRight: 15, paddingBottom: 10}}>
                    <View style={{width: 350, height: 40, backgroundColor: '#ffffff', justifyContent: 'center', alignItems: 'center', borderRadius: 10}}>
                        <Text style={{color: '#999999'}}>搜索</Text>
                    </View>
                </View>

                <TouchableOpacity onPress={()=> this.props.navigation.push('LifeDetail')}>
                {
                    this.state.language.map((item, index)=> {
                        return  <View style={styles.lifelistitem} key={index}>
                                    <Image source={require('../img/home-bdth.png')} style={styles.photo}/>
                                    <View style={{flexShrink: 1}}>
                                        <Text numberOfLines={1} style={styles.shop}>北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区北京市昌平区</Text>
                                        <Text numberOfLines={1} style={styles.locate}>北京市昌平区北京市昌平区北京市昌平区北京市昌平区</Text>
                                    </View>
                                    <Image source={require('../img/go.png')}/>
                                </View>
                    })
                }
                </TouchableOpacity>
            </View>
        )
    }
}