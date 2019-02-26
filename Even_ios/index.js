/** @format */

import {AppRegistry} from 'react-native';
// import App from './App';
import {addName, detailName} from './app.json';

import AddTemplate from './src/AddTemplate/index.tsx'
import TemplateDetails from './src/TemplateDetails/index.tsx'

AppRegistry.registerComponent(addName, () => AddTemplate);
AppRegistry.registerComponent(detailName, () => TemplateDetails);
