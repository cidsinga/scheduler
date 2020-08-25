# frozen_string_literal: true

class Office < ApplicationRecord
  extend DateRangeFilterHelper

  has_one :address, as: :addressable, dependent: :destroy
  has_many :needs, dependent: :destroy
  has_many :office_users, dependent: :destroy
  has_many :users, through: :office_users
  validates :name, :address, presence: true
  validates :region, numericality: { only_integer: true }

  accepts_nested_attributes_for :address, update_only: true

  alias_attribute :to_s, :name

  scope :with_claimed_shifts, -> (user) {
    if user.admin?
      joins(needs: :shifts).merge(Shift.claimed)
    elsif user.coordinator? || user.social_worker?
      joins(:office_users, needs: :shifts).where(office_users: { user: user }).merge(Shift.claimed)
    else
      raise 'You do not have the proper permissions'
    end
  }

  scope :with_claimed_needs, -> (user) {
    if user.admin?
      joins(:needs).merge(Need.has_claimed_shifts)
    elsif user.coordinator? || user.social_worker?
      joins(:office_users, :needs).where(office_users: { user: user }).merge(Need.has_claimed_shifts)
    else
      raise 'You do not have the proper permissions'
    end
  }

  alias_attribute :to_s, :name

  def self.total_volunteer_hours_by_office(current_user, start_at, end_at)
    with_claimed_shifts(current_user)
      .then { |scope| filter_by_date_range(scope, start_at, end_at) } 
      .group(:id, :name)
      .sum('shifts.duration / 60.0')
  end

  def self.total_volunteer_hours_by_state(current_user, start_at, end_at)
    with_claimed_shifts(current_user)
      .joins(:address)
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .group('addresses.state')
      .sum('shifts.duration / 60.0')
  end

  def self.total_volunteer_hours_by_county(current_user, state, start_at, end_at)
    with_claimed_shifts(current_user)
      .joins(:address)
      .where(addresses: { state: state })
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .group('addresses.county')
      .sum('shifts.duration / 60.0')
  end

  def self.total_children_served_by_office(current_user, start_at, end_at)
    with_claimed_needs(current_user)
      .group(:id, :name)
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .sum('needs.number_of_children')
  end

  def self.total_children_served_by_state(current_user, start_at, end_at)
    with_claimed_needs(current_user)
      .joins(:address)
      .group('addresses.state')
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .sum('needs.number_of_children')
  end

  def self.total_children_served_by_county(current_user, state, start_at, end_at)
    with_claimed_needs(current_user)
      .joins(:address)
      .where(addresses: { state: state })
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .group('addresses.county')
      .sum('needs.number_of_children')
  end

  def self.total_children_by_demographic(current_user, start_at, end_at)
    joins(needs: :preferred_language)
      .then { |scope| scope_by_office_users_if_coordinator(scope, current_user) }
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .group('languages.name')
      .sum('needs.number_of_children')
  end

  def self.total_volunteers_by_race(current_user, start_at, end_at)
    joins(:needs, users: :race)
      .then { |scope| scope_by_office_users_if_coordinator(scope, current_user) }
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .group('races.name')
      .count('users.id')
  end

  def self.needs_satisfied_by_office(current_user, start_at, end_at)
    offices = joins(:needs)
      .includes(:address, :needs)
      .then { |scope| scope_by_office_users_if_coordinator(scope, current_user) }
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }

    [
      percent_satisfied_by_office(offices),
      percent_satisfied_by_state(offices),
      percent_satisfied_total(offices)
    ].flatten(1)
  end

  def notifiable_users
    users.notifiable
  end

  private

  def self.scope_by_office_users_if_coordinator(scope, user)
    if user.admin?
      scope
    elsif user.coordinator?
      scope.joins(:office_users).where(office_users: { user: user })
    else
      raise 'You do not have the proper permissions'
    end
  end

  def self.percent_satisfied_by_office(offices)
    offices.reduce([]) do |arr, office|
      arr << [office.name, needs_satisfied_percent(office.needs)]
    end
  end

  def self.percent_satisfied_by_state(offices)
    offices.group_by { |o| o.address.state }.map do |state, offices_by_state|
      ar_collection_needs = Need.where(id: offices_by_state.map(&:needs).flatten.map(&:id))

      [state, needs_satisfied_percent(ar_collection_needs)]
    end
  end

  def self.percent_satisfied_total(offices)
    ar_collection_needs = Need.where(id: offices.map(&:needs).flatten.map(&:id))

    [["All Offices", needs_satisfied_percent(ar_collection_needs)]]
  end

  def self.needs_satisfied_percent(needs)
    "#{(needs.joins(:shifts).uniq.count.fdiv(needs.count) * 100).round}%"
  end
end
