import { 
    StyleSheet
} from 'react-native';

const styles: any = StyleSheet.create({
    templatetitleBox: {
        paddingLeft: 20,
        paddingTop: 4,
        paddingBottom: 15,
        alignItems: 'center',
        shadowOffset:{w:0, h:0},
        backgroundColor: 'white',
        shadowOpacity: 0.5,
        shadowColor:'#CCCCCC',
        flexDirection: 'row',
    },
    templateTitle: {
        fontSize: 18,
        fontWeight: 'bold',
        paddingLeft: 16,
        paddingRight: 20,
        lineHeight: 25,
        color: '#444444',
        fontFamily: 'PingFangSC-Medium',
        flexGrow: 1,
        flexShrink: 1,
    },
    list:{
        backgroundColor: 'white',
        justifyContent: 'center',
        flexDirection: 'column',
        // paddingLeft: 20,
        // paddingRight: 20,
        borderBottomWidth: 1,
        borderBottomColor: '#EEEEEE',
    },
    participate: {
        // borderWidth: 5,
        // borderColor: 'white',
        width: 30,
        height: 30, 
        borderRadius: 15
    },
    listitem: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingTop: 15,
        paddingBottom: 15,
        paddingLeft: 20,
        paddingRight: 20,
        flexWrap: 'nowrap',
    },
    listitemLeft: {
        flexDirection: 'row',
        alignItems: 'center',
        flexShrink: 1,
    },
    all: {
        fontSize: 12, 
        lineHeight: 17, 
        color: '#999999'
    },
    icon: {
        width: 24,
        height: 24,
        marginRight: 14,
    },
    text: {
        fontSize: 16,
        fontWeight: '400',
        // lineHeight: 22,
        alignItems: 'center',
        color: '#999999',
        fontFamily: 'PingFangSC-Regular',
        flexWrap: 'wrap',
        flexShrink: 1,
    },
    text1: {
        fontSize: 16,
        fontWeight: '400',
        // lineHeight: 22,
        alignItems: 'center',
        color: '#444444',
        fontFamily: 'PingFangSC-Regular',
    },
    restNumBox: {
        width: 30,
        height: 30, 
        borderRadius: 15,
        backgroundColor: '#5E69C7',
        justifyContent: 'center',
        alignItems: 'center',
    },
    restNum: {
        fontSize:12,
        fontFamily:'PingFangSC-Semibold',
        fontWeight:'600',
        color: '#FFFFFF'
    },
    next: {
        width: 14,
        height: 14,
        marginRight: 0,
    }
})

export default styles;