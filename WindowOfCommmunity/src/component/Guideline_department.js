import React from 'react'
import {
    Text,
    View,
    StyleSheet,
    TouchableOpacity,
    Alert
} from 'react-native'

const departitems = [
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'Guideline'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'},
    {text:'区环保局', way: 'GuidelineNext'}
]

const styles = StyleSheet.create({
   guide: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        // flex: 1
        justifyContent: 'space-between',
   },
   guideitem: {
        height: 75,
        width: 187,
        justifyContent: 'center',
        paddingLeft: 40,
        borderRightWidth: 1,
        borderColor: '#ededed',
        borderBottomWidth: 1,
   },
   guidetext: {
        fontSize: 16,
        color: '#333333'
   }
})


class Guideline_department extends React.Component{
    _onPressButton(index){
        // 在此跳转到GuidelineNext并且把点击所对应的index传到GuidelineNext
        this.props.navigation.push('GuidelineNext', {
            departindex: index
        })
    }
    render(){
        return (
            <View style={styles.guide}>
                {
                    departitems.map((item, index)=>
                        <TouchableOpacity onPress={()=>this._onPressButton(index)} key={index}>
                            <View style={styles.guideitem} >
                                <Text style={styles.guidetext}>{item.text}</Text>
                            </View>
                        </TouchableOpacity>
                )
            }
            </View>
        )  
    }
}

export default Guideline_department