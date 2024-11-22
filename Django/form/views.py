from django.shortcuts import render
from django.contrib import messages
from django.db import transaction

from .models import Room, Course, Event, Roomassignment, Schedule

def index(request):
    if request.method == 'GET':
        all_rooms = Room.objects.all()
        all_courses = Course.objects.all()
        all_events = Event.objects.all()
        all_schedules = Schedule.objects.all()
        context = {'all_rooms': all_rooms,
                'all_courses': all_courses,
                'all_events': all_events,
                'all_schedules': all_schedules}
        return render(request, 'form/index.html', context)
    
    elif request.method == 'POST':
        try:
            print("=== POST ===")
            print(request.POST)
            print("===========")

            room_id = request.POST['room']
            course_event = request.POST['course_event']
            course_event_type = course_event[:course_event.index("_")]
            course_event_id = course_event[course_event.index("_") + 1:]
            expected_participant = request.POST['expectedparticipant']
            detail = request.POST['detail']
            scheduled_date = request.POST['scheduleddate']
            start_time = request.POST['starttime']
            end_time = request.POST['endtime']
            recurring = request.POST['recurring']
            
            if "recuring_days" in request.POST:
                recuring_days = request.POST.getlist('recuring_days')
            else:
                recuring_days = []
            
            recurring_start_date = request.POST['recurringstartdate']
            recurring_end_date = request.POST['recurringenddate']

            if not (room_id or course_event or expected_participant or start_time or end_time):
                messages.error(request, 'Error: "Room", "Course or Event", "Expected Number of Participants", "Start Time", and/or "End Time" fields cannot be empty.')
                raise Exception('Error: "Room", "Course or Event", "Expected Number of Participants", "Start Time", and/or "End Time" fields cannot be empty.')
            
            with transaction.atomic():
                if course_event_type == "event":
                    new_room_assignment = Roomassignment(eventid = Event.objects.get(pk = int(course_event_id)),
                                                         roomid = Room.objects.get(pk = int(room_id)),
                                                         expectedparticipant = int(expected_participant),
                                                         detail = detail)
                else:
                    new_room_assignment = Roomassignment(courseid = Course.objects.get(pk = int(course_event_id)),
                                                         roomid = Room.objects.get(pk = int(room_id)),
                                                         expectedparticipant = int(expected_participant),
                                                         detail = detail)

                new_room_assignment.save()

                if recurring == "1" and recuring_days:
                    for week_day in recuring_days:
                        new_schedule = Schedule(roomassignmentid = new_room_assignment,
                                                starttime = start_time,
                                                endtime = end_time,
                                                recurring = recurring,
                                                dayofweek = week_day,
                                                recurringstartdate = recurring_start_date,
                                                recurringenddate = recurring_end_date)
                    
                        new_schedule.save()

                else:
                    new_schedule = Schedule(roomassignmentid = new_room_assignment,
                                            scheduleddate = scheduled_date,
                                            starttime = start_time,
                                            endtime = end_time,
                                            recurring = recurring)
                    
                    new_schedule.save()

            messages.success(request, 'The specified course/event was successfully scheduled!')
        
        except:
            messages.error(request, 'Error: The course/event was NOT scheduled!')
        
        finally:
            all_rooms = Room.objects.all()
            all_courses = Course.objects.all()
            all_events = Event.objects.all()
            all_schedules = Schedule.objects.all()
            context = {'all_rooms': all_rooms,
                    'all_courses': all_courses,
                    'all_events': all_events,
                    'all_schedules': all_schedules}
            return render(request, 'form/index.html', context)


def detail(request, schedule_id):
    schedule = Schedule.objects.get(pk=schedule_id)
    context = {'schedule': schedule}
    return render(request, 'form/detail.html', context)