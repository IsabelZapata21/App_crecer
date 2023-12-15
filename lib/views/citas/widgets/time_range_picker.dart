import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Future<TimeRange?> showTimeRangePicker({
  required BuildContext context,

  /// preselected start time
  TimeOfDay? start,

  /// preselected end time
  TimeOfDay? end,

  /// disabled time range (this time cannot be selected)
  List<TimeRange> disabledTime = const [],

  /// the color for the disabled section
  Color? disabledColor,

  /// Style of the arc (filled or stroke)
  PaintingStyle paintingStyle = PaintingStyle.stroke,

  /// if start time changed
  void Function(TimeOfDay)? onStartChange,

  /// if end time changed
  void Function(TimeOfDay)? onEndChange,

  /// Minimum time steps that can be selected
  Duration interval = const Duration(minutes: 5),

  /// label for start time
  String fromText = "From",

  /// label for end time
  String toText = "To",

  /// use 24 hours or am / pm
  bool use24HourFormat = true,

  /// the padding of the ring
  double padding = 36,

  /// the thickness of the ring
  double strokeWidth = 12,

  /// the color of the active arc from start time to end time
  Color? strokeColor,

  /// the radius of the handler to drag the arc
  double handlerRadius = 12,

  /// the color of a  handler
  Color? handlerColor,

  /// the color of a selected handler
  Color? selectedColor,

  /// the color of the circle outline
  Color? backgroundColor,

  /// a widget displayed in the background, use e.g. an image
  Widget? backgroundWidget,

  /// number of ticks displayed
  int ticks = 0,

  /// the offset for ticks
  double ticksOffset = 0,

  /// ticks length
  double? ticksLength,

  /// ticks thickness
  double ticksWidth = 1,

  /// Color of ticks
  Color ticksColor = Colors.white,

  /// Snap time bar to interval
  bool snap = false,

  /// Show labels around the circle (start at 0 hours)
  List<ClockLabel>? labels,

  /// Offset of the labels
  double labelOffset = 20,

  /// rotate labels
  bool rotateLabels = true,

  /// flip labels if the angle woulb be upside down (only if rotate labels is active)
  bool autoAdjustLabels = true,

  /// Style of the labels
  TextStyle? labelStyle,

  /// TextStyle of the time texts
  TextStyle? timeTextStyle,

  /// TextStyle of the currently moving time text
  TextStyle? activeTimeTextStyle,

  /// hide the time texts
  bool hideTimes = false,

  /// hide the button bar
  bool hideButtons = false,

  /// rotate the clock by angle
  double clockRotation = 0,

  /// maximum selectable duration
  Duration? maxDuration,
  Duration minDuration = const Duration(minutes: 30),
  TransitionBuilder? builder,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,

  /// barrierDismissible false = user must tap button!
  bool barrierDismissible = true,
}) async {
  assert(debugCheckHasMaterialLocalizations(context));

  final Widget dialog = Dialog(
      elevation: 12,
      child: TimeRangePicker(
        start: start,
        end: end,
        disabledTime: disabledTime,
        paintingStyle: paintingStyle,
        onStartChange: onStartChange,
        onEndChange: onEndChange,
        fromText: fromText,
        toText: toText,
        interval: interval,
        padding: padding,
        strokeWidth: strokeWidth,
        handlerRadius: handlerRadius,
        strokeColor: strokeColor,
        handlerColor: handlerColor,
        selectedColor: selectedColor,
        backgroundColor: backgroundColor,
        disabledColor: disabledColor,
        backgroundWidget: backgroundWidget,
        ticks: ticks,
        ticksLength: ticksLength,
        ticksWidth: ticksWidth,
        ticksOffset: ticksOffset,
        ticksColor: ticksColor,
        snap: snap,
        labels: labels,
        labelOffset: labelOffset,
        rotateLabels: rotateLabels,
        autoAdjustLabels: autoAdjustLabels,
        labelStyle: labelStyle,
        timeTextStyle: timeTextStyle,
        activeTimeTextStyle: activeTimeTextStyle,
        hideTimes: hideTimes,
        use24HourFormat: use24HourFormat,
        clockRotation: clockRotation,
        maxDuration: maxDuration,
        minDuration: minDuration,
      ));

  return await showDialog<TimeRange?>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: barrierDismissible,
    // user must tap button!
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    routeSettings: routeSettings,
  );
}

