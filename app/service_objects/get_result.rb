# frozen_string_literal: true

class GetResult
  attr_accessor :user, :exam, :answers, :result

  def initialize(user, exam_id, answers)
    @user = user
    @exam = Exam.find_by(id: exam_id)
    @answers = answers
    @result = 0
  end

  def call
    compare_score
  end

  private

  def compare_score
    user_correct_score = 0
    correct_answers = exam.questions.map { |x| x['options'][x['answer'] - 1] }
    correct_answers.each_with_index do |value, index|
      user_correct_score += 1 if value == answers[index]
    end
    @result = (user_correct_score / correct_answers.count.to_f).round(2) * 100
    examinee = Examinee.create(score: result)
    user.examinees << examinee
    exam.examinees << examinee
    CreateNotification.new(user, 'hamro_job@gmail.com', user.email, message).call
    examinee
  end

  def message
    @result >= 40 ? %(<h1>#{exam.name} Result</h1>
      <h3>Congratulations you scored #{result}!!</h3>
      <p>You acquired #{exam.skill_name} Skill and passed the test</p>
      <p>Now you can apply for jobs with <b>#{exam.skill_name}</b> skill. </p>
      <p>Thank you!</p>
    ) : %(<h1>#{exam.name} Result</h1>
      <h3>You scored #{result} and failed the test</h3>
      <p>Sorry Please try again when the exam reopens.</p>
      <p>Thank you!</p>
    )
  end
end
