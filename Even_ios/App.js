import React from 'react'

// import { NativeModules } from "react-native";


// import {
//    View,
//    Text,
// } from 'react-native';

// const CA_HRNAddScheduleM = NativeModules.CA_HRNAddScheduleM;
// CA_HRNAddScheduleM.addEvent("Birthday Party", "4 Privet Drive, Surrey");
// js引入ts需要把后面的.tsx写出来
import AddTemplate from './src/AddTemplate/index.tsx'
import TemplateDetails from './src/TemplateDetails/index.tsx'

export default class App extends React.Component {
  
  render() {
    return (
      // <View>
        // <AddTemplate/>
        <TemplateDetails/>
      // </View>
    )
  }
}