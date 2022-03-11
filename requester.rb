module Requester
  def select_main_menu_action
    # prompt the user for the "random | scores | exit" actions
    options = ["random", "scores", "exit"]
    action = ""
    until options.include?(action)
      puts options.join(" | ")
      print "> "
      action = gets.chomp
      puts "Invalid option" unless options.include?(action)
      puts "-" * 50
    end
    action
  end

  def ask_question(question)
    puts "Category: #{question[:category]} | Difficulty: #{question[:difficulty]}"
    puts "Question: #{question[:question]}"
    incorrect_answers = question[:incorrect_answers]
    correct_answer = question[:correct_answer]
    options = incorrect_answers.clone.append(correct_answer).shuffle!
    options.each_with_index { |option, index| puts "#{index + 1}. #{option}" }
    print "> "
    answer = gets.chomp.to_i
    [answer, correct_answer, options]
  end

  def will_save?(score)
    # prompt the user to give the score a name if there is no name given, set it as Anonymous
    puts "Well done! Your score is: #{score}"
    puts "-" * 50
    action = ""
    until ["y", "n"].include?(action)
      puts "Do you want to save your score? (y/n)"
      print "> "
      action = gets.chomp.downcase
      puts "Invalid option" unless ["y", "n"].include?(action)
    end

    if action == "y"
      puts "Type the name to assign to the score"
      print "> "
      name = gets.chomp
      name = "Anonymous" if name.empty?
      return true, name
    end
    return false if action == "n"
  end
end
