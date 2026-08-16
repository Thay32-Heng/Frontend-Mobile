import 'types.dart';

final List<String> stakeholderRoles = [
  "Student",
  "Lecturer",
  "Head of Department",
  "Class Monitor",
  "Assistant",
  "Staff",
];

final Map<String, List<UserHistoryItem>> usersByRoleData = {
  "Student": [
    UserHistoryItem(
      id: "S-001",
      user: "Sok Pisey",
      role: "Student",
      records: [
        AttendanceRecordItem(
            date: "2026-05-29",
            checkIn: "07:42",
            checkOut: "16:05",
            status: "Present"),
        AttendanceRecordItem(
            date: "2026-05-28",
            checkIn: "07:55",
            checkOut: "16:02",
            status: "Present"),
        AttendanceRecordItem(
            date: "2026-05-27",
            checkIn: "08:12",
            checkOut: "16:00",
            status: "Late"),
        AttendanceRecordItem(date: "2026-05-26", status: "Absent"),
      ],
    ),
    UserHistoryItem(
      id: "S-002",
      user: "Chea Mengly",
      role: "Student",
      records: [
        AttendanceRecordItem(
            date: "2026-05-29",
            checkIn: "07:38",
            checkOut: "16:00",
            status: "Present"),
        AttendanceRecordItem(date: "2026-05-28", status: "Leave"),
        AttendanceRecordItem(
            date: "2026-05-27",
            checkIn: "07:50",
            checkOut: "16:05",
            status: "Present"),
      ],
    ),
    UserHistoryItem(
      id: "S-003",
      user: "Pich Sambath",
      role: "Student",
      records: [
        AttendanceRecordItem(
            date: "2026-05-29",
            checkIn: "08:18",
            checkOut: "16:00",
            status: "Late"),
        AttendanceRecordItem(
            date: "2026-05-28",
            checkIn: "07:45",
            checkOut: "16:01",
            status: "Present"),
      ],
    ),
  ],
  "Lecturer": [
    UserHistoryItem(
      id: "L-001",
      user: "Chan Dara",
      role: "Lecturer",
      records: [
        AttendanceRecordItem(
            date: "2026-05-29",
            checkIn: "07:30",
            checkOut: "16:30",
            status: "Present"),
        AttendanceRecordItem(
            date: "2026-05-28",
            checkIn: "07:32",
            checkOut: "16:28",
            status: "Present"),
        AttendanceRecordItem(
            date: "2026-05-27",
            checkIn: "07:35",
            checkOut: "16:31",
            status: "Present"),
      ],
    ),
    UserHistoryItem(
      id: "L-002",
      user: "Sam Phalla",
      role: "Lecturer",
      records: [
        AttendanceRecordItem(
            date: "2026-05-29",
            checkIn: "07:31",
            checkOut: "16:32",
            status: "Present"),
        AttendanceRecordItem(date: "2026-05-28", status: "Absent"),
      ],
    ),
  ],
  "Head of Department": [
    UserHistoryItem(
      id: "H-001",
      user: "Heng Ratha",
      role: "Head of Department",
      records: [
        AttendanceRecordItem(
            date: "2026-05-29",
            checkIn: "07:50",
            checkOut: "17:00",
            status: "Present"),
        AttendanceRecordItem(date: "2026-05-28", status: "Leave"),
        AttendanceRecordItem(
            date: "2026-05-27",
            checkIn: "07:48",
            checkOut: "17:02",
            status: "Present"),
      ],
    ),
  ],
  "Class Monitor": [
    UserHistoryItem(
      id: "M-001",
      user: "Lim Sothy",
      role: "Class Monitor",
      records: [
        AttendanceRecordItem(
            date: "2026-05-29",
            checkIn: "07:40",
            checkOut: "16:10",
            status: "Present"),
        AttendanceRecordItem(
            date: "2026-05-28",
            checkIn: "08:15",
            checkOut: "16:00",
            status: "Late"),
        AttendanceRecordItem(
            date: "2026-05-27",
            checkIn: "07:38",
            checkOut: "16:05",
            status: "Present"),
      ],
    ),
    UserHistoryItem(
      id: "M-002",
      user: "Tep Channary",
      role: "Class Monitor",
      records: [
        AttendanceRecordItem(
            date: "2026-05-29",
            checkIn: "07:42",
            checkOut: "16:08",
            status: "Present"),
      ],
    ),
  ],
  "Assistant": [
    UserHistoryItem(
      id: "A-001",
      user: "Vann Sreypov",
      role: "Assistant",
      records: [
        AttendanceRecordItem(
            date: "2026-05-29",
            checkIn: "07:55",
            checkOut: "16:20",
            status: "Present"),
        AttendanceRecordItem(
            date: "2026-05-28",
            checkIn: "07:52",
            checkOut: "16:18",
            status: "Present"),
        AttendanceRecordItem(date: "2026-05-27", status: "Absent"),
      ],
    ),
  ],
  "Staff": [
    UserHistoryItem(
      id: "ST-001",
      user: "Kim Bopha",
      role: "Staff",
      records: [
        AttendanceRecordItem(
            date: "2026-05-29",
            checkIn: "08:00",
            checkOut: "17:00",
            status: "Present"),
        AttendanceRecordItem(
            date: "2026-05-28",
            checkIn: "08:05",
            checkOut: "17:01",
            status: "Late"),
        AttendanceRecordItem(
            date: "2026-05-27",
            checkIn: "07:58",
            checkOut: "17:00",
            status: "Present"),
      ],
    ),
    UserHistoryItem(
      id: "ST-002",
      user: "Noun Sopheak",
      role: "Staff",
      records: [
        AttendanceRecordItem(
            date: "2026-05-29",
            checkIn: "07:59",
            checkOut: "17:00",
            status: "Present"),
        AttendanceRecordItem(date: "2026-05-28", status: "Leave"),
      ],
    ),
  ],
};