class TimeRangePicker extends StatefulWidget {
  final TimeOfDay? start;
  final TimeOfDay? end;

  final List<TimeRange> disabledTime;

  final void Function(TimeOfDay)? onStartChange;
  final void Function(TimeOfDay)? onEndChange;

  final Duration interval;

  final String toText;
  final String fromText;

  final double padding;
  final double strokeWidth;
  final double handlerRadius;
  final Color? strokeColor;
  final Color? handlerColor;
  final Color? selectedColor;
  final Color? backgroundColor;
  final Color? disabledColor;
  final PaintingStyle paintingStyle;

  final Widget? backgroundWidget;
  final int ticks;

  final double ticksOffset;

  final double ticksLength;

  final double ticksWidth;

  final Color ticksColor;
  final bool snap;

  final List<ClockLabel>? labels;
  final double labelOffset;
  final bool rotateLabels;
  final bool autoAdjustLabels;
  final TextStyle? labelStyle;

  final TextStyle? timeTextStyle;
  final TextStyle? activeTimeTextStyle;

  final bool hideTimes;
  final bool hideButtons;
  final bool use24HourFormat;
  final double clockRotation;
  final Duration? maxDuration;
  final Duration minDuration;

  TimeRangePicker({
    Key? key,
    this.start,
    this.end,
    this.disabledTime = const [],
    this.onStartChange,
    this.onEndChange,
    this.fromText = "From",
    this.toText = "To",
    this.interval = const Duration(minutes: 5),
    this.padding = 36,
    this.strokeWidth = 12,
    this.handlerRadius = 12,
    this.strokeColor,
    this.handlerColor,
    this.selectedColor,
    this.backgroundColor,
    this.disabledColor,
    this.paintingStyle = PaintingStyle.stroke,
    this.backgroundWidget,
    this.ticks = 0,
    ticksLength,
    this.ticksWidth = 1,
    this.ticksOffset = 0,
    this.ticksColor = Colors.white,
    this.snap = false,
    this.labels,
    this.labelOffset = 20,
    this.rotateLabels = true,
    this.autoAdjustLabels = true,
    this.labelStyle,
    this.timeTextStyle,
    this.activeTimeTextStyle,
    this.clockRotation = 0,
    this.maxDuration,
    this.minDuration = const Duration(minutes: 30),
    this.use24HourFormat = true,
    this.hideTimes = false,
    this.hideButtons = false,
  })  : ticksLength = ticksLength == null ? strokeWidth : 12,
        assert(interval.inSeconds <= minDuration.inSeconds,
            "interval must be smaller or same as min duration - adjust either one"),
        assert(
            interval.inSeconds < 24 * 60 * 60, "interval must be smaller 24h"),
        assert(minDuration.inSeconds < 24 * 60 * 60,
            " min duration must be smaller 24h"),
        super(key: key);

  @override
  TimeRangePickerState createState() => TimeRangePickerState();
}

class DisabledAngleTime {
  double? disabledStartAngle;
  double? disabledEndAngle;

  DisabledAngleTime(this.disabledStartAngle, this.disabledEndAngle);
}

