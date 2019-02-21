import React from 'react'
import {
    View,
    Image,
    Text,
    Button,
    TouchableOpacity,
    StyleSheet
} from 'react-native'

const alltheme = [
    {img: require('../img/bszn_1jy.png'), text: '教育', select: false},
    {img: require('../img/bszn_2ldjy.png'), text: '住房'},
    {img: require('../img/bszn_3shbz.png'), text: '就业'},
    {img: require('../img/bszn_4yl.png'), text: '社会保障'},
    {img: require('../img/bszn-5fw.png'), text: '出入境'},
    {img: require('../img/bszn_6jt.png'), text: '医疗卫生'},
    {img: require('../img/bszn_7hj.png'), text: '婚育收养'},
    {img: require('../img/bszn_3shbz.png'), text: '交通出行'},
    {img: require('../img/bszn_4yl.png'), text: '其他'},
    {img: require('../img/bszn-5fw.png'), text: '纳税'},
    {img: require('../img/bszn_6jt.png'), text: '公用事业'},
    {img: require('../img/bszn_7hj.png'), text: '户籍省份'},
]

const styles = StyleSheet.create({
    addtheme: {
        flexDirection: 'row',
        flexWrap: 'wrap',
    },
    additem: {
        width: '33%',
        paddingLeft: 10,
        paddingRight: 10,
        paddingTop: 10,
        paddingBottom: 10,
        justifyContent: 'center',
        alignItems: 'center'
    },
    addimg:{
        width: 45,
        height: 45,
        alignSelf: 'center'
    },
    addtext: {
        fontSize: 16,
        marginTop: 7
    },
    bottomright: {
        alignSelf: 'flex-end'
    }
})

const bottomrightimg = {
    yes: require('../img/bs_xz.png'),
    no: require('../img/bs_wxz.png')
}


export default class Addtheme extends React.Component {

    constructor(props){
        super(props)
        this.state = {
            // 接收传递过来的数组
            lastArr: this.props.navigation.getParam('initArr'),
            // selectimg: false
            alltheme: this._initialselectimg()
        }
    }
    
    static navigationOptions = ({navigation})=>{
        return {
            title: '添加办事主题',
            headerRight: <TouchableOpacity onPress={navigation.getParam('done')}>
                            <Text style={{fontSize: 16, color:'#ffffff', marginRight: 20, fontWeight: 'bold'}}>完成</Text>
                         </TouchableOpacity>,
            headerTitleStyle: {
                color: '#ffffff'
            }
            // headerRightStyle: {
            //     color: '#ffffff'
            // }
        }
    }

    componentDidMount() {
        this.props.navigation.setParams({
            done: this._done.bind(this)
        })
    }
    // 根据传来的initArr来初始化图片的选中与取消状态
    _initialselectimg() {
        // let selectimg = false
        // // map会把遍历后的数组返回一个新的数组
        // this.state.lastArr.map((obj,num)=> {
        //     if (obj.text===item.text){
        //         selectimg = true
        //     } 
        // }
        // )
        // return selectimg
        // ----------------------------------------------------------------
        // indexOf 不能判断相同的两个对象
        // if(this.state.lastArr.indexOf(item)>=0){
        //     return true
        // } else {
        //     return false
        // }
        // ----------------------------------------------------------------
        // 分别对alltheme和lastArr进行遍历，通过比较，
        // 来设置每一个项所对应的item的selectimg
        return alltheme.map((item)=>{
            // let selectimg = false
            this.props.navigation.getParam('initArr').map((obj,num)=> {
                if (obj.text===item.text){
                    // selectimg = true
                    item.select = true
                    console.log(item)
                } 
                // 在多次循环对同一变量赋值时，后面的结果会覆盖掉前面的结果
                // else {
                //     item.select = false
                //     console.log(item)
                // }
                 
            })
            return item
        })

    
    }
    // 给每个item项添加点击事件，改变每个item中图片的选中与取消状态
    _handleselectimg(item, index) {
        // ...（扩展运算符）代表数组或者对象的展开
        let arr = [...this.state.alltheme];
        arr[index].select = !arr[index].select;
        this.setState({
            alltheme: arr
        })
    // item代表数组中的每一项，它的改变不会改变原数组的值
        // this.state.alltheme[index].select = !item.select
        // this.setState({
        //     alltheme: this.state.alltheme
        // })
    }
    // 点击完成后
    _done() {
        const { navigation } = this.props
        const lastArr = []
        this.state.alltheme.map((item, index)=>{
            if(item.select){
                lastArr.push(item)
            }
            // return item
        })
        const changeTheme = navigation.getParam('changeTheme');
        changeTheme(lastArr)
        navigation.goBack()
    }
    
    render(){
        return (
        <View style={styles.addtheme}>
            {
                this.state.alltheme.map((item, index)=> 
                <TouchableOpacity onPress={(item)=>this._handleselectimg(item, index)} key={index} style={styles.additem}> 
                    <Image source={item.img}  style={styles.addimg}/>
                    <Text style={styles.addtext}>{item.text}</Text>
                    <Image source={item.select?bottomrightimg.yes:bottomrightimg.no} style={styles.bottomright}/>
                </TouchableOpacity>
                )
            }
        </View>
        )
    }
}