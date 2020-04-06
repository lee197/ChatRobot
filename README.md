# ChatRobot
button-only conversation with a robot

## Branches:
* master - stable app releases
* develop - development branch, merge features branches here

## API:
* https://github.com/lee197/MeteoriteRecordApp/blob/master/MeteoriteRecordApp/ApiTestData.json

## Dependencies:
The project didn't use any pod for managing external libraries and a Gemfile for managing the cocoapods version.

## Project structure:
* ChatViewModel: viewmodel objects
* ChatModel: model objects
* Data Service: contains API json file
* ChatView: ViewController, Tableview and Collectionview cells
* Processor: Include different types to algorithm to process data

## Next step:
* Improve the algorithm efficiency in ChatInfoProcessor
* Use advanced Autolayout code to adjust the user input view to be more flexible 
