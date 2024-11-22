insert into Faculty (FacultyFirstName, FacultyLastName, FacultyEmail) values 
('Tom', 'Peter', 'tom.p@example.com'),
('John', 'Smith', 'john.s@example.com'),
('Mike', 'Yamada', 'mike.y@example.com'),
('Kaz', 'Johnson', 'kaz.j@example.com'),
('Luis', 'Peter', 'luis.p@example.com');


insert into Course (CourseName, InstructorID, AcademicYear, AcademicSemester) values
('DAMG7275', 1, 2023, 'Fall'),
('IE6800', 3, 2023, 'Fall'),
('CS5800', 5, 2023, 'Fall');


insert into Building (BuildingName, BuildingAddress) values
('401', '401 Terry Ave N #103, Seattle, WA 98109'),
('225', '225 Terry Ave N, Seattle, WA 98109');


insert into Room (RoomName, BuildingID, Capacity) values
('202', 2, 50),
('301', 2, 50),
('102', 1, 100);


insert into Department (DepartmentName) values
('IT Services'),
('Campus Operations'),
('Career Development');


insert into Staff (DepartmentID, StaffFirstName, StaffLastName, StaffEmail) values
(1, 'Thomas', 'John', 'thomas@example.com'),
(2, 'Aya', 'Ishida', 'aya@example.com'),
(3, 'Bill', 'Jassy', 'bill@example.com');


insert into Event (EventName, MainContact, SecondContact) values
('Career Fair', 3, 2),
('Alumni Networking', 3, 2),
('IT Support Weekly Session', 1, 2);


-- Event
insert into RoomAssignment (EventID, RoomID, ExpectedParticipant, Detail) values
(1, 3, 95, '2023 Spring STEM Career Fair'),
(2, 1, 40, '2023 Fall CPS Alumni Gathering');

-- Course
insert into RoomAssignment (CourseID, RoomID, ExpectedParticipant, Detail) values
(1, 2, 40, 'Seattle campus - session A'), 
(2, 2, 30, 'Seattle campus - session A'), 
(3, 1, 25, 'Seattle campus - session C');


insert into Schedule (RoomAssignmentID, ScheduledDate, StartTime, EndTime, Recurring, DayOfWeek, RecurringStartDate, RecurringEndDate) values
(1, '2023-05-05', '10:00:00 PST', '17:00:00 PST', FALSE, null, null, null),
(2, '2023-04-21', '18:00:00 PST', '20:00:00 PST', FALSE, null, null, null),
(3, null, '13:00:00 PST', '15:00:00 PST', TRUE, 'Wed', '2023-09-10', '2023-12-15'),
(4, null, '10:00:00 PST', '12:00:00 PST', TRUE, 'Mon', '2023-09-10', '2023-12-15'),
(4, null, '10:00:00 PST', '12:00:00 PST', TRUE, 'Thu', '2023-09-10', '2023-12-15');
