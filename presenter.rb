module Presenter
  def print_welcome
    # print the welcome message
    welcome = ["###################################",
    "#   Welcome to Clivia Generator   #",
    "###################################"]
    puts welcome.join("\n")
  end

  def get_option
    options = ["random", "scores", "exit"]
    action = ""
    until options.include?(action)
      puts options.join(" | ")
      print "> "
      action = gets.chomp
      puts "Invalid option" if !options.include?(action)
      puts "-" * 50
    end
    action
  end

  def print_score(score)
    # print the score message
  end
end
