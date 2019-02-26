import {StyleSheet} from 'react-native'

const styles: any = StyleSheet.create({
    // 公共样式
    row: {
        flexDirection: 'row'
    },
    nowrap: {
        flexWrap: 'nowrap'
    },
    shadow_ccc: {
        shadowOffset:{w:0, h:0},
        backgroundColor: 'white',
        shadowOpacity: 0.5,
        shadowColor:'#CCCCCC',
    },
    pa20_mar0: {
        paddingLeft: 20,
        paddingRight: 20,
        marginLeft: 0,
        marginRight: 0,
    },
    mar20_pa0: {
        paddingLeft: 0,
        paddingRight: 0,
        marginLeft: 20,
        marginRight: 20,
    },
    listitem: {
        alignItems: 'flex-start',
        flexDirection: 'row',
        borderBottomColor: '#EEEEEE',
        borderBottomWidth: 1,
        flexWrap: 'nowrap',
    },
    listitem1: {
        shadowOffset:{w:0, h:0},
        backgroundColor: 'white',
        shadowOpacity: 0.5,
        shadowColor:'#CCCCCC',
        flexDirection: 'row', 
        alignItems: 'flex-start',
    },
    listitem3: {
        borderBottomColor: '#FAFAFA',
        borderBottomWidth: 20,
        // height: 80,
    },
    img: {
        width: 24,
        height: 24,
        marginRight: 16,
        marginTop: 14,
    },
    text: {
        fontFamily: 'PingFangSC-Regular',
        fontSize: 16,
        lineHeight: 26,
        color: '#444444',
        flexShrink: 1,
        marginTop: 15,
        marginBottom: 17,
    }, 
    showBtnText: {
        fontSize: 12,
        fontFamily: 'PingFangSC-Regular',
        fontWeight: '400',
        color: 'rgba(153,153,153,1)',
        lineHeight: 17,
    },
    showBtnIcon: {
        width: 10,
        height: 10,
        marginLeft: 3,
    },
    text1: {
        fontFamily: 'PingFangSC-Medium',
        fontSize: 18,
        lineHeight: 28,
        flexShrink: 1,
        marginTop: 14,
        marginBottom: 15,
    },
    imgView:{
        flexDirection: 'row', 
        alignItems: 'flex-start',
        flexWrap: 'wrap',
        flexShrink: 1,
        // marginTop: 11,
        marginBottom: 13,
    },
    user:{
        width: 30,
        height: 30, 
        borderRadius: 15,
        marginRight: 5,
        marginTop: 11,
    },
    footer:{
        paddingLeft: 20,
        paddingRight: 20,
        marginBottom: 60,
        marginTop: 14,
    },
    footeritem: {
        paddingLeft: 10,
        flexDirection: 'row',
        alignItems: 'flex-start',
        marginTop: 5,
        marginBottom: 5,
    },
    foottext1:{
        fontSize: 12,
        lineHeight: 17,
        color: '#999999',
        marginLeft: 19,
    },
    dot:{
        width: 5,
        height: 5,
        backgroundColor: '#D8D8D8',
        borderRadius: 2.5,
        marginTop:6,
    },
})

export default styles