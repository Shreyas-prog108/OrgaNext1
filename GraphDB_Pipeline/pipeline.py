import credentials
import psycopg2
from gremlin_python.driver import client, serializer

try:
    conn = psycopg2.connect("dbname='" + credentials.DB_NAME + "' user='" + credentials.DB_USER + "' host='" + credentials.DB_HOST + "' password='" + credentials.DB_PASSWORD + "'")
except:
    print("ERROR: Unable to connect to the database")

cur = conn.cursor()

cur.execute("""select
                    CourseID
                    , CourseName
                    , AcademicYear
                    , AcademicSemester
                from Course;""")
courses = cur.fetchall()

cur.execute("""select
                    EventID
                    , EventName
                from Event;""")
events = cur.fetchall()

cur.execute("""select
                    r.RoomID
                    , r.RoomName
                    , b.BuildingName
                    , r.Capacity
                from Room r
                join Building b
                on r.BuildingID = b.BuildingID;""")
rooms = cur.fetchall()

cur.execute("""select
                ScheduleID
                , COALESCE(cast(ScheduledDate as text), '') as ScheduledDate
                , StartTime
                , EndTime
                , Recurring
                , COALESCE(cast(DayOfWeek as text), '') as DayOfWeek
                , COALESCE(cast(RecurringStartDate as text), '') as RecurringStartDate
                , COALESCE(cast(RecurringEndDate as text), '') as RecurringEndDate
            from Schedule;""")
schedules = cur.fetchall()

cur.execute("""select
                    ScheduleID
                    , COALESCE(cast(EventID as text), '') as EventID
                    , COALESCE(cast(CourseID as text), '') as CourseID
                    , RoomID
                from Schedule s
                join RoomAssignment ra
                on s.RoomAssignmentID = ra.RoomAssignmentID;""")
schedule_room_assignments = cur.fetchall()

queries_add_vertices = []

for c in courses:
    queries_add_vertices.append('g.addV("course").property("id", "' + str(c[0]) + ': ' + c[1] + '").property("courseID", ' + str(c[0]) + ').property("courseName", "' + c[1] + '").property("academicYear", ' + str(c[2]) + ').property("academicSemester", "' + c[3] + '").property("pk", "/pk")')

for e in events:
    queries_add_vertices.append('g.addV("event").property("eventID", ' + str(e[0]) + ').property("eventName", "' + e[1] + '").property("pk", "/pk")')

for r in rooms:
    queries_add_vertices.append('g.addV("room").property("roomID", ' + str(r[0]) + ').property("roomName", "' + str(r[1]) + '").property("buildingName", "' + str(r[2]) + '").property("capacity", ' + str(r[3]) + ').property("pk", "/pk")')

for s in schedules:
    queries_add_vertices.append('g.addV("schedule").property("scheduleID", ' + str(s[0]) + ').property("scheduledDate", "' + str(s[1]) + '").property("startTime", "' + str(s[2]) + '").property("endTime", "' + str(s[3]) + '").property("recurring", "' + str(s[4]) + '").property("dayOfWeek", "' + s[5] + '").property("recurringStartDate", "' + str(s[6]) + '").property("recurringEndDate", "' + str(s[7]) + '").property("pk", "/pk")')


queries_add_edges = []

for x in schedule_room_assignments:
    # Course
    if x[1] == "":
        queries_add_edges.append("g.V().hasLabel('course').has('courseID'," + str(x[2]) + ").addE('scheduledAt').to(g.V().hasLabel('schedule').has('scheduleID', " + str(x[0]) + "))")
        queries_add_edges.append("g.V().hasLabel('course').has('courseID'," + str(x[2]) + ").addE('assignedTo').to(g.V().hasLabel('room').has('roomID', " + str(x[3]) + "))")
    
    # Event
    else:
        queries_add_edges.append("g.V().hasLabel('event').has('eventID'," + str(x[1]) + ").addE('scheduledAt').to(g.V().hasLabel('schedule').has('scheduleID', " + str(x[0]) + "))")
        queries_add_edges.append("g.V().hasLabel('event').has('eventID'," + str(x[1]) + ").addE('assignedTo').to(g.V().hasLabel('room').has('roomID', " + str(x[3]) + "))")


try:
    client = client.Client('wss://' + credentials.GREMLIN_ENDPOINT + '.gremlin.cosmos.azure.com:443/', 'g',
                        username="/dbs/" + credentials.GREMLIN_DATABASE + "/colls/" + credentials.GREMLIN_GRAPH,
                        password=credentials.GREMLIN_PASSWORD,
                        message_serializer=serializer.GraphSONSerializersV2d0()
                        )
except:
    print("ERROR: Setting up gremlin client")


# Delete all existing vertices
callback = client.submitAsync("g.V().drop()")
if callback.result() is not None:
    callback.result().all().result() 
print("\n")


for query in queries_add_vertices:
    print("\n> {0}\n".format(query))
    callback = client.submitAsync(query)
    if callback.result() is not None:
        print("\tInserted this vertex:\n\t{0}".format(
            callback.result().all().result()))
    else:
        print("Something went wrong with this query: {0}".format(query))
    print("\n")


for query in queries_add_edges:
    print("\n> {0}\n".format(query))
    callback = client.submitAsync(query)
    if callback.result() is not None:
        print("\tInserted this edge:\n\t{0}\n".format(
            callback.result().all().result()))
    else:
        print("Something went wrong with this query:\n\t{0}".format(query))
    print("\n")


cur.close()
conn.close()