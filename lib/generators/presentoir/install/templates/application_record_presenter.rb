module Presenters
  class ApplicationRecordPresenter < ApplicationPresenter
    include AuthorizationSetup

    attr_accessor :record

    def initialize(record)
      fail 'TypeError!' unless record.is_a?(ActiveRecord::Base)
      @record = record
    end

    # extend presenter base method:
    def type
      record.class.name or super
    end

    def uuid
      record.try(:id)
    end

    def created_at
      record.try(:created_at)
    end

    def updated_at
      record.try(:updated_at)
    end

    def self.delegate_to_record(*args)
      delegate_to :record, *args
    end

    def policy_for(user)
      raise TypeError, 'Not a User!' unless (user.nil? or user.is_a?(User))
      auth_policy(user, record)
    end
  end
end