class TimeRangePickerState extends State<TimeRangePicker>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  ActiveTime? _activeTime;
  double _startAngle = 0;
  double _endAngle = 0;

  final List<DisabledAngleTime> _disabledAngle = [];

  final GlobalKey _circleKey = GlobalKey();
  final GlobalKey _wrapperKey = GlobalKey();

  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  double _radius = 50;
  double _offsetRad = 0;

  @override
  void initState() {
    _offsetRad = (widget.clockRotation * pi / 180);

    WidgetsBinding.instance.addObserver(this);
    setAngles();
    WidgetsBinding.instance.addPostFrameCallback((_) => setRadius());

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) => setRadius());
  }

  setRadius() {
    RenderBox? wrapper =
        _wrapperKey.currentContext?.findRenderObject() as RenderBox?;
    if (wrapper != null) {
      setState(() {
        _radius =
            min(wrapper.size.width, wrapper.size.height) / 2 - (widget.padding);
      });
    }
  }

  void setAngles() {
    setState(() {
      var startTime = widget.start ?? TimeOfDay.now();
      var endTime = widget.end ??
          startTime.replacing(
              hour: startTime.hour < 21
                  ? startTime.hour + 3
                  : startTime.hour - 21);

      _startTime = _roundMinutes(startTime.hour * 60 + startTime.minute * 1.0);
      _startAngle = timeToAngle(_startTime, _offsetRad);
      _endTime = _roundMinutes(endTime.hour * 60 + endTime.minute * 1.0);

      if (widget.maxDuration != null) {
        var startDate =
            DateTime(2020, 1, 1, _startTime.hour, _startTime.minute);
        var endDate = DateTime(2020, 1, 1, _endTime.hour, _endTime.minute);
        var duration = endDate.difference(startDate);
        if (duration.inMinutes > widget.maxDuration!.inMinutes) {
          var maxDate = startDate.add(widget.maxDuration!);
          _endTime = TimeOfDay(hour: maxDate.hour, minute: maxDate.minute);
        }
      }

      _endAngle = timeToAngle(_endTime, _offsetRad);

      if (widget.disabledTime.isNotEmpty) {
        for (var disabledTime in widget.disabledTime) {
          _disabledAngle.add(DisabledAngleTime(
              timeToAngle(disabledTime.startTime, _offsetRad),
              timeToAngle(disabledTime.endTime, _offsetRad)));
        }
      }
    });
  }

  TimeOfDay _angleToTime(double angle) {
    angle = normalizeAngle(angle - pi / 2);
    double min = 24 * 60 * (angle) / (pi * 2);

    return _roundMinutes(min);
  }

  TimeOfDay _roundMinutes(double min) {
    int roundedMin =
        ((min / widget.interval.inMinutes).round() * widget.interval.inMinutes);

    int hours = (roundedMin / 60).floor();
    int minutes = (roundedMin % 60).round();
    return TimeOfDay(hour: hours, minute: minutes);
  }

  bool _panStart(PointerDownEvent ev) {
    bool isHandler = false;
    var globalPoint = ev.position;
    var snap = widget.handlerRadius * 2.5;
    RenderBox circle =
        _circleKey.currentContext!.findRenderObject() as RenderBox;

    CustomPaint customPaint = _circleKey.currentWidget as CustomPaint;
    ClockPainter _clockPainter = customPaint.painter as ClockPainter;

    if (_clockPainter.startHandlerPosition == null) {
      setState(() {
        _activeTime = ActiveTime.Start;
      });
      return false;
    }

    Offset globalStartOffset =
        circle.localToGlobal(_clockPainter.startHandlerPosition);
    if (globalPoint.dx < globalStartOffset.dx + snap &&
        globalPoint.dx > globalStartOffset.dx - snap &&
        globalPoint.dy < globalStartOffset.dy + snap &&
        globalPoint.dy > globalStartOffset.dy - snap) {
      setState(() {
        _activeTime = ActiveTime.Start;
      });
      isHandler = true;
    }

    if (_clockPainter.endHandlerPosition == null) {
      setState(() {
        _activeTime = ActiveTime.End;
      });
      return false;
    }

    Offset globalEndOffset =
        circle.localToGlobal(_clockPainter.endHandlerPosition);

    if (globalPoint.dx < globalEndOffset.dx + snap &&
        globalPoint.dx > globalEndOffset.dx - snap &&
        globalPoint.dy < globalEndOffset.dy + snap &&
        globalPoint.dy > globalEndOffset.dy - snap) {
      setState(() {
        _activeTime = ActiveTime.End;
      });
      isHandler = true;
    }

    return isHandler;
  }

  void _panUpdate(PointerMoveEvent ev) {
    if (_activeTime == null) return;
    RenderBox circle =
        _circleKey.currentContext!.findRenderObject() as RenderBox;
    final center = circle.size.center(Offset.zero);
    final point = circle.globalToLocal(ev.position);
    final touchPositionFromCenter = point - center;
    var dir = normalizeAngle(touchPositionFromCenter.direction);

    var minDurationSigned = durationToAngle(widget.minDuration);
    var minDurationAngle =
        minDurationSigned < 0 ? 2 * pi + minDurationSigned : minDurationSigned;
    //print("min duration angle " + (minDurationAngle * 180 / pi).toString());
    if (_activeTime == ActiveTime.Start) {
      var angleToEndSigned = signedAngle(_endAngle, dir);
      var angleToEnd =
          angleToEndSigned < 0 ? 2 * pi + angleToEndSigned : angleToEndSigned;

      //check if hitting disabled
      if (widget.disabledTime.isNotEmpty) {
        for (var disabledTime in _disabledAngle) {
          var angleToDisabledStart =
              signedAngle(disabledTime.disabledStartAngle!, dir);
          var angleToDisabledEnd =
              signedAngle(disabledTime.disabledEndAngle!, dir);

          var disabledAngleSigned = signedAngle(
              disabledTime.disabledEndAngle!, disabledTime.disabledStartAngle!);
          var disabledDiff = disabledAngleSigned < 0
              ? 2 * pi + disabledAngleSigned
              : disabledAngleSigned;

          //print("to disabled start " + (angleToDisabledStart * 180 / pi).toString());
          // print("to disabled end " + (angleToDisabledEnd * 180 / pi).toString());

          if (angleToDisabledStart - minDurationAngle < 0 &&
              angleToDisabledStart > -disabledDiff / 2) {
            dir = disabledTime.disabledStartAngle! - minDurationAngle;
            _updateTimeAndSnapAngle(
                ActiveTime.End, disabledTime.disabledStartAngle!);
          } else if (angleToDisabledEnd > 0 &&
              angleToDisabledEnd < disabledDiff / 2) {
            dir = disabledTime.disabledEndAngle!;
          }
        }
      }

      // if after end time -> push end time ahead
      if (angleToEnd > 0 && angleToEnd < minDurationAngle) {
        var angle = dir + minDurationAngle;
        _updateTimeAndSnapAngle(ActiveTime.End, angle);
      }

      //check end time
      if (widget.maxDuration != null) {
        var startSigned = signedAngle(_endAngle, dir);
        var startDiff = startSigned < 0 ? 2 * pi + startSigned : startSigned;
        var maxSigned = durationToAngle(widget.maxDuration!);
        var maxDiff = maxSigned < 0 ? 2 * pi + maxSigned : maxSigned;
        if (startDiff > maxDiff) {
          var angle = dir + maxSigned;
          _updateTimeAndSnapAngle(ActiveTime.End, angle);
        }
      }
    } else {
      var angleToStartSigned = signedAngle(dir, _startAngle);
      var angleToStart = angleToStartSigned < 0
          ? 2 * pi + angleToStartSigned
          : angleToStartSigned;

      //check if hitting disabled
      if (widget.disabledTime.isNotEmpty) {
        for (var disabledTime in _disabledAngle) {
          var angleToDisabledStart =
              signedAngle(disabledTime.disabledStartAngle!, dir);
          var angleToDisabledEnd =
              signedAngle(disabledTime.disabledEndAngle!, dir);
          var disabledAngleSigned = signedAngle(
              disabledTime.disabledEndAngle!, disabledTime.disabledStartAngle!);
          var disabledDiff = disabledAngleSigned < 0
              ? 2 * pi + disabledAngleSigned
              : disabledAngleSigned;

          //print("to disabled start " + (angleToDisabledStart * 180 / pi).toString());
          //print("to disabled end " + (angleToDisabledEnd * 180 / pi).toString());

          //print("disabled diff " + (disabledDiff * 180 / pi).toString());

          if (angleToDisabledStart < 0 &&
              angleToDisabledStart > -disabledDiff / 2) {
            dir = disabledTime.disabledStartAngle!;
          } else if (angleToDisabledEnd + minDurationAngle > 0 &&
              angleToDisabledEnd < disabledDiff / 2) {
            dir = disabledTime.disabledEndAngle! + minDurationAngle;
            _updateTimeAndSnapAngle(
                ActiveTime.Start, disabledTime.disabledEndAngle!);
          }
        }
      }

      // if before start time -> push start time ahead
      if (angleToStart > 0 && angleToStart < minDurationAngle) {
        var angle = dir - minDurationAngle;
        _updateTimeAndSnapAngle(ActiveTime.Start, angle);
      }

      //check end time
      if (widget.maxDuration != null) {
        var endSigned = signedAngle(dir, _startAngle);
        var endDiff = endSigned < 0 ? 2 * pi + endSigned : endSigned;
        var maxSigned = durationToAngle(widget.maxDuration!);
        var maxDiff = maxSigned < 0 ? 2 * pi + maxSigned : maxSigned;
        if (endDiff > maxDiff) {
          var angle = dir - maxSigned;
          _updateTimeAndSnapAngle(ActiveTime.Start, angle);
        }
      }
    }

    _updateTimeAndSnapAngle(_activeTime!, dir);
  }

  _updateTimeAndSnapAngle(ActiveTime type, double angle) {
    var time = _angleToTime(angle - _offsetRad);

    //24 => 0
    if (time.hour == 24) time = TimeOfDay(hour: 0, minute: time.minute);

    // snap to interval
    final snapped =
        widget.snap == true ? timeToAngle(time, -_offsetRad) : angle;

    if (type == ActiveTime.Start) {
      setState(() {
        _startAngle = snapped;
        _startTime = time;
      });
      if (widget.onStartChange != null) {
        widget.onStartChange!(_startTime);
      }
    } else {
      setState(() {
        _endAngle = snapped;
        _endTime = time;
      });
      if (widget.onEndChange != null) {
        widget.onEndChange!(_endTime);
      }
    }
  }

  bool isBetweenAngle(double min, double max, double targetAngle) {
    var normalisedMin = min >= 0 ? min : 2 * pi + min;
    var normalisedMax = max >= 0 ? max : 2 * pi + max;
    var normalisedTarget =
        targetAngle >= 0 ? targetAngle : 2 * pi + targetAngle;

    return normalisedMin <= normalisedTarget &&
        normalisedTarget <= normalisedMax;
  }

  void _panEnd(PointerUpEvent ev) {
    setState(() {
      _activeTime = null;
    });
  }

  _submit() {
    Navigator.of(context)
        .pop(TimeRange(startTime: _startTime, endTime: _endTime));
  }

  _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);

    return OrientationBuilder(
      builder: (_, orientation) => orientation == Orientation.portrait
          ? Column(
              key: _wrapperKey,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (!widget.hideTimes) buildHeader(false),
                Stack(
                    //fit: StackFit.loose,
                    alignment: Alignment.center,
                    children: [
                      if (widget.backgroundWidget != null)
                        widget.backgroundWidget!,
                      buildTimeRange(
                          localizations: localizations, themeData: themeData)
                    ]),
                if (!widget.hideButtons)
                  buildButtonBar(localizations: localizations)
              ],
            )
          : Row(
              children: [
                if (!widget.hideTimes) buildHeader(true),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          key: _wrapperKey,
                          width: double.infinity,
                          child: Stack(alignment: Alignment.center, children: [
                            if (widget.backgroundWidget != null)
                              widget.backgroundWidget!,
                            buildTimeRange(
                                localizations: localizations,
                                themeData: themeData)
                          ]),
                        ),
                      ),
                      if (!widget.hideButtons)
                        buildButtonBar(localizations: localizations)
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildButtonBar({required MaterialLocalizations localizations}) =>
      ButtonBar(
        children: <Widget>[
          TextButton(
            child: Text(localizations.cancelButtonLabel),
            onPressed: _cancel,
          ),
          TextButton(
            child: Text(localizations.okButtonLabel),
            onPressed: _submit,
          ),
        ],
      );

  Widget buildTimeRange(
          {required MaterialLocalizations localizations,
          required ThemeData themeData}) =>
      RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          ClockGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<ClockGestureRecognizer>(
            () => ClockGestureRecognizer(
                panStart: _panStart, panUpdate: _panUpdate, panEnd: _panEnd),
            (ClockGestureRecognizer instance) {},
          ),
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: Colors.white.withOpacity(0),
            child: Center(
              child: CustomPaint(
                key: _circleKey,
                painter: ClockPainter(
                    activeTime: _activeTime,
                    startAngle: _startAngle,
                    endAngle: _endAngle,
                    disabledAngles: _disabledAngle,
                    radius: _radius,
                    strokeWidth: widget.strokeWidth,
                    handlerRadius: widget.handlerRadius,
                    strokeColor: widget.strokeColor ?? themeData.primaryColor,
                    handlerColor: widget.handlerColor ?? themeData.primaryColor,
                    selectedColor:
                        widget.selectedColor ?? themeData.primaryColorLight,
                    backgroundColor:
                        widget.backgroundColor ?? Colors.grey.withOpacity(0.3),
                    disabledColor:
                        widget.disabledColor ?? Colors.red.withOpacity(0.5),
                    paintingStyle: widget.paintingStyle,
                    ticks: widget.ticks,
                    ticksColor: widget.ticksColor,
                    ticksLength: widget.ticksLength,
                    ticksWidth: widget.ticksWidth,
                    ticksOffset: widget.ticksOffset,
                    labels: widget.labels ?? <ClockLabel>[],
                    labelStyle:
                        widget.labelStyle ?? themeData.textTheme.bodyText1,
                    labelOffset: widget.labelOffset,
                    rotateLabels: widget.rotateLabels,
                    autoAdjustLabels: widget.autoAdjustLabels,
                    offsetRad: _offsetRad),
                size: Size.fromRadius(_radius),
              ),
            ),
          ),
        ),
      );

  Widget buildHeader(bool landscape) {
    final ThemeData themeData = Theme.of(context);

    Color backgroundColor;
    switch (themeData.brightness) {
      case Brightness.light:
        backgroundColor = themeData.primaryColor;
        break;
      case Brightness.dark:
        backgroundColor = themeData.backgroundColor;
        break;
    }

    Color activeColor;
    Color inactiveColor;
    switch (ThemeData.estimateBrightnessForColor(themeData.primaryColor)) {
      case Brightness.light:
        activeColor = Colors.black87;
        inactiveColor = Colors.black54;
        break;
      case Brightness.dark:
        activeColor = Colors.white;
        inactiveColor = Colors.white70;
        break;
    }

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.all(24),
      child: Flex(
        direction: landscape ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(widget.fromText, style: TextStyle(color: activeColor)),
              Text(
                MaterialLocalizations.of(context).formatTimeOfDay(_startTime,
                    alwaysUse24HourFormat: widget.use24HourFormat),
                style: _activeTime == ActiveTime.Start
                    ? widget.activeTimeTextStyle ??
                        TextStyle(
                            color: activeColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)
                    : widget.timeTextStyle ??
                        TextStyle(
                            color: inactiveColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(children: [
            Text(widget.toText, style: TextStyle(color: activeColor)),
            Text(
              MaterialLocalizations.of(context).formatTimeOfDay(_endTime,
                  alwaysUse24HourFormat: widget.use24HourFormat),
              style: _activeTime == ActiveTime.End
                  ? widget.activeTimeTextStyle ??
                      TextStyle(
                          color: activeColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)
                  : widget.timeTextStyle ??
                      TextStyle(
                          color: inactiveColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
            ),
          ])
        ],
      ),
    );
  }
}
////////////////////////////////////////////////////////////

