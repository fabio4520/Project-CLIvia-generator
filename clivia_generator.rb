# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies
require_relative 'presenter'

filename = ARGV.shift

class CliviaGenerator
  include Presenter
  # maybe we need to include a couple of modules?

  def initialize(filename = "scores.json")
    # we need to initialize a couple of properties here
    @filename = filename
  end

  def start
    # welcome message
    print_welcome
    action = ""
    until action == "exit"
      action = get_option
      case action
      when "random" then puts "random"
      when "scores" then puts "scores"
      when "exit" then puts "Bye! 😎"
      end
    end
  end

  def random_trivia
    # load the questions from the api
    # questions are loaded, then let's ask them
  end

  def ask_questions
    # ask each question
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
  end

  def save(data)
    # write to file the scores data
  end

  def parse_scores
    # get the scores data from file
  end

  def load_questions
    # ask the api for a random set of questions
    # then parse the questions
  end

  def parse_questions
    # questions came with an unexpected structure, clean them to make it usable for our purposes
  end

  def print_scores
    # print the scores sorted from top to bottom
  end
end

trivia = CliviaGenerator.new(filename)
trivia.start
