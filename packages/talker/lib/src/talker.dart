import 'dart:async';
import 'package:talker/talker.dart';

/// Talker - advanced exception handling and logging
/// for dart/flutter applications
class Talker implements TalkerInterface {
  /// {@template talker_constructor}
  /// Talker base constructor
  ///
  /// You can set your own [TalkerLogger] [logger] subclass
  /// (create your own class implements [TalkerLoggerInterface]),
  /// [TalkerLogger()] used by default
  ///
  /// You can edit package settings with [settings] [TalkerSettings],
  /// [TalkerSettings()] used by default
  ///
  /// You can set your own [TalkerLoggerSettings] [loggerSettings]
  /// to customize talker logs,
  ///
  /// You can set your own [TalkerLoggerFilter] [loggerFilter]
  /// to filter talker logs,
  ///
  /// You can set your own [LoggerFormater] [loggerFormater]
  /// to format output of talker logs,
  ///
  /// You can add your own observers to handle errors and logs in other place
  /// [List<TalkerObserver>] [observers],
  /// {@endtemplate}
  Talker({
    TalkerLogger? logger,
    TalkerSettings? settings,
    TalkerLoggerSettings? loggerSettings,
    TalkerLoggerFilter? loggerFilter,
    LoggerFormatter? loggerFormater,
    List<TalkerObserver>? observers,
  }) {
    _settings = settings ?? TalkerSettings();
    _logger = logger ??
        TalkerLogger().copyWith(
          settings: loggerSettings,
          filter: loggerFilter,
          formater: loggerFormater,
        );
    if (observers != null && observers.isNotEmpty) {
      _observersManager = TalkerObserversManager(observers);
    }
    _errorHandler = TalkerErrorHandler(_settings);
  }

  /// Fields can be setup in [configure()] method
  late TalkerSettings _settings;
  late TalkerLoggerInterface _logger;
  late TalkerErrorHandlerInterface _errorHandler;

  // final _fileManager = FileManager();
  final _history = <TalkerDataInterface>[];
  TalkerObserversManager? _observersManager;

  /// {@macro talker_configure}
  @override
  void configure({
    TalkerLogger? logger,
    TalkerSettings? settings,
    TalkerLoggerSettings? loggerSettings,
    TalkerLoggerFilter? loggerFilter,
    LoggerFormatter? loggerFormater,
    List<TalkerObserver>? observers,
  }) {
    if (settings != null) {
      _settings = settings;
    }

    if (observers != null && observers.isNotEmpty) {
      _observersManager = TalkerObserversManager(observers);
    }

    if (logger != null) {
      _logger = logger;
    } else {
      final currLogger = _logger as TalkerLogger;
      _logger = currLogger.copyWith(
        settings: loggerSettings,
        filter: loggerFilter,
        formater: loggerFormater,
      );
    }
  }

  final _talkerStreamController =
      StreamController<TalkerDataInterface>.broadcast();

  /// {@macro talker_stream}
  @override
  Stream<TalkerDataInterface> get stream =>
      _talkerStreamController.stream.asBroadcastStream();

  /// {@macro talker_history}
  @override
  List<TalkerDataInterface> get history => _history;

  /// {@macro talker_handle}
  @override
  void handle(
    Object exception, [
    StackTrace? stackTrace,
    dynamic msg,
  ]) {
    final data = _errorHandler.handle(exception, stackTrace, msg?.toString());
    if (data is TalkerError) {
      _observersManager?.onError(data);
      _handleErrorData(data);
      return;
    }
    if (data is TalkerException) {
      _observersManager?.onException(data);
      _handleErrorData(data);
      return;
    }
    if (data is TalkerLog) {
      _handleLogData(data);
    }
  }

  /// {@macro talker_handleError}
  @override
  void handleError(
    Error error, [
    StackTrace? stackTrace,
    dynamic msg,
  ]) {
    final data = TalkerError(
      error,
      stackTrace: stackTrace,
      message: msg?.toString(),
      logLevel: LogLevel.error,
    );
    _handleErrorData(data);
    if (_settings.enabled) {
      _observersManager?.onError(data);
    }
  }

  /// {@macro talker_handleException}
  @override
  void handleException(
    Exception exception, [
    StackTrace? stackTrace,
    dynamic msg,
    // ErrorLevel? errorLevel,
  ]) {
    final data = TalkerException(
      exception,
      stackTrace: stackTrace,
      message: msg?.toString(),
      logLevel: LogLevel.error,
    );
    _handleErrorData(data);
    if (_settings.enabled) {
      _observersManager?.onException(data);
    }
  }