//normalize angle
double normalizeAngle(double radians) {
  var normalized = atan2(sin(radians), cos(radians));
  normalized = normalized > 0 ? normalized : 2 * pi + normalized;
  return normalized;
}

//convert a time to the correct angle of the clock
double timeToAngle(TimeOfDay time, double offsetRad) {
  int min = time.hour * 60 + time.minute;
  double angle = min * pi * 2 / 60 / 24;
  return normalizeAngle(angle + pi / 2 + offsetRad);
}

//

//get signed Angle between two rad
double signedAngle(double startAngle, double targetAngle) {
  //return (startAngle - targetAngle).abs() % 360;
  return atan2(sin(startAngle - targetAngle), cos(startAngle - targetAngle));
}

double durationToAngle(Duration duration) {
  var min = duration.inMinutes;
  var time = TimeOfDay(hour: min ~/ 60, minute: min % 60);

  return signedAngle(timeToAngle(time, 0), pi / 2);
}

enum ActiveTime { Start, End }

class TimeRange {
  TimeOfDay startTime;
  TimeOfDay endTime;

  TimeRange({required this.startTime, required this.endTime});

  String toString() {
    return "Start: ${startTime.toString()} to ${endTime.toString()}";
  }
}

class ClockLabel {
  double angle;
  String text;

