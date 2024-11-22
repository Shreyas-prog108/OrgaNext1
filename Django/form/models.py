from django.db import models


class Faculty(models.Model):
    facultyid = models.AutoField(primary_key=True)
    facultyfirstname = models.CharField(max_length=20)
    facultylastname = models.CharField(max_length=20)
    facultyemail = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'faculty'


class Course(models.Model):
    courseid = models.AutoField(primary_key=True)
    coursename = models.CharField(max_length=50)
    instructorid = models.ForeignKey(Faculty, models.DO_NOTHING, db_column='instructorid', blank=True, null=True)
    academicyear = models.DecimalField(max_digits=4, decimal_places=0)
    academicsemester = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'course'


class Building(models.Model):
    buildingid = models.AutoField(primary_key=True)
    buildingname = models.CharField(max_length=10)
    buildingaddress = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'building'


class Room(models.Model):
    roomid = models.AutoField(primary_key=True)
    roomname = models.CharField(max_length=15)
    buildingid = models.ForeignKey(Building, models.DO_NOTHING, db_column='buildingid', blank=True, null=True)
    capacity = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'room'


class Department(models.Model):
    departmentid = models.AutoField(primary_key=True)
    departmentname = models.CharField(max_length=20, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'department'


class Staff(models.Model):
    staffid = models.AutoField(primary_key=True)
    departmentid = models.ForeignKey(Department, models.DO_NOTHING, db_column='departmentid', blank=True, null=True)
    stafffirstname = models.CharField(max_length=20)
    stafflastname = models.CharField(max_length=20)
    staffemail = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'staff'


class Event(models.Model):
    eventid = models.AutoField(primary_key=True)
    eventname = models.CharField(max_length=50)
    maincontact = models.ForeignKey(Staff, models.DO_NOTHING, db_column='maincontact', blank=True, null=True, related_name = 'maincontact')
    secondcontact = models.ForeignKey(Staff, models.DO_NOTHING, db_column='secondcontact', blank=True, null=True,  related_name = 'secondcontact')

    class Meta:
        managed = False
        db_table = 'event'


class Roomassignment(models.Model):
    roomassignmentid = models.AutoField(primary_key=True)
    eventid = models.ForeignKey(Event, models.DO_NOTHING, db_column='eventid', blank=True, null=True)
    courseid = models.ForeignKey(Course, models.DO_NOTHING, db_column='courseid', blank=True, null=True)
    roomid = models.ForeignKey(Room, models.DO_NOTHING, db_column='roomid')
    expectedparticipant = models.IntegerField()
    detail = models.CharField(max_length=200, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'roomassignment'


class Schedule(models.Model):
    scheduleid = models.AutoField(primary_key=True)
    roomassignmentid = models.ForeignKey(Roomassignment, models.DO_NOTHING, db_column='roomassignmentid', blank=True, null=True)
    scheduleddate = models.DateField(blank=True, null=True)
    starttime = models.TimeField()
    endtime = models.TimeField()
    recurring = models.BooleanField()
    dayofweek = models.TextField(blank=True, null=True)
    recurringstartdate = models.DateField(blank=True, null=True)
    recurringenddate = models.DateField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'schedule'
