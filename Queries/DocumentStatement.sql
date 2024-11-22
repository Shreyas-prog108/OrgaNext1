-- Event Schedule Doucmuent query code for Cosmos DB linkage
SELECT s.ScheduleID, s.ScheduledDate, s.StartTime, s.EndTime, 
    to_json(JSON_BUILD_OBJECT(
        'Room', r.RoomName,
        'ExpectedParticipant', ra.ExpectedParticipant,
        'Capacity', r.Capacity
    )) AS Room,
    to_json(JSON_BUILD_OBJECT(
        'Event', e.EventName,
        'MainContact', CONCAT(s2.StaffFirstName, ' ', s2.StaffLastName)
    )) AS Event
FROM Schedule s
LEFT JOIN RoomAssignment ra ON s.RoomAssignmentID = ra.RoomAssignmentID
LEFT JOIN Room r ON ra.RoomID = r.RoomID
LEFT JOIN Event e ON ra.EventID = e.EventID
LEFT JOIN Staff s2 ON e.MainContact = s2.StaffID
--Additional Condition for future load
-- WHERE s.ScheduledDate > (current_date - 7);;


-- Room Document 
SELECT r.RoomID, b.BuildingName,  r.Capacity
FROM Room r LEFT JOIN Building b 
    ON r.BuildingID = b.BuildingID;

-- Event Document
SELECT e.EventID, e.EventName, CONCAT(s.StaffFirstName, ' ', s.StaffLastName) MainContact
FROM Event e LEFT JOIN Staff s 
   ON e.MainContact = s.StaffID;


-- Course Document
SELECT c.CourseID, c.CourseName, CONCAT(f.FacultyFirstName, ' ', f.FacultyLastName) Instructor
FROM Course c LEFT JOIN Faculty f
   ON c.InstructorID = f.FacultyID