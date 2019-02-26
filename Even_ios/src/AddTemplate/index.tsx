import React from 'react'
import styles from './index'
import {
    Text,
    View,
    Image,
    TextInput,
    SafeAreaView,
    SectionList,
    Switch,
    TouchableOpacity,
    Alert,
    Dimensions
} from 'react-native'
import { 
    NativeModules,
    NativeEventEmitter
} from "react-native";

const CA_HRNAddScheduleM = NativeModules.CA_HRNAddScheduleM;
const calendarManagerEmitter = new NativeEventEmitter(CA_HRNAddScheduleM);

interface Props {
    dispatch(arg0: any): any;
    navigation: any;
    sign: string;
    address: string;
    content: string;
    end_time: string;
    privacy_typ: number;
    remind_time_desc: string;
    // rootTag: number;
    start_time: string;
    title: string;
    user_list: string;//Array<string>;
};
interface State {
    title: string;
    address: string;
    start_time: string;
    end_time: string;
    remind_time_desc: string;
    privacy_typ: number;
    content: string;
    user_list: string//Array<string>;
 };

 const imgdata = {
    next: require('../img/icons_details4.png'),
    templatetitle: require('../img/templatetitle.png'),
    startTime: require('../img/start-time.png'),
    endTime: require('../img/end-time.png'),
    participate: require('../img/paticipate.png'),
    remind: require('../img/remind.png'),
    private: require('../img/private.png'),
    locate: require('../img/locate.png'),
    typecontent: require('../img/typecontent.png')
 }
    
class AddTemplate extends React.Component<Props, State>  {
   
    state: State
    props: Props
    listener: any;

   constructor(props: Props) {
        super(props)
        // console.log(props);
        this.state={
            title: this.props.title||'',
            address: this.props.address||'',
            start_time: this.props.start_time||'',
            end_time: this.props.end_time||'',
            remind_time_desc: this.props.remind_time_desc||'',
            privacy_typ: this.props.privacy_typ||1,
            content: this.props.content||'',
            user_list: this.props.user_list||'',//[],
        }
    }

    template11 =({ item, index, section }: any)=>{

        let firstBreak = true; 
        
        const icon = <Text key={index} style={styles.text}>{item.icon}</Text>;

        const content = ( index === 200 )?
            item.state.map((value: any,key: any)=>{
                // this.template12({item, index})
                const { height, width } = Dimensions.get('window')
                const userWidth = width - (20+24+14+20+14)
                const restWidth = userWidth-35 * ( key+1 )
                if (restWidth < 30) {

                    if (firstBreak) {
                        firstBreak = false;

                        if (key === item.state.length-1) {
                            return <View key={key}><Image source={{uri:value}} style={styles.participate} /></View>
                        } else {
                            // const restNum = (item.state.length-key)
                            // const restnum = restNum >99 ? 99 : restNum

                            let restnum = item.state.length-key;
                            restnum > 99 && (restnum = 99);

                            return <View key={key} style={styles.restNumBox}><Text style={styles.restNum}>+{restnum}</Text></View>
                        }
                    }

                    return null;
                };
                return <View key={key} style={{marginRight:5}}><Image source={{uri:value}} style={styles.participate} /></View>
            })
        :<Text key={index} style={[styles.text1,{flexShrink:1, marginRight:20}]} numberOfLines={1}>{item.state}</Text>;

        const show = (item.state.length>0)?content: icon;
                
        return show;
    }

    template1 =({ item, index, section }: any) => 
    (
        <TouchableOpacity 
           activeOpacity={1}
           onPress={( index === 4 )? null:()=>this._onPressButton(index)} 
           style={[styles.listitem, index===4&&{ borderBottomWidth: 15, borderBottomColor: '#FAFAFA'}]}
           >
           <View style={styles.listitemLeft}>
               <Image source={item.img} style={styles.icon}/>
               
                {
                    this.template11({ item, index, section })
                }
                
            </View>
            {
               ( index === 4 ) ?
                   <View style={styles.listitemLeft}>
                       <Text style={styles.all}>{(this.state.privacy_typ!=1)?'公开-所有人可见':'隐私-参与人可见'}</Text>
                       <Switch 
                            trackColor="#FF4CD964" 
                            style={{marginLeft: 6}}
                            value={!(this.state.privacy_typ==1)}
                            onValueChange={(value: any)=> {
                                (this as any).setState({
                                    privacy_typ: (this.state.privacy_typ==1)? 2:1
                                })
                             }}
                       >
                       </Switch>
                   </View>
               :
                   <Image source={imgdata.next} style={styles.next}/>
            }
            
        </TouchableOpacity>
   )

   template3 = ({ item, index, section}: any) => 
    (
    <View style={[styles.listitem,{justifyContent: 'flex-start'}]}>
        <Image source={item.img} style={styles.icon}/>
        <TextInput
            placeholder={item.icon}
            placeholderTextColor="#999999"
            value={item.state}
            onChangeText={(value)=>this.func(value,index)} 
            // maxLength = {40}
            style={[styles.text, {flexGrow: 1,color:'#444444'}]}
        />
    </View>
    )
    
    func= (value: any,index: any)=>{
        ( index==0 )? (this as any).setState({address: value})
        : (this as any).setState({content: value})
    }

    _onPressButton = (index:Number)=>{
        // CA_HRNAddScheduleM.changeSwitch(true);
        CA_HRNAddScheduleM.changeItem((error, events) => {      
            if (typeof events === 'object') {
                (this as any).setState(events);
            }
        });
        CA_HRNAddScheduleM.onItemIndex(index, {});
    }
    renderSeparator = ()=>{
        return (
            <View style={{height: 1, backgroundColor: '#EEEEEE'}}>
            </View>
        )
    };

    componentDidMount(){

        this.listener = calendarManagerEmitter.addListener(
            'getRNState',
            () => CA_HRNAddScheduleM.getRNState(this.state),
        );
    
    }

    componentWillUnmount() {
        this.listener && this.listener.remove();
    }
    

    render() {
        return (
            <SafeAreaView style={{backgroundColor: 'white',flex: 1,flexDirection:'column-reverse'}}> 
                <SectionList
                    sections={[
                        { title: 'Title1', data: [{icon: '开始时间', img: imgdata.startTime, state: this.state.start_time}, 
                                                  {icon: '结束时间',img: imgdata.endTime, state: this.state.end_time},
                                                  {icon:'参与人',img: imgdata.participate,state: this.state.user_list},
                                                  {icon:'提醒设置',img: imgdata.remind, state: this.state.remind_time_desc},
                                                  {icon:'隐私设置',img: imgdata.private,  state: this.state.privacy_typ}], renderItem: this.template1,},
                        { title: 'Title5', data: [{icon: '请输入地点', img: imgdata.locate, state: this.state.address}, 
                                                  {icon:'请输入内容',img: imgdata.typecontent,  state: this.state.content}
                                                 ], renderItem: this.template3}
                    ]}
                    keyExtractor={(item, index) => item + index}
                    contentContainerStyle={styles.list}
                    ItemSeparatorComponent={this.renderSeparator}
                    />
                    <View style={styles.templatetitleBox}>
                        <Image source={imgdata.templatetitle}/>
                        <TextInput
                            placeholder="请输入日程标题"
                            onChangeText={(title) => (this as any).setState({title})}
                            value={this.state.title}
                            style={styles.templateTitle} 
                            maxLength = {40}
                            // autoFocus = {true}
                        />
                    </View>
            </SafeAreaView>
        )
    }
}

  
export default AddTemplate