# frozen_string_literal: true

class GetResult
  attr_accessor :user, :exam, :answers

  def initialize(user, exam_id, answers)
    @user = user
    @exam = Exam.find_by(id: exam_id)
    @answers = answers
  end

  def call
    compare_score
  end

  private

  def compare_score
    user_correct_score = 0
    correct_answers = exam.questions.map { |x| x["options"][x["answer"] - 1] }
    correct_answers.each_with_index do |value, index|
      user_correct_score += 1 if value == answers[index]
    end
    result = (user_correct_score / correct_answers.count.to_f).round(2) * 100
    examinee = Examinee.create(score: result)
    user.examinees << examinee
    exam.examinees << examinee
    examinee
  end
end
