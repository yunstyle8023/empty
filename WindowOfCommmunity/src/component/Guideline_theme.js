import React from 'react'
import {
    Text,
    View,
    Image,
    StyleSheet,
    TouchableOpacity,
    Alert
} from 'react-native'

const themeimg = [
    {img: require('../img/bszn_1jy.png'), text: '教育'},
    {img: require('../img/bszn_2ldjy.png'), text: '住房'},
    {img: require('../img/bszn_3shbz.png'), text: '就业'},
    {img: require('../img/bszn_4yl.png'), text: '社会保障'},
    {img: require('../img/bszn-5fw.png'), text: '出入境'},
    {img: require('../img/bszn_6jt.png'), text: '医疗卫生'},
    {img: require('../img/bszn_7hj.png'), text: '婚育收养'},
    {img: require('../img/bszn_8hy.png'), text: '教育'},
    {img: require('../img/bszn_9crj.png'), text: '教育'},
    {img: require('../img/bszn_10gy.png'), text: '教育'},
    {img: require('../img/bszn_11ns.png'), text: '教育'},
    {img: require('../img/bszn_12qt.png'), text: '教育'},
]

const styles = StyleSheet.create({
    themeitem: {
        width: 125,
        justifyContent: 'center',
        alignItems: 'center',
        borderBottomWidth: 1,
        borderBottomColor: '#ededed',
        borderRightWidth: 1,
        borderRightColor: '#ededed',
        paddingTop: 32,
        paddingBottom: 25
    },
    themeimg: {
        width: 40,
        height: 30,       
    },
    themetext: {
        fontSize: 12,
        color: '#8c8c8c',
        marginTop: 10,
    }
})

class Guideline_theme extends React.Component{
    // const {navigation} = this.props.navigation
    // _onPressButton = (index)=>{
    //     this.props.navigation.push('GuidelineNext', {
    //         index: index
    //     })
    // }
   
    render(){
        // const {navigation} = this.props.navigation  
        return (
            <View style={{flexDirection: 'row', flexWrap: 'wrap'}}>
                {
                    themeimg.map((item, index)=>
                        <TouchableOpacity onPress={()=> this.props.navigation.push('GuidelineNext', {themeindex: index})} key={index}>
                            <View style={styles.themeitem} >
                                <Image source={item.img} style={styles.themeimg}/>
                                <Text style={styles.themetext}>{item.text}</Text>
                            </View>
                        </TouchableOpacity>
                    )
                }
            </View>
        )
    }
}

export default Guideline_theme