  ClockLabel({required this.angle, required this.text});

  factory ClockLabel.fromDegree({required double deg, required String text}) {
    return ClockLabel(angle: deg * pi / 180, text: text);
  }

  factory ClockLabel.fromTime({required TimeOfDay time, required String text}) {
    double angle = timeToAngle(time, 0);

    return ClockLabel(angle: angle, text: text);
  }

  factory ClockLabel.fromIndex(
      {required int idx, required int length, required String text}) {
    double angle = (2 * pi / length) * idx + pi / 2;

    return ClockLabel(angle: angle, text: text);
  }
}

///////////////////////////////////////////////////////

class ClockPainter extends CustomPainter {
  double? startAngle;
  double? endAngle;

  List<DisabledAngleTime> disabledAngles;
  ActiveTime? activeTime;

  double radius;

  double strokeWidth;
  double handlerRadius;
  Color strokeColor;
  Color handlerColor;
  Color selectedColor;
  Color backgroundColor;
  Color disabledColor;
  PaintingStyle paintingStyle;

  Offset? _startHandlerPosition;
  Offset? _endHandlerPosition;
  late TextPainter _textPainter;

  int? ticks;
  double ticksOffset;
  double ticksLength;
  double ticksWidth;
  Color ticksColor;
  List<ClockLabel> labels;
  TextStyle? labelStyle;
  double labelOffset;
  bool rotateLabels;
  bool autoAdjustLabels;

