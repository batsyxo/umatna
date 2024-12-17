// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jhijri/jHijri.dart';

class Event {
  final String title;
  final DateTime dateTime;
  final String location;
  final String description;

  Event({
    required this.title,
    required this.dateTime,
    required this.location,
    required this.description,
  });
}

class IslamicEvent {
  final String name;
  final DateTime date;

  IslamicEvent({required this.name, required this.date});
}

class Calendar {
  final String name;
  final List<Event> events;

  Calendar({required this.name, required this.events});
}

class Customcalendardart extends StatefulWidget {
  const Customcalendardart({super.key});

  @override
  State<Customcalendardart> createState() => _CustomcalendardartState();
}

class _CustomcalendardartState extends State<Customcalendardart>
    with SingleTickerProviderStateMixin {
  // Define your variables
  bool _datesSwapped = false;
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedWeekDate = DateTime.now();
  bool _isSearching = false;
  bool _shareWithFriends = false;
  final TextEditingController _searchController = TextEditingController();
  final Color primaryGreen = Color(0xFF006400);
  final Color islamicEventColor = Colors.brown;

  List<bool> _eventChecked = [];
  List<bool> _eventShared = [];
  List<int> _eventAttendees = [];

  // List of your own events
  List<Event> myEvents = [
    Event(
        title: "Project Meeting",
        dateTime: DateTime(2024, 11, 25),
        location: "Office",
        description: "Discussion on project progress."),
    Event(
        title: "Doctor's Appointment",
        dateTime: DateTime(2024, 11, 30),
        location: "Clinic",
        description: "Routine checkup."),
  ];

  List<Calendar> friendCalendars = [
    Calendar(
      name: "Hamilton Mountain Masjid",
      events: [
        Event(
            title: "Special Guest Lecture",
            dateTime: DateTime(2024, 11, 24),
            location: "Hamilton Moutain Masjid",
            description: "Sheikh Hussam."),
        Event(
            title: "Youth Event",
            dateTime: DateTime(2024, 11, 27),
            location: "Hamilton Mountain Masjid",
            description: "Youth event."),
      ],
    ),
    Calendar(
      name: "Hajar Ahmad",
      events: [
        Event(
            title: "Sleepover",
            dateTime: DateTime(2024, 11, 29),
            location: "my house",
            description: "pizza and snacks."),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialization code from the first initState
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 1) {
          _focusedWeekDate = _selectedDate;
        }
      });
    });

    // Initialize _selectedDate to midnight to avoid time comparison issues
    _selectedDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // Initialize events
    _initializeEvents();

    // Generate and add Islamic events to the calendar
    _addIslamicEvents();

    // Initialization code from the second initState (if any)
    _datesSwapped = false; // Ensure this is included
  }

void _initializeEvents() {
  // Initialize lists with the length of the current events
  _eventChecked = List.generate(myEvents.length, (index) => false);
  _eventShared = List.generate(myEvents.length, (index) => false);
  _eventAttendees = List.generate(myEvents.length, (index) => index + 1);

  // Add default daily prayer times
  _addDefaultPrayerTimes();
}

