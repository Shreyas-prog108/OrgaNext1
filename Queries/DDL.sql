/*
CREATE DATABASE SchedulingSystem;
*/

create table Faculty (
	FacultyID serial primary key,
	FacultyFirstName VARCHAR(20) not null,
	FacultyLastName VARCHAR(20) not null,
	FacultyEmail VARCHAR(50) not null
);

create table Course(
	CourseID serial primary key,
	CourseName VARCHAR(50) not null,
	InstructorID int references Faculty (FacultyID) ON DELETE SET NULL ON UPDATE CASCADE,
	AcademicYear numeric(4) not null,
	AcademicSemester VARCHAR(20) not null
);

CREATE TABLE Building(
    BuildingID serial primary key,
    BuildingName VARCHAR(10) NOT NULL,
    BuildingAddress VARCHAR(50) NOT NUll
);

create table Room (
	RoomID serial primary key,
	RoomName VARCHAR(15) not null,
	BuildingID int references Building (BuildingID) ON DELETE CASCADE ON UPDATE CASCADE,
	Capacity int not null
);

create table Department (
	DepartmentID serial primary key,
	DepartmentName VARCHAR(50)
);

create table Staff (
	StaffID serial primary key,
	DepartmentID int references Department (DepartmentID) ON DELETE SET NULL ON UPDATE CASCADE,
	StaffFirstName VARCHAR(20) not null,
	StaffLastName VARCHAR(20) not null,
	StaffEmail VARCHAR(50) not null
);

create table Event (
	EventID serial primary key,
	EventName VARCHAR(50) not null,
	MainContact int references Staff (StaffID) ON DELETE SET NULL ON UPDATE CASCADE,
	SecondContact int references Staff (StaffID) ON DELETE SET NULL ON UPDATE CASCADE
);

create table RoomAssignment (
	RoomAssignmentID serial primary key,
	EventID int references Event (EventID) ON DELETE CASCADE ON UPDATE CASCADE,
	CourseID int references Course (CourseID) ON DELETE CASCADE ON UPDATE CASCADE,
	RoomID int not null references Room (RoomID) ON DELETE CASCADE ON UPDATE CASCADE,
	ExpectedParticipant bigint NOT NULL,
    Detail VARCHAR(200)
);

create table Schedule (
	ScheduleID serial primary key,
	RoomAssignmentID int references RoomAssignment (RoomAssignmentID) ON DELETE SET NULL ON UPDATE CASCADE,
    ScheduledDate date,
	StartTime time not null,
	EndTime time  not null,
	Recurring Boolean not null,
	DayOfWeek text,
	RecurringStartDate date,
	RecurringEndDate date,
	CHECK (StartTime < EndTime)
);

-- Add a constraint to make sure if it's a recurring schedule, DayOfWeek, RecurringStartDate, and RecurringEndDate are not null.
alter table Schedule
add constraint check_recurring_fields 
check ( NOT (recurring AND (dayofweek is null AND recurringstartdate is null AND recurringenddate is null) ));


create table ScheduleAudit_RoomChange (
	RoomAuditID serial primary key,
	ScheduleID int references Schedule (ScheduleID) ON DELETE NO ACTION ON UPDATE CASCADE,
	OldRoomAssignmentID int references RoomAssignment (RoomAssignmentID) ON DELETE NO ACTION ON UPDATE CASCADE,
	NEWRoomAssignmentID int references RoomAssignment (RoomAssignmentID) ON DELETE NO ACTION ON UPDATE CASCADE
);
CREATE TABLE ScheduleAudit_TimeChange(
	TimeAuditID serial primary key,
	ScheduleID int references Schedule (ScheduleID) ON DELETE NO ACTION ON UPDATE CASCADE,
    OldScheduledDate date,
	NewScheduleDate date,
	OldStartTime time not null,
	NewStartTime time not null,
	OldEndTime time  not null,
	NewEndTime time  not null
);
CREATE TABLE ScheduleAudit_RecurringStats(
	TimeAuditID serial primary key,
	ScheduleID int references Schedule (ScheduleID) ON DELETE NO ACTION ON UPDATE CASCADE,
    OldRecurringStat Boolean not null,
	NewRecurringStat Boolean not null,
	OldDayOfWeek text,
	NewDayOfWeek text,
	OldRecurringStartDate date,
	NewRecurringStartDate date,
	OldRecurringEndDate date,
	NewRecurringEndDate date
);
