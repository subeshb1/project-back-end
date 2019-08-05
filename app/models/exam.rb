# frozen_string_literal: true

class Exam < ApplicationRecord
  has_many :examinees
  has_and_belongs_to_many :categories
end