void _addDefaultPrayerTimes() {
  final DateTime today = DateTime.now();
  final List<Event> prayerTimes = [
    Event(
      title: "Fajr",
      dateTime: DateTime(today.year, today.month, today.day, 5, 0),
      location: "Home/Mosque",
      description: "Fajr Prayer",
    ),
    Event(
      title: "Dhuhr",
      dateTime: DateTime(today.year, today.month, today.day, 13, 0),
      location: "Home/Mosque",
      description: "Dhuhr Prayer",
    ),
    Event(
      title: "Asr",
      dateTime: DateTime(today.year, today.month, today.day, 16, 0),
      location: "Home/Mosque",
      description: "Asr Prayer",
    ),
    Event(
      title: "Maghrib",
      dateTime: DateTime(today.year, today.month, today.day, 18, 30),
      location: "Home/Mosque",
      description: "Maghrib Prayer",
    ),
    Event(
      title: "Isha",
      dateTime: DateTime(today.year, today.month, today.day, 20, 0),
      location: "Home/Mosque",
      description: "Isha Prayer",
    ),
  ];

  setState(() {
    myEvents.addAll(prayerTimes);
    _eventChecked.addAll(List.generate(prayerTimes.length, (index) => false));
    _eventShared.addAll(List.generate(prayerTimes.length, (index) => false));
    _eventAttendees.addAll(List.generate(prayerTimes.length, (index) => 1));
  });
}

  void _addIslamicEvents() {
    final currentHijriYear = JHijri.now().hijri.year;
    final islamicEvents = getIslamicEventsForYear(currentHijriYear);
    final calendarEvents = convertIslamicEventsToCalendarEvents(islamicEvents);

    setState(() {
      myEvents.addAll(calendarEvents);
      _eventChecked
          .addAll(List.generate(calendarEvents.length, (index) => false));
      _eventShared
          .addAll(List.generate(calendarEvents.length, (index) => false));
      _eventAttendees.addAll(List.generate(calendarEvents.length,
          (index) => 1)); // Assuming 1 attendee by default
    });
  }

  List<IslamicEvent> getIslamicEventsForYear(int hijriYear) {
    List<IslamicEvent> events = [];

    // Ramadan events
    final ramadanStart = JHijri(fMonth: 9, fDay: 1, fYear: hijriYear).dateTime;
    for (int i = 0; i < 30; i++) {
      final ramadanDay = ramadanStart.add(Duration(days: i));
      events.add(IslamicEvent(name: "Ramadan Day ${i + 1}", date: ramadanDay));
      if (i >= 19 && i % 2 == 0) {
        events.add(IslamicEvent(name: "Laylat al-Qadr?", date: ramadanDay));
      }
    }

    // Sunnah Fasting Days
    for (int month = 1; month <= 12; month++) {
      final firstDayOfMonth = JHijri(fMonth: month, fDay: 1, fYear: hijriYear).dateTime;
      for (int dayOffset = 0; dayOffset < 30; dayOffset++) {
        final date = firstDayOfMonth.add(Duration(days: dayOffset));
        final weekday = date.weekday;

        // Mondays and Thursdays
        if (weekday == DateTime.monday || weekday == DateTime.thursday) {
          events.add(IslamicEvent(name: "Sunnah Fasting", date: date));
        }

        // White Days: 13th, 14th, 15th of each Hijri month
        final hijriDay = JHijri(fDate: date).hijri.day;
        if (hijriDay == 13 || hijriDay == 14 || hijriDay == 15) {
          events.add(IslamicEvent(name: "White Day Fasting", date: date));
        }
        
        // Jumu'ah Reminder: Every Friday
        if (date.weekday == DateTime.friday) {
          events.add(IslamicEvent(name: "Jumu'ah Reminder", date: date));
        }
      }
    }

    // Days of Hajj (8th-12th Dhu al-Hijjah)
    for (int day = 8; day <= 12; day++) {
      final hajjDate = JHijri(fMonth: 12, fDay: day, fYear: hijriYear).dateTime;
      events.add(IslamicEvent(name: "Hajj Day $day", date: hajjDate));
    }

    return events;
  }

  List<Event> convertIslamicEventsToCalendarEvents(
      List<IslamicEvent> islamicEvents) {
    return islamicEvents.map((event) {
      return Event(
        title: event.name,
        dateTime: event.date,
        location: "Islamic Observance",
        description: event.name,
      );
    }).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.bars,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 24.0,
          ),          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onSubmitted: (query) {
                  setState(() {
                    _isSearching = false;
                  });
                },
              )
            : Text('Calendar',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color.fromARGB(255, 4, 4, 4))),
        backgroundColor: Color(0xFFC8DDB2),
        elevation: 0,
        actions: _buildLeadingIcons(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: TabBar(
            controller: _tabController,
            labelColor: primaryGreen,
            unselectedLabelColor: Colors.black,
            indicatorColor: primaryGreen,
            tabs: [
              Tab(text: 'Month'),
              Tab(text: 'Week'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Any widgets you want above the TabBarView
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMonthView(),
                _buildWeekView(),
                _buildFriendsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayLabels() {
    final daysOfWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: daysOfWeek.map((day) {
        return Flexible(
          child: Center(
            child: Text(
              day,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildLeadingIcons() {
    return [
      IconButton(
        icon: Icon(Icons.search, color: Colors.black),
        onPressed: () {
          setState(() {
            _isSearching = !_isSearching;
          });
        },
      ),
      IconButton(
        icon: Icon(Icons.add, color: Colors.black),
        onPressed: _showAddEventDialog,
      ),
      IconButton(
        icon: Icon(Icons.chat_bubble, color: Colors.black),
        onPressed: () {
          print("Chat bubble tapped!");
        },
      ),
    ];
  }

  void _showAddEventDialog() {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _dateTimeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Event Title'),
                autofocus: true,
              ),
              TextField(
                controller: _dateTimeController,
                decoration: InputDecoration(labelText: 'Date & Time'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      _dateTimeController.text =
                          DateFormat.yMMMd().add_jm().format(
                                DateTime(date.year, date.month, date.day,
                                    time.hour, time.minute),
                              );
                    }
                  }
                },
              ),
              SwitchListTile(
                title: Text('Share with Friends'),
                value: _shareWithFriends,
                onChanged: (bool value) {
                  setState(() {
                    _shareWithFriends = value;
                  });
                },
                activeColor: primaryGreen,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final event = Event(
                  title: _titleController.text,
                  dateTime: DateTime.parse(_dateTimeController.text),
                  location: 'Location',
                  description: 'Description',
                );
                setState(() {
                  myEvents.add(event);
                  _eventChecked.add(false);
                  _eventShared.add(false);
                  _eventAttendees.add(1);
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    final jhijriDate = JHijri(fDate: _selectedDate); // Create Hijri date based on the selected Gregorian date

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Existing back arrow IconButton
        IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen),
          onPressed: () {
            setState(() {
              if (_tabController.index == 0) {
                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
              } else if (_tabController.index == 1) {
                _focusedWeekDate = _focusedWeekDate.subtract(Duration(days: 7));
              }
            });
          },
        ),
        // Step 2: Wrap Column with GestureDetector
        GestureDetector(
          onTap: () {
            setState(() {
              _datesSwapped = !_datesSwapped; // Step 3: Toggle the state variable
            });
          },
          child: Column(
            children: _datesSwapped
                ? [
                    // Hijri date on top when swapped
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5.0),
                      child: Text(
                        "${jhijriDate.hijri.monthName} ${jhijriDate.hijri.day}, ${jhijriDate.hijri.year} AH",
                        style: TextStyle(
                          fontSize: 20, // Bigger font
                          fontWeight: FontWeight.bold, // Bold
                          color: primaryGreen,
                        ),
                      ),
                    ),
                    // Gregorian date below when swapped
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
                      child: Text(
                        _tabController.index == 0
                            ? DateFormat.yMMMM().format(_selectedDate)
                            : DateFormat.yMMMMd().format(_focusedWeekDate),
                        style: TextStyle(
                          fontSize: 16, // Smaller font
                          fontWeight: FontWeight.normal, // Normal weight
                          color: primaryGreen,
                        ),
                      ),
                    ),
                  ]
                : [
                    // Gregorian date on top when not swapped
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5.0),
                      child: Text(
                        _tabController.index == 0
                            ? DateFormat.yMMMM().format(_selectedDate)
                            : DateFormat.yMMMMd().format(_focusedWeekDate),
                        style: TextStyle(
                          fontSize: 20, // Bigger font
                          fontWeight: FontWeight.bold, // Bold
                          color: primaryGreen,
                        ),
                      ),
                    ),
                    // Hijri date below when not swapped
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
                      child: Text(
                        "${jhijriDate.hijri.monthName} ${jhijriDate.hijri.day}, ${jhijriDate.hijri.year} AH",
                        style: TextStyle(
                          fontSize: 16, // Smaller font
                          fontWeight: FontWeight.normal, // Normal weight
                          color: primaryGreen,
                        ),
                      ),
                    ),
                  ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward, color: primaryGreen),
          onPressed: () {
            setState(() {
              if (_tabController.index == 0) {
                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
              } else if (_tabController.index == 1) {
                _focusedWeekDate = _focusedWeekDate.add(Duration(days: 7));
              }
            });
          },
        ),
      ],
    );
  }

List<Event> _getEventsForSelectedMonth() {
  // Exclude prayer times in the Month View
  return myEvents.where((event) {
    final isPrayer = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"].contains(event.title);
    return event.dateTime.year == _selectedDate.year &&
           event.dateTime.month == _selectedDate.month &&
           !isPrayer;
  }).toList();
}


  Widget _buildMonthView() {
    final daysInMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    int firstWeekdayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1).weekday %
            7; // Sunday=0
    final daysBefore = firstWeekdayOfMonth;
    final totalCells = daysBefore + daysInMonth;

    return Column(
      children: [
        _buildHeader(),
        _buildDayLabels(), // Add the day labels here
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: totalCells,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              if (index < daysBefore) {
                return Container();
              } else {
                final day = index - daysBefore + 1;
                final date =
                    DateTime(_selectedDate.year, _selectedDate.month, day);
                final hasEvents = myEvents.any((event) =>
                    event.dateTime.year == date.year &&
                    event.dateTime.month == date.month &&
                    event.dateTime.day == date.day);
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedDate = date;
                    _tabController.index = 1;
                  }),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: date == _selectedDate
                              ? primaryGreen
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              color: date == _selectedDate
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: date == _selectedDate
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      if (hasEvents)
                        Positioned(
                          bottom: 4,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isIslamicHoliday(date)
                                  ? islamicEventColor
                                  : primaryGreen,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        SizedBox(height: 10),
        Flexible(child: _buildEventList(events: _getEventsForSelectedWeek())),
      ],
    );
  }
