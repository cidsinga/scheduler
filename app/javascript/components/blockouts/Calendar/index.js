import React from 'react'
import SchedulerContext from 'blockouts/contexts/scheduler'
import PropTypes from 'prop-types'
import DayPicker from 'react-day-picker'

const Calendar = ({ blockouts }) =>
  <SchedulerContext.Consumer>
    {({ setCalendarMonth }) => (
      <DayPicker
        modifiers={{
          highlighted: blockouts.flat().map(b => b.range.start.toDate())
        }}
        onMonthChange={setCalendarMonth}
      />
    )}
  </SchedulerContext.Consumer>

Calendar.propTypes = {
  blockouts: PropTypes.array
}

export default Calendar
