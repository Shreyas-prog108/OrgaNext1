from django.contrib import admin

from .models import Faculty, Course, Building, Room, Department, Staff, Event, Roomassignment, Schedule

models_list = [Faculty, Course, Building, Room, Department, Staff, Event, Roomassignment, Schedule]

admin.site.register(models_list)