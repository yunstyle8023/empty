import React from 'react'
import styles from './templatestyle'
import {
    SectionList,
    Text,
    Image,
    View,
    FlatList,
    SafeAreaView,
    Button,
    TouchableOpacity,
} from 'react-native'

interface Props {
    title: string;
    address: string;
    start_time: string;
    end_time: string;
    remind_time_desc: string;
    privacy_typ: number;
    content: string;
    user_list: Array<string>;
    logs: Array<string>;
}
interface State{
    // title: string;
    // address: string;
    // start_time: string;
    // end_time: string;
    // remind_time_desc: string;
    // privacy_typ: number;
    // content: string;
    // user_list: Array<string>;
    user_show: number;
    isShow: boolean;
}

const show = [
    {
        text:'展开',
        icon:require('../img/open.png'),
    },
    {
        text:'收起',
        icon:require('../img/close.png'),
    },
];

const imgdata = {
    next: require('../img/icons_details4.png'),
    templatetitle: require('../img/templatetitle.png'),
    startTime: require('../img/start-time.png'),
    endTime: require('../img/end-time.png'),
    participate: require('../img/paticipate.png'),
    remind: require('../img/remind.png'),
    private: require('../img/private.png'),
    locate: require('../img/locate.png'),
    content: require('../img/typecontent.png')
 };
    

export default class TemplateDetails extends React.Component<Props, State>{
    state: State
    props: Props
    height: number

    constructor(props: Props){
        super(props)
        this.state = {
            user_show: 0,
            isShow: false,
        }
        this.height = 0;
    }

    renderItem({ item, index, section }: any){
        return (
            <View key={index} style={[styles.mar20_pa0,styles.listitem]}>
                <Image source={item.img} style={styles.img}/>
                <Text style={styles.text}>{item.text}</Text>
            </View>
        )
    }

    renderItemUser({ item, index, section }: any){
        
        return (
            <View key={index} style={[styles.mar20_pa0,styles.listitem]}>
                <Image source={item.img} style={styles.img}/>
                <View style={{flex:1}}>
                    <Text style={styles.text} numberOfLines={this.state.user_show} onLayout={this.userLayout.bind(this)}>{item.text}</Text>
                    {this.showBtn()}
                </View>
            </View>
        )
    }
    showBtn(){
        if (this.state.isShow) {
            const btnShow = this.state.user_show===2;
            const btn = btnShow?show[0]:show[1];
            return (
                <TouchableOpacity 
                    activeOpacity={1}
                    onPress={()=>{(this as any).setState({user_show: btnShow?0:2})}} 
                    style={{flexDirection: 'row', alignItems:'center', marginTop: -7, marginBottom: 17}}
                >
                    <Text style={styles.showBtnText}>{btn.text}</Text>
                    <Image source={btn.icon} style={styles.showBtnIcon}/>
                </TouchableOpacity>
            );
        } 
        return null;
    }
    userLayout({nativeEvent: {layout: {x, y, width, height}}}:any) {
        if (this.height === 0) {
            this.height = height;
            (this as any).setState({user_show: 2, isShow:(height>54)});
        } else {
            if (!this.state.isShow) {
                (height < this.height)?(this as any).setState({isShow: true}):null;
            }
        }
    }

    renderItem1(){
        return (
            <View style={[styles.pa20_mar0,styles.listitem1]}>
                <Image source={imgdata.templatetitle} style={styles.img}/>
                <Text style={styles.text1} >{this.props.title}</Text>
            </View>
        )
    }

    renderItem2({ item, index, section }: any){
        return (
            <View key={index} style={[styles.mar20_pa0,styles.listitem]}>
                <Image source={item.img} style={styles.img}/>
                <View style={styles.imgView}>
                {
                    item.text.map((value: any,key: any)=>{
                        return  <Image key={key} source={{uri:value}} style={styles.user} defaultSource={require('../img/head20.png')}/>
                    })
                }
                </View>
            </View>
        )
    }

    renderItem3({ item, index, section }: any){
        return (
            <View key={index} style={[styles.pa20_mar0,styles.listitem, styles.listitem3]}>
                <Image source={item.img} style={styles.img}/>
                <Text style={styles.text}>{item.text}</Text>
            </View>
        )
    }

    listFooterComponent(foot: Array<String>){
        return (
            <View style={styles.footer}>
                {
                    foot.map((value,key)=>{
                        return (
                            <View style={styles.footeritem} key={key}>
                                <View style={styles.dot}></View>
                                <Text style={styles.foottext1}>{value}</Text>
                            </View>
                        )
                    })
                }
            </View>
        )
    }

    render(){
        return (
            <SafeAreaView style={{backgroundColor: 'white', flex: 1, flexDirection: 'column-reverse'}}>
            <SectionList
                renderItem={this.renderItem.bind(this)}
                sections={[
                    { data: [{img: imgdata.startTime, text: this.props.start_time}]},
                    { data: [{img: imgdata.endTime, text: this.props.end_time}]},
                    { data: [{img: imgdata.participate,text: this.props.user_list}], renderItem: this.renderItemUser.bind(this)/*renderItem: this.renderItem2*/},
                    { data: [{img: imgdata.remind,text: this.props.remind_time_desc}]},
                    { data: [{img: imgdata.private,text: this.props.privacy_typ===1?'隐私-参与人可见':'公开-所有人可见'}], renderItem: this.renderItem3},
                    { data: [{img: imgdata.locate,text: this.props.address}]},
                    { data: [{img: imgdata.content,text: this.props.content}]},
                ]}
                ListFooterComponent={()=>this.listFooterComponent(this.props.logs)}
                keyExtractor={(item: any, index: any) => item + index}
                style={styles.list}
                // SectionSeparatorComponent={this.sectionSeparatorComponent.bind(this)}
                // ItemSeparatorComponent={this.itemSeparatorComponent.bind(this)}
                contentInset={{top:7,left:0,bottom:0,right:0}}
            />
            <View>
                {this.renderItem1()}
            </View>
            </SafeAreaView>
        )
    }
}