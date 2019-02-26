import React from 'react'
import {
    Text,
    View,
    Image,
    Button,
    TextInput,
    StyleSheet,
} from 'react-native'

export class Template1 extends React.Component{
    render() {
        return (
            <View>
                <TextInput
                    placeholder="请输入日程标题"
                />
            </View>
        )
    }
}

// export  class Template2 extends React.Component{
//     render() {
//         return (
//             <View>
//                 <Image source={require('../img/setting_time_icon.png')}/>
//                 <Text></Text>
//                 <Image source={require('../img/icons_details4.png')}/>
//             </View>
//         )
//     }
// }

export  class Template3 extends React.Component{
    render() {
        return (
            <View>
                <Image source={require('../img/setting_time_icon.png')}/>
                <Text></Text>
                <Text>公开-所有人可见</Text>
                <Image source={require('../img/icons_details4.png')}/>
            </View>
        )
    }
}

export  class Template4 extends React.Component{
    render() {
        return (
            <View>
                <Image source={require('../img/setting_time_icon.png')}/>
                <TextInput/>
            </View>
        )
    }
}

// const styles: any = StyleSheet.create({
   
// });