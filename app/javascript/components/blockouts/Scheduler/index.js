import React from 'react'
import PropTypes from 'prop-types'
import SchedulerContext from 'blockouts/contexts/scheduler'
import Calendar from 'blockouts/Calendar'
import BlockoutList from 'blockouts/BlockoutList'
import AddBlockoutButton from 'blockouts/AddBlockoutButton'
import Modal from 'blockouts/Modal'
import splitblockoutsWithDays from 'blockouts/helpers/splitBlockoutsByDay'
import expandRecurringBlockOuts from 'blockouts/helpers/expandRecurringBlockouts'
import makeRequestFn from 'blockouts/helpers/makeRequest'

class Scheduler extends React.Component {
  setCalendarMonth = calendarMonth => this.setState({ calendarMonth: moment(calendarMonth).startOf('month') })
  setModalInfo = modalInfo => this.setState({ modalInfo })
  getParentBlockoutById = id => this.state.blockouts.find(blockout => blockout.id === id)

  updateBlockoutsState = blockoutsToUpdate => {
    const { state: { blockouts } } = this
    const ids = blockoutsToUpdate.map(b => b.id)
    this.setState({
      blockouts: [
        ...blockouts.filter(b => !ids.includes(b.id)),
        ...blockoutsToUpdate
      ]
    })
  }

  removeBlockoutFromState = blockoutId => {
    const { state: { blockouts } } = this
    this.setState({
      blockouts: blockouts.filter(b => b.id !== blockoutId)
    })
  }

  state = {
    blockouts: this.props.blockouts,
    calendarMonth: moment().startOf('month'),
    setCalendarMonth: this.setCalendarMonth,
    modalInfo: {},
    setModalInfo: this.setModalInfo,
    updateBlockoutsState: this.updateBlockoutsState,
    makeRequest: makeRequestFn(this.props.authenticity_token),
    removeBlockoutFromState: this.removeBlockoutFromState,
    getParentBlockoutById: this.getParentBlockoutById
  }

  render () {
    const { state: { blockouts, calendarMonth } } = this
    const blockoutsWithDays = splitblockoutsWithDays(
      expandRecurringBlockOuts(blockouts, calendarMonth),
      calendarMonth
    )
    return (
      <SchedulerContext.Provider value={{ ...this.state, ...{ authenticityToken: this.props.authenticity_token } }}>
        <React.Fragment>
          <Modal />
          <Calendar blockouts={blockoutsWithDays} />
          <AddBlockoutButton />
          <BlockoutList blockoutsWithDays={blockoutsWithDays} />
        </React.Fragment>
      </SchedulerContext.Provider>
    )
  }
}

Scheduler.propTypes = {
  blockouts: PropTypes.array
}
export default Scheduler
