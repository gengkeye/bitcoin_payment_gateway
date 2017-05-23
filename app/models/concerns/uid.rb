  module Uid
    extend ActiveSupport::Concern

    included do
      before_create :create_uid
    end

    private

    def create_uid
      begin
        self.uid = SecureRandom.hex
      end while self.class.exists?(uid: uid)
    end
  end