  /// {@macro talker_log}
  @override
  void log(
    dynamic message, {
    LogLevel logLevel = LogLevel.debug,
    Object? exception,
    StackTrace? stackTrace,
    AnsiPen? pen,
  }) {
    _handleLog(message, exception, stackTrace, logLevel, pen: pen);
  }

  /// {@macro talker_log_typed}
  @override
  void logTyped(TalkerLog log, {LogLevel logLevel = LogLevel.debug}) {
    _handleLogData(log, logLevel: logLevel);
  }

  /// {@macro talker_critical_log}
  @override
  void critical(
    dynamic msg, [
    Object? exception,
    StackTrace? stackTrace,
  ]) {
    _handleLog(msg, exception, stackTrace, LogLevel.critical);
  }

  /// {@macro talker_debug_log}
  @override
  void debug(
    dynamic msg, [
    Object? exception,
    StackTrace? stackTrace,
  ]) {
    _handleLog(msg, exception, stackTrace, LogLevel.debug);
  }

  /// {@macro talker_error_log}
  @override
  void error(
    dynamic msg, [
    Object? exception,
    StackTrace? stackTrace,
  ]) {
    _handleLog(msg, exception, stackTrace, LogLevel.error);
  }

  /// {@macro talker_fine_log}
  @override
  void fine(
    dynamic msg, [
    Object? exception,
    StackTrace? stackTrace,
  ]) {
    _handleLog(msg, exception, stackTrace, LogLevel.fine);
  }

  /// {@macro talker_good_log}
  @override
  void good(
    dynamic msg, [
    Object? exception,
    StackTrace? stackTrace,
  ]) {
    _handleLog(msg, exception, stackTrace, LogLevel.good);
  }

  /// {@macro talker_info_log}
  @override
  void info(
    dynamic msg, [
    Object? exception,
    StackTrace? stackTrace,
  ]) {
    _handleLog(msg, exception, stackTrace, LogLevel.info);
  }

  /// {@macro talker_verbose_log}
  @override
  void verbose(
    dynamic msg, [
    Object? exception,
    StackTrace? stackTrace,
  ]) {
    _handleLog(msg, exception, stackTrace, LogLevel.verbose);
  }

  /// {@macro talker_warning_log}
  @override
  void warning(
    dynamic msg, [
    Object? exception,
    StackTrace? stackTrace,
  ]) {
    _handleLog(msg, exception, stackTrace, LogLevel.warning);
  }

  ///{@macro talker_clear_log_history}
  @override
  void cleanHistory() {
    if (_settings.useHistory) {
      _history.clear();
    }
  }

  ///{@macro talker_disable}
  @override
  void disable() {
    _settings.enabled = false;
  }

  ///{@macro talker_enable}
  @override
  void enable() {
    _settings.enabled = true;
  }

  void _handleLog(
    dynamic message,
    Object? exception,
    StackTrace? stackTrace,
    LogLevel logLevel, {
    AnsiPen? pen,
  }) {
    TalkerDataInterface? data;

    if (exception != null) {
      handle(exception, stackTrace, message);
      return;
    }

    data = TalkerLog(message?.toString() ?? '', logLevel: logLevel);
    _handleLogData(data as TalkerLog, pen: pen);
  }

  void _handleErrorData(TalkerDataInterface data) {
    if (_settings.enabled) {
      _talkerStreamController.add(data);
      _handleForOutputs(data);
      if (_settings.useConsoleLogs) {
        _logger.log(
          data.generateTextMessage(),
          level: data.logLevel ?? LogLevel.error,
        );
      }
    }
  }

  void _handleLogData(
    TalkerLog data, {
    AnsiPen? pen,
    LogLevel? logLevel,
  }) {
    if (_settings.enabled) {
      _observersManager?.onLog(data);
      _talkerStreamController.add(data);
      _handleForOutputs(data);
      if (_settings.useConsoleLogs) {
        _logger.log(
          data.generateTextMessage(),
          level: logLevel ?? data.logLevel,
          pen: data.pen ?? pen,
        );
      }
    }
  }

  void _handleForOutputs(TalkerDataInterface data) {
    _writeToHistory(data);
    // _writeToFile(data);
  }

  //TODO: recreate file manager logic
  // void _writeToFile(TalkerDataInterface data) {
  //   if (_settings.writeToFile) {
  //     _fileManager.writeToLogFile(data.generateTextMessage());
  //   }
  // }

  void _writeToHistory(TalkerDataInterface data) {
    if (_settings.useHistory && _settings.enabled) {
      if (_settings.maxHistoryItems <= _history.length) {
        _history.removeAt(0);
      }
      _history.add(data);
    }
  }
}
