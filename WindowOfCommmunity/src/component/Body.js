import React from 'react'
import {
    View,
    Text,
    Image,
    StyleSheet,
    TouchableOpacity
} from 'react-native'

const bodyimg = [
    {img: require('../img/bszn_1jy.png'), text: '教育'},
    {img: require('../img/bszn_1jy.png'), text: '住房'},
    {img: require('../img/bszn_2ldjy.png'), text: '就业'},
    {img: require('../img/bszn_3shbz.png'), text: '社会保障'},
    {img: require('../img/bszn_9crj.png'), text: '出入境'},
    {img: require('../img/bszn_4yl.png'), text: '医疗卫生'},
    {img: require('../img/bszn_8hy.png'), text: '婚育收养'},
    {img: require('../img/home_8icon.png'), text: ''}
]

const addimg = {img: require('../img/home_8icon.png'), text: ''}
 
const styles = StyleSheet.create({
    body: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        borderBottomWidth: 8,
        borderBottomColor: '#eeeeee'
    },
    bodyitem: {
        width: '25%',
        height: 85,
        borderRightColor: '#efefef',
        borderBottomColor: '#efefef',
        borderRightWidth: 1,
        borderBottomWidth: 1,
        justifyContent: 'center',
    },
    bodyitembox: {
        alignItems: 'center',
    },
    bodyimg: {
        width: 34,
        height: 34,
        marginBottom: 8,
    },
    bodytext: {
        color: '#7d7d7d'
    }
})

export default class Body extends React.Component{
    constructor(props) {
        super(props);
        this.state = {
            initArr: bodyimg
      }
    }

    _changeTheme(initArr) {
        // 在传回的数组最后一项继续追加原来的加号
        initArr.push(addimg)
        this.setState({initArr})
    }

    _onPressButton(index){
        this.props.navigation.push('Addtheme',{
            initArr: this.state.initArr,
            changeTheme:this._changeTheme.bind(this),
        })
    }

    render(){
        // const lastArr = navigation.getParam('lastArr')
        // this.setState({
        //     initArr: lastArr
        // })
        return (
            <View style={styles.body}>
            {
                this.state.initArr.map((item, index)=>
                    // 数组最后一项为代表的加号，这里对它进行条件渲染
                    // 这里也必须写大括号，并且返回组件时需要写return
                    {
                        let text = <Text style={styles.bodytext}>{item.text}</Text> 
                        if (item.text === '') {
                            text = null
                        }
                        return <TouchableOpacity onPress={()=>this._onPressButton(index)} key={index} style={styles.bodyitem}>
                                    <View style={styles.bodyitembox}>
                                        <Image source={item.img} style={styles.bodyimg}/>
                                        {text}
                                    </View>
                                </TouchableOpacity> 
                    }
                )
            }
            </View>  
        )
    }
}