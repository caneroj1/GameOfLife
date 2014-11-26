require_relative 'game_window.rb'

window = GameWindow.new(ARGV[0] ? ARGV[0].to_i : 480,
                        ARGV[1] ? ARGV[1].to_i : 480)
window.show
