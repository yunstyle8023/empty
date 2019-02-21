import React from 'react'
import {
    Text,
    TextInput,
    Image,
    View,
    Button,
    StyleSheet,
    TouchableOpacity
} from 'react-native'

const styles = StyleSheet.create({
    guideline: {
        // marginTop: 44,
        flex: 1,
        backgroundColor: '#efefef'
    },
    search: {
        backgroundColor: '#efefef',
        padding: 10,
        alignItems: 'center',
        justifyContent: 'center',
    },
    searchinp: {
        backgroundColor: '#ffffff',
        borderRadius: 8,
        height: 33,
        width: '100%',
        textAlign: 'center'
    },
    list: {
        flexDirection: 'row',
        backgroundColor: '#ffffff', 
        justifyContent: 'space-between',
        padding: 20,
        borderBottomWidth: 1,
        borderBottomColor: '#efefef',
        alignItems: 'center'
    },
    listLeft: {
        flexShrink: 1,
    },
    // 使得文字不换行并且多余部分省略
    lefttext1: {
        fontSize:14,
        color: '#333333',
        marginBottom: 10,
        flexShrink: 1
    },
    lefttext2: {
        fontSize:12, 
        color: '#999999'
    },
    listimg: {
        width: 12,
        height: 12
    },
})

const themearr = [1, 2, 3, 4]

export default class GuidelineNext extends React.Component {
    // 想把底下的四个stack隐藏起来，但是没有起作用
    static navigationOptions = {
        tabBarVisible: false,
    }
    hideBar(){
        return false;
    }

    componentDidMount(){
        this.props.navigation.setParams({
            hideBar:this.hideBar.bind(this)
        })
    }

    render(){
        const { navigation } = this.props;
        const themeindexId = navigation.getParam('themeindex');
        const departindexId = navigation.getParam('departindex');
        const DepartNext = ()=> typeof departindexId === 'number'?
                        themearr.map((item, index)=> 
                            <TouchableOpacity style={styles.list} key={index} onPress={()=>this.props.navigation.push('TodoDetail')}>
                                <View style={styles.listleft}>
                                    <Text style={styles.lefttext1}>部门{departindexId}</Text>
                                    <Text style={styles.lefttext2}>部门{departindexId}</Text>
                                </View>
                                <Image source={require('../img/go.png')} style={styles.listimg}/>
                            </TouchableOpacity>
                        )
                        : <View></View>
        const  ThemeNext= ()=>typeof themeindexId === 'number'? 
                        <TouchableOpacity onPress={()=>this.props.navigation.push('TodoDetail')}>
                            <View style={{flexDirection: 'row', justifyContent: 'space-between'}}>
                                <Text style={styles.lefttext1}>主题{themeindexId}</Text>
                                <Text style={styles.lefttext2}>主题{themeindexId}</Text>
                            </View>
                            <Image source={require('../img/go.png')}/>
                        </TouchableOpacity>: <View></View>
        
        return (
            <View style={styles.guideline}>
                <View style={styles.search}>
                    <TextInput placeholder="搜索" style={styles.searchinp}/>
                </View>
                <ThemeNext/>
                <DepartNext/>
            </View>
        )
    }
}