final List<AttendanceRecordItem> mockHistoryData = [
  AttendanceRecordItem(
      date: "2026-05-29",
      checkIn: "07:42",
      checkOut: "16:05",
      status: "Present"),
  AttendanceRecordItem(
      date: "2026-05-28",
      checkIn: "07:55",
      checkOut: "16:02",
      status: "Present"),
  AttendanceRecordItem(
      date: "2026-05-27", checkIn: "08:12", checkOut: "16:00", status: "Late"),
  AttendanceRecordItem(date: "2026-05-26", status: "Absent"),
  AttendanceRecordItem(
      date: "2026-05-25",
      checkIn: "07:38",
      checkOut: "16:10",
      status: "Present"),
  AttendanceRecordItem(
      date: "2026-05-22",
      checkIn: "07:50",
      checkOut: "16:00",
      status: "Present"),
  AttendanceRecordItem(date: "2026-05-21", status: "Leave"),
  AttendanceRecordItem(
      date: "2026-05-20",
      checkIn: "07:45",
      checkOut: "16:01",
      status: "Present"),
  AttendanceRecordItem(
      date: "2026-05-19", checkIn: "08:20", checkOut: "16:00", status: "Late"),
  AttendanceRecordItem(
      date: "2026-05-18",
      checkIn: "07:33",
      checkOut: "16:00",
      status: "Present"),
];

final List<LeaveRequestItem> mockRequestsData = [
  LeaveRequestItem(
    id: "REQ-1042",
    type: "Leave",
    from: "2026-06-02",
    to: "2026-06-04",
    reason: "Family event in Siem Reap",
    status: RequestStatus.pending,
    createdAt: "2026-05-27",
  ),
  LeaveRequestItem(
    id: "REQ-1038",
    type: "Permission",
    from: "2026-05-21",
    to: "2026-05-21",
    reason: "Medical appointment",
    status: RequestStatus.approved,
    createdAt: "2026-05-19",
  ),
  LeaveRequestItem(
    id: "REQ-1029",
    type: "Leave",
    from: "2026-05-10",
    to: "2026-05-10",
    reason: "Personal",
    status: RequestStatus.rejected,
    createdAt: "2026-05-08",
  ),
];

final List<Map<String, dynamic>> weeklyTrendData = [
  {"day": "Mon", "present": 92},
  {"day": "Tue", "present": 88},
  {"day": "Wed", "present": 95},
  {"day": "Thu", "present": 81},
  {"day": "Fri", "present": 90},
  {"day": "Sat", "present": 76},
];

