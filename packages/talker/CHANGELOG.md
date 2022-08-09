## 1.1.0
talker_logger updates:
- **FEAT**: Implement ExtendedLoggerFormatter
- **FEAT**: Upgrade ColoredLoggerFormatter
- **FIX**: Typo Formater -> Formatter

## 1.0.0
First stable release! 🎉

## 0.12.0
  - **FEAT**: Change message field type from String to dynamic<br>for all log [error(),critical(),info(),fine(),good(),debug(),verbose(),warning()] methos and handle [handle(), handleError(), hanldeException()] methods

## 0.11.0
  - **FIX** Fix filter
  - **FIX** Refactor package base
  - **INFO** Make 100% tests coverage
  - **INFO** Update README.md

## 0.10.0
  - **BREAKING** Remove field registeredTypes
  - **FIX** Fix history bug
  - **FIX** Disable writeToFile in settings for first stable release
  - **INFO** Update example and add some new tests

## 0.9.1
  - **FIX** Make self DateTime formating
  - **FIX** Delete intl package

## 0.9.0
  - **BREAKING** Create common Talker constructor
  - **BREAKING** After this version Talker is not singleton class 
  - **FEAT** Now you can create a lot of Talker instances for you app
  - **FEAT** Now ***configure()*** method is not async

## 0.8.1
- **talker_logger** update to 0.8.0 version
- talker_logger changes:
  - **INFO**: Create README with documentation and examples
  - **FIX**: Rename and refactor internal code
  - **INFO**: Add all public entities docs
  - **FIX**: Remove lineSymbol and maxLineWidth field from LogDetails

## 0.8.0
- **FEAT** Add enable and disable methods for Talker

## 0.7.1
- **FEAT** Add logger settings, filter, formater fields to configure talker method

## 0.7.0
- **BREAKING** Remove talker_error_handler package from talker deps
- **BREAKING** Rewrite error handler on talker package base
- **BREAKING** Update handle error / exceptions methods

## 0.6.1
- **BREAKING** Remove TalkerDataInterface, 
TalkerLog, TalkerError, TalkerException field additional data
    

## 0.6.0
- Implement filter for logs

## 0.5.2
- Add title for default models

## 0.5.1
- Fix README images urls

## 0.5.0
- Add all docs
- Update core packages versions to 0.5.0
- Fix package issues

## 0.4.0
- Add logTyped method
- Add documentation
- Updated settings and working

## 0.3.0
- Update settings cnfiguration
- Update internal logic
- Update internal packages

## 0.2.8
- Add useConsoleLogs settings field

## 0.2.7
- Update logger version

## 0.2.6
- Add AnsiPen customization for log method

## 0.2.5
- Update observer model

## 0.2.4
- Implement simple log methods

## 0.2.3
- Fix default (null) errorLevel -> logLevel

## 0.2.2
- Fix error_handler version

## 0.2.1
- Fix nested packages

## 0.2.0
- Simplified package api
- Fix Talker lazy configuration

## 0.1.0

- Initial version.