  double offsetRad;
  get startHandlerPosition {
    return _startHandlerPosition;
  }

  get endHandlerPosition {
    return _endHandlerPosition;
  }

  ClockPainter({
    this.startAngle,
    this.endAngle,
    this.disabledAngles = const [],
    this.activeTime,
    required this.radius,
    required this.strokeWidth,
    required this.handlerRadius,
    required this.strokeColor,
    required this.handlerColor,
    required this.selectedColor,
    required this.backgroundColor,
    required this.disabledColor,
    required this.paintingStyle,
    required this.ticks,
    required this.ticksOffset,
    required this.ticksLength,
    required this.ticksWidth,
    required this.ticksColor,
    required this.labels,
    this.labelStyle,
    required this.labelOffset,
    required this.rotateLabels,
    required this.autoAdjustLabels,
    required this.offsetRad,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = paintingStyle
      ..strokeWidth = strokeWidth
      ..color = backgroundColor
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = true;

    var rect = Rect.fromLTRB(0, 0, radius * 2, radius * 2);

    canvas.drawCircle(rect.center, radius, paint);

    if (disabledAngles.isNotEmpty) {
      for (var element in disabledAngles) {
        if (element.disabledStartAngle != null && element.disabledEndAngle != null) {
          paint.color = disabledColor;
          var start = normalizeAngle(element.disabledStartAngle!);
          var end = normalizeAngle(element.disabledEndAngle!);
          var sweep = calcSweepAngle(start, end);

          canvas.drawArc(
              rect, start, sweep, paintingStyle == PaintingStyle.fill, paint);
        }
      }
    }

    drawTicks(
      paint,
      canvas,
    );

    paint.color = strokeColor;
    paint.strokeWidth = strokeWidth;
    if (startAngle != null && endAngle != null) {
      var start = normalizeAngle(startAngle!);
      var end = normalizeAngle(endAngle!);
      var sweep = calcSweepAngle(start, end);

      canvas.drawArc(
          rect, start, sweep, paintingStyle == PaintingStyle.fill, paint);

      drawHandler(paint, canvas, ActiveTime.Start, start);
      drawHandler(paint, canvas, ActiveTime.End, end);
    }

    drawLabels(
      paint,
      canvas,
    );

    canvas.save();
    canvas.restore();
  }

  void drawHandler(Paint paint, Canvas canvas, ActiveTime type, double angle) {
    paint.style = PaintingStyle.fill;
    paint.color = handlerColor;
    if (activeTime == type) {
      paint.color = selectedColor;
    }

    Offset handlerPosition = calcCoords(radius, radius, angle, radius);
    canvas.drawCircle(handlerPosition, handlerRadius, paint);

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawCircle(handlerPosition, handlerRadius * 1.5, paint);

    if (type == ActiveTime.Start)
      _startHandlerPosition = handlerPosition;
    else
      _endHandlerPosition = handlerPosition;
  }

  void drawTicks(
    Paint paint,
    Canvas canvas,
  ) {
    var r = radius + ticksOffset - strokeWidth / 2;
    paint.color = ticksColor;
    paint.strokeWidth = ticksWidth;
    List.generate(ticks!, (i) => i + 1).forEach((i) {
      double angle = (360 / ticks!) * i * pi / 180 + offsetRad;
      canvas.drawLine(calcCoords(radius, radius, angle, r),
          calcCoords(radius, radius, angle, r + ticksLength), paint);
    });
  }

  void drawLabels(
    Paint paint,
    Canvas canvas,
  ) {
    labels.forEach((label) {
      drawText(
          canvas,
          paint,
          label.text,
          calcCoords(
              radius, radius, label.angle + offsetRad, radius + labelOffset),
          label.angle + offsetRad);
    });
  }

  void drawText(
      Canvas canvas, Paint paint, String text, Offset position, double angle) {
    angle = normalizeAngle(angle);

    TextSpan span = new TextSpan(
      text: text,
      style: labelStyle,
    );
    _textPainter = new TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    _textPainter.layout();
    Offset drawCenter =
        Offset(-(_textPainter.width / 2), -(_textPainter.height / 2));

    if (rotateLabels) {
      bool flipLabel = false;
      if (autoAdjustLabels) {
        if (angle > 0 && angle < pi) {
          flipLabel = true;
        }
      }

      // get the width of the word
      var wordWidth = _textPainter.width;

      //the total distance from center of circle
      var dist = (radius + labelOffset);

      // accumulat the offset of the letter within the word
      double lengthOffset = 0;

      // if flip, reverse letter order
      var chars = !flipLabel ? text.runes : text.runes.toList().reversed;

      chars.forEach((char) {
        // put char to textpainter
        prepareTextPainter(String.fromCharCode(char));

        // the angle where the letter appears on the circle
        final double curveAngle = angle - (wordWidth / 2 - lengthOffset) / dist;

        double letterAngle = curveAngle + pi / 2;

        // flip 180°
        if (flipLabel) letterAngle = letterAngle + pi;

        // the position of the letter on the circle
        final Offset letterPos = calcCoords(radius, radius, curveAngle, dist);

        // adjust alignment of the letter (vertically centered)
        drawCenter = Offset(
            flipLabel ? -_textPainter.width : 0, -(_textPainter.height / 2));

        //move canvas to letter position
        canvas.translate(letterPos.dx, letterPos.dy);

        //rotate canvas to letter rotation
        canvas.rotate(letterAngle);

        // paint letter
        _textPainter.paint(canvas, drawCenter);

        //undo movements
        canvas.rotate(-letterAngle);
        canvas.translate(-letterPos.dx, -letterPos.dy);

        //increase letter offset
        lengthOffset += _textPainter.width;
      });
    } else {
      _textPainter.paint(canvas, position + drawCenter);
    }
  }

  /// Calculates width and central angle for the provided [letter].
  void prepareTextPainter(String letter) {
    _textPainter.text = TextSpan(text: letter, style: labelStyle);
    _textPainter.layout();
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) => true;

  /// get the position on the circle for certain [angle]
  Offset calcCoords(double cx, double cy, double angle, double radius) {
    double x = cx + radius * cos(angle);
    double y = cy + radius * sin(angle);
    return Offset(x, y);
  }

  double calcSweepAngle(double init, double end) {
    if (end > init) {
      return end - init;
    } else
      return 2 * pi - (end - init).abs();
  }
}

///////////////////////////////////////////////////////////

class ClockGestureRecognizer extends OneSequenceGestureRecognizer {
  final Function panStart;
  final Function panUpdate;
  final Function panEnd;

  ClockGestureRecognizer(
      {required this.panStart, required this.panUpdate, required this.panEnd});

  @override
  void addPointer(PointerEvent event) {
    if (panStart(event)) {
      startTrackingPointer(event.pointer);
      resolve(GestureDisposition.accepted);
    } else {
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      panUpdate(event);
    }
    if (event is PointerUpEvent) {
      panEnd(event);
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  String get debugDescription => 'customPan';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
