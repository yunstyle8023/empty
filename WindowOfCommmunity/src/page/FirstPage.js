import React from 'react'
import {
    Text,
    View,
    // 滚动视图
    ScrollView,
    SafeAreaView
} from 'react-native'
import Banner from '../component/Banner'
import Main from '../component/Main'
import News from '../component/News'
import Body from '../component/Body'
import Local from '../component/Local'

class FirstPage extends React.Component{
    render(){
        return (
            // <SafeAreaView style={{flex:1, }}>
            <ScrollView>
                <Banner/>
                <Main/>
                <News/>
                <Body navigation={this.props.navigation}/>
                <Local/>
            </ScrollView>
            // </SafeAreaView>
        )
    }
}

export default FirstPage