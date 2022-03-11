# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies
require "httparty"
require "htmlentities"
require "terminal-table"
require_relative "presenter"
require_relative "requester"

filename = ARGV.shift
filename = "scores.json" if filename.nil?

class CliviaGenerator
  include Requester
  include Presenter
  include HTTParty
  # maybe we need to include a couple of modules?

  def initialize(filename)
    @filename = filename
    @file = File.read(@filename) if File.exist?(@filename)
    @file = File.write(@filename, "[]") unless File.exist?(@filename)
    @data_hash = JSON.parse(File.read(@filename), symbolize_names: true)
    @questions = []
    @question = {}
    @score = 0
  end

  def start
    # welcome message
    # print_welcome
    action = ""
    until action == "exit"
      begin
        print_welcome
        action = select_main_menu_action
        case action
        when "random" then random_trivia
        when "scores" then scores
        when "exit" then puts "Bye! 😎"
        end
        puts "-" * 50
      rescue HTTParty::ResponseError => e
        parsed_error = JSON.parse(e.message, symbolize_names: true)
        puts parsed_error
      end
    end
  end

  def random_trivia
    hash_questions = load_questions # hash
    questions_without_parse = hash_questions[:results] # array
    parse_questions(questions_without_parse)
    ask_questions
  end

  def ask_questions
    i = 0
    until i == @questions.length
      @question = @questions.sample # hash
      answer, correct_answer, options = ask_question(@question)
      index = answer - 1
      if index == options.find_index(correct_answer)
        puts "True... Correct Answer! 😀\n"
        @score += 10
      else
        puts "#{options[index]}... Incorrect ! 🧟‍♂️"
        puts "The correct answer was: #{options[options.find_index(correct_answer)]}\n"
      end
      puts ""
      i += 1
    end
    validation, name = will_save?(@score)
    data = { name: name, score: @score }
    save(data) if validation
    @score = 0
  end

  def save(data)
    # data = {name: name, score: @score}
    @data_hash << data
    File.write(@filename, @data_hash.to_json)
  end

  def scores
    # get the scores data from files
    arr_scores = JSON.parse(File.read(@filename), symbolize_names: true)
    print_scores(arr_scores)
  end

  def load_questions
    response = HTTParty.get("https://opentdb.com/api.php?amount=10")
    raise HTTParty::ResponseError, response unless response.success?

    JSON.parse(response.body, symbolize_names: true)
  end

  def parse_questions(questions)
    # questions came with an unexpected structure, clean them to make it usable for our purposes
    code = HTMLEntities.new
    questions.map do |question|
      hash = { category: question[:category],
               type: question[:multiple],
               difficulty: question[:difficulty],
               question: code.decode(question[:question]).delete('\\"'),
               correct_answer: code.decode(question[:correct_answer]).delete('\\"'),
               incorrect_answers: question[:incorrect_answers].map { |q| code.decode(q).delete('\\"') } }
      @questions << hash
    end
  end

  def print_scores(arr_scores)
    # print the scores sorted from top to bottom
    title = "Top Scores"
    headings = ["Name", "Score"]
    rows = arr_scores.map do |element|
      [element[:name], element[:score]]
    end
    rows = rows.sort_by { |array| array[1] }.reverse!
    puts print_score(title, headings, rows)
  end
end

trivia = CliviaGenerator.new(filename)
trivia.start
