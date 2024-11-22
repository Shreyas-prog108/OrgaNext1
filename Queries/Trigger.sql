CREATE OR REPLACE FUNCTION ScheduleTriggerFunction()
RETURNS TRIGGER AS 
$$
BEGIN
    IF (TG_OP = 'DELETE') THEN
         INSERT INTO ScheduleAuditTimeChange (ScheduleID, OldScheduledDate, OldStartTime, OldEndTime, ActionType)
         VALUES (OLD.ScheduleID, OLD.ScheduledDate, OLD.StartTime, OLD.EndTime,'DELETE');
         INSERT INTO ScheduleAuditRoomChange (ScheduleID, OldRoomAssignmentID, ActionType)
         VALUES (OLD.ScheduleID, OLD.RoomAssignmentID,'DELETE');
         INSERT INTO ScheduleAuditRecurringStats(ScheduleID, OldRecurringStat, OldRecurringStartDate, OldRecurringEndDate, OldDayOfWeek, ActionType)
         VALUES (OLD.ScheduleID, OLD.RecurringStat, OLD.RecurringStartDate, OLD.RecurringEndDate, OLD.DayOfWeek, 'DELETE' );
         RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN 
         IF (OLD.RoomAssignmentID IS DISTINCT FROM NEW.RoomAssignmentID) THEN 
            INSERT INTO ScheduleAuditRoomChange (ScheduleID, OldRoomAssignmentID, NewRoomAssignmentID, ActionType)
            VALUES (OLD.ScheduleID, OLD.RoomAssignmentID, NEW.RoomAssignmentID,'ROOM_UPDATE');
         END IF;
         IF (OLD.ScheduledDate IS DISTINCT FROM NEW.ScheduledDate) THEN 
            INSERT INTO ScheduleAuditTimeChange (ScheduleID, OldScheduledDate, NewScheduledDate, ActionType)
            VALUES (OLD.ScheduleID, OLD.ScheduledDate, NEW.ScheduledDate,'DATE_UPDATE');
         END IF;
         IF (OLD.StartTime IS DISTINCT FROM NEW.StartTime) OR (OLD.EndTime IS DISTINCT FROM NEW.EndTime) THEN 
            INSERT INTO ScheduleAuditTimeChange (ScheduleID, OldStartTime, NewStartTime, OldEndTime, NewEndTime, ActionType)
            VALUES (OLD.ScheduleID, OLD.StartTime, NEW.StartTime, OLD.EndTime, NEW.EndtTime,'TIME_UPDATE');
         END IF;
         IF (OLD.Recurring IS DISTINCT FROM NEW.Recurring) THEN 
            IF (NEW.Recurring) THEN 
                INSERT INTO ScheduleAuditRecurringStats (ScheduleID, OldRecurringStat, NewRecurringStat, NewDayOfWeek, NewRecurringStartDate, NewRecurringEndDate,ActionType)
                VALUES (OLD.ScheduleID, OLD.Recurring, NEW.Recurring,NEW.DayOfWeek, NEW.RecurringStartDate, NEW.RecurringEndDate, 'NewRecurring');
            ELSE
               INSERT INTO ScheduleAuditRecurringStats (ScheduleID, OldRecurringStat, NewRecurringStat, OldDayOfWeek, OldRecurringStartDate, OldRecurringEndDate, ActionType)
                VALUES (OLD.ScheduleID, OLD.Recurring, NEW.Recurring, OLD.DayOfWeek, OLD.RecurringStartDate, OLD.RecurringEndDate, 'CanceledRecurring');
            END IF;
         END IF;
         IF (OLD.DayOfWeek IS DISTINCT FROM NEW.DayOfWeek) THEN 
            INSERT INTO ScheduleAuditRecurringStats (ScheduleID, OldDayOfWeek, NewDayOfWeek,ActionType)
            VALUES (OLD.ScheduleID, OLD.DayOfWeek, NEW.DayOfWeek,'RecurringDay_UPDATE');
         END IF;
         IF (OLD.RecurringStartDate IS DISTINCT FROM NEW.RecurringStartDate) OR (OLD.RecurringEndDate IS DISTINCT FROM NEW.RecurringEndDate)THEN 
            INSERT INTO ScheduleAuditRecurringStats (ScheduleID, OldRecurringStartDate, NewRecurringStartDate, OldRecurringEndDate,NewRecurringEndDate,ActionType)
            VALUES (OLD.ScheduleID, OLD.RecurringStartDate, NEW.RecurringStartDate, OLD.RecurringEndDate,NEW.RecurringEndDate,'RecurringDate_UPDATE');
         END IF;
         RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER ScheduleChangeTrigger
AFTER DELETE OR UPDATE ON Schedule
FOR EACH ROW
EXECUTE FUNCTION ScheduleTriggerFunction();