List<Event> _getEventsForSelectedWeek({bool includePrayers = true}) {
  final firstDayOfWeek = _getFirstDayOfWeek(_focusedWeekDate);
  final lastDayOfWeek = _getLastDayOfWeek(_focusedWeekDate);

  return myEvents.where((event) {
    final eventDate = event.dateTime;
    final isPrayer = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"].contains(event.title);
    return eventDate.isAfter(firstDayOfWeek.subtract(Duration(days: 1))) &&
           eventDate.isBefore(lastDayOfWeek.add(Duration(days: 1))) &&
           (includePrayers || !isPrayer);
  }).toList();
}

bool _isPrayerEvent(DateTime date) {
  return myEvents.any((event) =>
      event.dateTime.year == date.year &&
      event.dateTime.month == date.month &&
      event.dateTime.day == date.day &&
      ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"].contains(event.title));
}

  bool _isIslamicHoliday(DateTime date) {
    return myEvents.any((event) =>
        event.dateTime.year == date.year &&
        event.dateTime.month == date.month &&
        event.dateTime.day == date.day &&
        event.location == "Islamic Observance");
  }

  DateTime _getFirstDayOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  DateTime _getLastDayOfWeek(DateTime date) {
    return _getFirstDayOfWeek(date).add(Duration(days: 6));
  }

Widget _buildWeekView() {
  final firstDayOfWeek = _getFirstDayOfWeek(_focusedWeekDate);
  final daysInWeek = List.generate(7, (index) {
    return firstDayOfWeek.add(Duration(days: index));
  });

  final eventsForSelectedDay = myEvents.where((event) {
    return event.dateTime.year == _selectedDate.year &&
           event.dateTime.month == _selectedDate.month &&
           event.dateTime.day == _selectedDate.day;
  }).toList();

  return Column(
    children: [
      _buildHeader(),
      _buildMiniWeekCalendar(daysInWeek),
      Expanded(
        child: ListView.builder(
          itemCount: 24,
          itemBuilder: (context, hourIndex) {
            final hour = hourIndex;
            final eventsForHour = eventsForSelectedDay.where((event) {
              return event.dateTime.hour == hour;
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Center-aligned time label with consistent width
                      SizedBox(
                        width: 70, // Adjusted width to align with day labels
                        child: Center(
                          child: Text(
                            _formatTime(hour),
                            style: TextStyle(
                              fontFamily: 'Courier', // Monospaced font for alignment
                              fontWeight: FontWeight.bold,
                              color: primaryGreen,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Display events for the current hour
                      Expanded(
                        child: Column(
                          children: eventsForHour.map((event) {
                            final eventIndex = myEvents.indexOf(event);
                            final isChecked = _eventChecked[eventIndex];

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 1.0, horizontal: 8.0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: isChecked
                                    ? Colors.grey.shade200
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: primaryGreen,
                                  width: 0.6,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Checkbox to mark the task as complete
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _eventChecked[eventIndex] =
                                            value ?? false;
                                      });
                                    },
                                    activeColor: primaryGreen,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  // Event Title with strikethrough if checked
                                  Expanded(
                                    child: Text(
                                      event.title,
                                      style: TextStyle(
                                        color: primaryGreen,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        decoration: isChecked
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  // "More" button with additional padding on the right
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: TextButton.icon(
                                      onPressed: () => _showEventDetailsDialog(context, event),
                                      icon: Icon(
                                        Icons.info_outline,
                                        color: primaryGreen,
                                        size: 18,
                                      ),
                                      label: Text(
                                        "More",
                                        style: TextStyle(
                                          color: primaryGreen,
                                          fontSize: 12,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size(50, 30),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 0.8, color: Colors.grey.shade400),
              ],
            );
          },
        ),
      ),
    ],
  );
}

String _formatTime(int hour) {
  final int displayHour = hour % 12 == 0 ? 12 : hour % 12;
  final String period = hour < 12 ? 'AM' : 'PM';
  return '${displayHour.toString().padLeft(2, '0')} $period';
}


void _showEventDetailsDialog(BuildContext context, Event event) {
  bool _shareWithFriends = false;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(20),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title and Edit Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.title,
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: primaryGreen),
                        onPressed: () {
                          Navigator.of(context).pop();
                          print("Edit button pressed!");
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Date & Time
                  Row(
                    children: [
                      Icon(Icons.access_time, color: primaryGreen),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          DateFormat.yMMMMd().add_jm().format(event.dateTime),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, color: primaryGreen),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Description
                  Row(
                    children: [
                      Icon(Icons.description, color: primaryGreen),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          event.description,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Share with Friends Toggle
                  SwitchListTile(
                    title: Text(
                      "Share with Friends",
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: _shareWithFriends,
                    onChanged: (bool value) {
                      setState(() {
                        _shareWithFriends = value;
                      });
                      print("Share with Friends toggled: $value");
                    },
                    activeColor: primaryGreen,
                  ),
                  SizedBox(height: 10),
                  // Close Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}


Widget _buildMiniWeekCalendar(List<DateTime> daysInWeek) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: daysInWeek.map((date) {
      final isSelected = date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;

      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedDate = date;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: isSelected ? primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Text(
                DateFormat.E().format(date), // Day of the week (e.g., Mon, Tue)
                style: TextStyle(
                  color: isSelected ? Colors.white : primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat.d().format(date), // Day of the month (e.g., 12, 13)
                style: TextStyle(
                  color: isSelected ? Colors.white : primaryGreen,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}


  Widget _buildEventList({List<Event>? events}) {
  
  List<Event> _getEventsForSelectedWeekWithPrayers() {
    final firstDayOfWeek = _getFirstDayOfWeek(_focusedWeekDate);
    final lastDayOfWeek = _getLastDayOfWeek(_focusedWeekDate);

    return myEvents.where((event) {
      final eventDate = event.dateTime;
      return eventDate.isAfter(firstDayOfWeek.subtract(Duration(days: 1))) &&
          eventDate.isBefore(lastDayOfWeek.add(Duration(days: 1)));
    }).toList();
  }
    final eventList =
        events ?? myEvents; // Default to myEvents if no list is passed
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: eventList.length,
      itemBuilder: (context, index) {
        final event = eventList[index];
        return _buildEventCard(
            event.title, DateFormat.yMMMMd().format(event.dateTime), index);
      },
    );
  }

  Widget _buildEventCard(String title, String time, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.event, color: primaryGreen),
            title: Text(title, style: TextStyle(color: primaryGreen)),
            subtitle: Row(
              children: [
                Text(time),
                SizedBox(width: 10),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: primaryGreen),
                    SizedBox(width: 4),
                    Text('${_eventAttendees[index]}'),
                  ],
                ),
              ],
            ),
            trailing: Checkbox(
              value: _eventChecked[index],
              onChanged: (bool? value) {
                setState(() {
                  _eventChecked[index] = value ?? false;
                });
              },
              activeColor: primaryGreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Share with friends',
                    style: TextStyle(color: primaryGreen)),
                Switch(
                  value: _eventShared[index],
                  onChanged: (bool value) {
                    setState(() {
                      _eventShared[index] = value;
                    });
                  },
                  activeColor: primaryGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          title: Text("Friends' Calendars",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        ...friendCalendars
            .map((calendar) => _buildCalendarTile(calendar))
            .toList(),
      ],
    );
  }

  Widget _buildCalendarTile(Calendar calendar) {
    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.calendar_today, color: primaryGreen),
        title: Text(calendar.name, style: TextStyle(color: primaryGreen)),
        children: [
          ListTile(
            title: Text("See Full Calendar"),
            trailing: Icon(Icons.arrow_forward, color: primaryGreen),
            onTap: () {
              _navigateToFriendCalendar(calendar);
            },
          ),
          ...calendar.events
              .map((event) => ListTile(
                    leading: Icon(Icons.event, color: primaryGreen),
                    title: Text(event.title),
                    subtitle: Text(
                        "${DateFormat.yMMMMd().add_jm().format(event.dateTime)} at ${event.location}"),
                    trailing: IconButton(
                      icon: Icon(Icons.add, color: primaryGreen),
                      onPressed: () {
                        _addEventToMyCalendar(event);
                      },
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  void _navigateToFriendCalendar(Calendar calendar) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FriendCalendarPage(calendar: calendar, myEvents: myEvents),
      ),
    );
  }

  void _addEventToMyCalendar(Event event) {
    setState(() {
      // Add the new event
      myEvents.add(event);

      // Sort the events list by dateTime
      myEvents.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      // Update the related lists
      _eventChecked.add(false);
      _eventShared.add(false);
      _eventAttendees.add(1); // Assuming 1 attendee by default
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${event.title} added to your calendar")),
    );
  }
}

class FriendCalendarPage extends StatefulWidget {
  final Calendar calendar;
  final List<Event> myEvents;

  const FriendCalendarPage({required this.calendar, required this.myEvents});

  @override
  _FriendCalendarPageState createState() => _FriendCalendarPageState();
}

class _FriendCalendarPageState extends State<FriendCalendarPage> {
  DateTime _selectedDate = DateTime.now();
  bool _compareWithMyCalendar = false;
  final Color primaryGreen = Color(0xFF006400);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.calendar.name}'s Calendar",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Color(0xFFC8DDB2),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {}, // Added missing closing parenthesis here
          ),
          IconButton(
            icon: Icon(Icons.chat_bubble, color: Colors.black),
            onPressed: () {
              print("Chat bubble tapped!");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Compare with My Calendar',
                style: TextStyle(color: primaryGreen)),
            value: _compareWithMyCalendar,
            onChanged: (bool value) {
              setState(() {
                _compareWithMyCalendar = value;
              });
            },
            activeColor: primaryGreen,
          ),
          _buildHeader(),
          Flexible(child: _buildMonthView()),
          Flexible(child: _buildEventList(widget.calendar)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen),
          onPressed: () {
            setState(() {
              _selectedDate =
                  DateTime(_selectedDate.year, _selectedDate.month - 1);
            });
          },
        ),
        Text(
          DateFormat.yMMMM().format(_selectedDate),
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: primaryGreen),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward, color: primaryGreen),
          onPressed: () {
            setState(() {
              _selectedDate =
                  DateTime(_selectedDate.year, _selectedDate.month + 1);
            });
          },
        ),
      ],
    );
  }

  Widget _buildMonthView() {
    final daysInMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    final firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1).weekday;
    final daysBefore = firstDayOfMonth - 1;
    final totalCells = daysBefore + daysInMonth;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: totalCells,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          if (index < daysBefore) {
            return Container();
          } else {
            final day = index - daysBefore + 1;
            final date = DateTime(_selectedDate.year, _selectedDate.month, day);

            final hasMyEvents = widget.myEvents.any((event) =>
                event.dateTime.year == date.year &&
                event.dateTime.month == date.month &&
                event.dateTime.day == date.day);

            final hasFriendEvents = widget.calendar.events.any((event) =>
                event.dateTime.year == date.year &&
                event.dateTime.month == date.month &&
                event.dateTime.day == date.day);

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: date == _selectedDate
                          ? primaryGreen
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          color: date == _selectedDate
                              ? Colors.white
                              : Colors.black,
                          fontWeight: date == _selectedDate
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  if (_compareWithMyCalendar && hasMyEvents)
                    Positioned(
                      bottom: 4, // Adjusted to properly position the dots
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryGreen, // Green for my events
                        ),
                      ),
                    ),
                  if (hasFriendEvents)
                    Positioned(
                      bottom: 4, // Adjusted to properly position the dots
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(255, 2, 61, 109), // Blue for friend's events
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildEventList(Calendar calendar) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: calendar.events.length,
      itemBuilder: (context, index) {
        final event = calendar.events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: Icon(Icons.event, color: primaryGreen),
            title: Text(event.title, style: TextStyle(color: primaryGreen)),
            subtitle: Text(
                "${DateFormat.yMMMMd().add_jm().format(event.dateTime)} at ${event.location}"),
            trailing: IconButton(
              icon: Icon(Icons.add, color: primaryGreen),
              onPressed: () {
                _addEventToMyCalendar(event);
              },
            ),
          ),
        );
      },
    );
  }

  void _addEventToMyCalendar(Event event) {
    setState(() {
      widget.myEvents.add(event);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${event.title} added to your calendar")),
    );
  }
}