final List<NotificationItem> mockNotificationsData = [
  NotificationItem(
      id: 1,
      title: "Leave Approved",
      body: "REQ-1038 has been approved by Lecturer Sok.",
      time: "2h",
      unread: true,
      kind: "approval"),
  NotificationItem(
      id: 2,
      title: "Absence Warning",
      body: "You have 3 absences this month.",
      time: "1d",
      unread: true,
      kind: "warning"),
  NotificationItem(
      id: 3,
      title: "Checked in",
      body: "Face recognized at 07:42 AM.",
      time: "1d",
      unread: false,
      kind: "info"),
  NotificationItem(
      id: 4,
      title: "Telegram linked",
      body: "Notifications will also be sent to Telegram.",
      time: "3d",
      unread: false,
      kind: "info"),
];

final List<ManagedUser> mockUsersData = [
  ManagedUser(
      id: "U-001",
      name: "Sok Pisey",
      role: "Student",
      email: "pisey@school.edu",
      active: true),
  ManagedUser(
      id: "U-002",
      name: "Chan Dara",
      role: "Lecturer",
      email: "dara@school.edu",
      active: true),
  ManagedUser(
      id: "U-003",
      name: "Heng Ratha",
      role: "Head of Department",
      email: "ratha@school.edu",
      active: true),
  ManagedUser(
      id: "U-004",
      name: "Lim Sothy",
      role: "Class Monitor",
      email: "sothy@school.edu",
      active: false),
  ManagedUser(
      id: "U-005",
      name: "Vann Sreypov",
      role: "Assistant",
      email: "sreypov@school.edu",
      active: true),
  ManagedUser(
      id: "U-006",
      name: "Kim Bopha",
      role: "Staff",
      email: "bopha@school.edu",
      active: true),
];

final List<ApprovalRequestItem> hodRequestsData = [
  ApprovalRequestItem(
    id: "REQ-1042",
    user: "Sok Pisey",
    userRole: "Student",
    type: "Leave",
    from: "2026-06-02",
    to: "2026-06-04",
    reason: "Family event in Siem Reap",
    submittedAt: "2026-05-27",
    recommender: "Chan Dara (Lecturer)",
    status: RequestStatus.pending,
  ),
  ApprovalRequestItem(
    id: "REQ-1045",
    user: "Sam Phalla",
    userRole: "Lecturer",
    type: "Leave",
    from: "2026-06-03",
    to: "2026-06-03",
    reason: "Personal matter",
    submittedAt: "2026-05-28",
    recommender: "Vann Sreypov (Assistant)",
    status: RequestStatus.pending,
  ),
  ApprovalRequestItem(
    id: "REQ-1046",
    user: "Lim Sothy",
    userRole: "Class Monitor",
    type: "Permission",
    from: "2026-06-02",
    to: "2026-06-02",
    reason: "Medical appointment",
    submittedAt: "2026-05-28",
    recommender: "Chan Dara (Lecturer)",
    status: RequestStatus.pending,
  ),
  ApprovalRequestItem(
    id: "REQ-1039",
    user: "Pich Sambath",
    userRole: "Student",
    type: "Permission",
    from: "2026-05-30",
    to: "2026-05-30",
    reason: "Bank appointment",
    submittedAt: "2026-05-26",
    recommender: "Sam Phalla (Lecturer)",
    status: RequestStatus.approved,
  ),
];

final List<ApprovalRequestItem> lecturerRequestsData = [
  ApprovalRequestItem(
    id: "REQ-1042",
    user: "Sok Pisey",
    userRole: "Student",
    type: "Leave",
    from: "2026-06-02",
    to: "2026-06-04",
    reason: "Family event in Siem Reap",
    submittedAt: "2026-05-27",
    status: RequestStatus.pending,
  ),
  ApprovalRequestItem(
    id: "REQ-1044",
    user: "Chea Mengly",
    userRole: "Student",
    type: "Permission",
    from: "2026-06-02",
    to: "2026-06-02",
    reason: "Medical appointment",
    submittedAt: "2026-05-28",
    status: RequestStatus.pending,
  ),
  ApprovalRequestItem(
    id: "REQ-1038",
    user: "Pich Sambath",
    userRole: "Student",
    type: "Permission",
    from: "2026-05-21",
    to: "2026-05-21",
    reason: "Registration at Ministry",
    submittedAt: "2026-05-19",
    status: RequestStatus.approved,
  ),
];
