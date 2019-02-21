import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View} from 'react-native';
import RootRoutes from './src/navigation/root1'

export default class App extends Component {
  render() {
    return (
        <RootRoutes/>
    );
  }
}
