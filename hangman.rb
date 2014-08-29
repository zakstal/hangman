# require 'pp'

module GameVoice
	def voice
		{ 	:guesses_left 	=> "  You have #{(self.word.evil == 1 ? self.word.guesses - self.word.evil_count : self.word.guesses - self.word.letters_guessed.length + self.word.guessed_right)} guesses left",
			:guessed	  	=> "\n  Guessed: #{self.word.letters_guessed.split("").join(" ")}\n",
			:correct		=> "  #{self.word.show}",
			:win_loose 		=> (if self.word.w_l == true
									"\n\n#{self.word.word}\n\nYou Won!\n"
									# `say 'You Won!'` 
								elsif self.word.w_l == false
									"\n\nThe word was #{self.word.word}\n\nYour man got hung. You loose" 
									# `say 'looser'`
								end),
			:choose 		=> "How many words do you want?",
			:intro			=> (
								"\n\n  How long do you want your word to be? or type any key for a random length\n\n\n\tTo turn on or off evil mode (your word will be replaced by a word\n\twith the same guessed letter) type: EVIL\n\tEvil is #{(self.word.evil == 0 ? "off" : "on")}"
								),
			:defin 			=> "\n\n#{self.word.dictionary.defin.match(/([^\[])+/)[0]}",
			:root 			=> "#{self.word.dictionary.root.match(/([^\[])+/)[0]}",
			:new_game		=> "\nNew Game?",
			:hangman 		=> "\t       H     H____.\n\t       H     H    |\n\t       H     H    =\n\t     _ HHHHHHH    U\n\t    _  H     H    \n\t*  _   H     H                     \n\tT _    H     H ang Man            \n\t"
			
		}
	end

	def put(*arr)
		arr.each do |v|
			puts voice[v]
		end
	end
	
end
module HangMan
	
	class Game_board
		include GameVoice
		#########################################################################################################
			class Man
				attr_accessor :board, :number_of_limbs, :draw_this, :extras

				def initialize(number_of_limbs)
					@board = []
					@number_of_limbs = number_of_limbs
					@draw_this = all_limbs_in_order[0..@number_of_limbs]					
					make_board
					draw_extras(0) if 1 == rand(2)
					# p @board
				end

				def change_limb_no(num)
					@number_of_limbs = num
					@draw_this = all_limbs_in_order[0..num]
					
				end

				def show_man(guesses_so_Far)
					draw(guesses_so_Far)
					@board
				end

				def hanger
					all = []

					lines = { 	"H" => %w(H A N G M A N),
								"=" => "=",
								"#" => "#",
								"*" => "*",
								">" => "~",
								"X" => "X",
								"~" => "~",
								"Z" => %w(Z A K)
							}		
					cha = lines.keys[rand(lines.keys.length)]
					i = 0
					while i < 20
						
						c = lines[cha]
						char = c[i % c.length] 

						all << [2 + i, 18, char] if i < 2
						all << [1 + i ,6, char] if i < 15
						all << [1,4 + i, char] if i < 15
						all << [16,4 + i, char] if i < 20
					i += 1
					end
					all 
				end

				def head
					i = 3
					[
						[i,18,"_"],
						[i +1,17,"/"],
						[i +1,19,"\\"],
						[i + 2,17,"\\"],
						[i + 2,19,"/"],
						[i + 3, 18,"-"]
						
					]
				end

				def neck
					[
						[6,18,"#"]
					]
				end

				def body
					i = 7
				[
					[i + 0,	17, ":"],
					[i + 0, 18, "V"],
					[i + 0, 19, ":"],
					[i + 1,	17, "|"],
					[i + 1,	18, ":"],
					[i + 1, 19, "|"],
					[i + 2,	17, "|"],
					[i + 2, 18, ":"],
					[i + 2,	19, "|"],
					[i + 3, 17, "0"],
					[i + 3, 18, "0"],
					[i + 3, 19, "0"]
				]	
				end

				def left_arm
					i = 8
				[
					[i,15,"/"],
					[i+1,14,"/"],
				]	
				end

				def rigth_arm
					i = 8
				[
					[i,21,"\\"],
					[i+1,22,"\\"],
				]	
				end

				def left_leg
					i = 11
				[
					[i,16,"/"],
					[i+1,15,"/"],
				]	
				end

				def right_leg
						i = 11
				[
					[i,20,"\\"],
					[i+1,21,"\\"],
				]	
				end
				
				def right_hand
					i = 10
					[
						[i,13,"M"]
					]
					
				end

				def left_hand
					i = 10
					[
						[i,23,"M"]
					]
					
				end

				def right_foot
					i = 13
					[
						[i,14,"*"],
						[i,13,"-"],
						[i,12,"-"]
					]
					
				end

				def left_foot
					i = 13
					[
						[i,21,"*"],
						[i,22,"-"],
						[i,23,"-"]

					]
					
				end

				def bird
					i = rand(10)
					j = rand(60)
					c = [".","'","\""]
					char = c[rand(c.length)]
					[
						[i,j,char],
						[i -1,j+1,char],
						[i -1,j+2,char],
						[i, j+3, char],
						[i-1, j+4,char],
						[i-1,j+5,char],
						[i,j+6,char]

					]
					
				end
				def horizon
					arr = []
					j = 2
					80.times{
						arr << [13,j,"~"]
						j += 1
					}
					arr
				end
				def sunset
					i = 13
					j = 35 + rand(10)
					[
						[i,j,":"],
						# [i-1,j, "'"],
						[i -1,j+1,","],
						[i -2,j+7,"."],
						[i -2,j+3,"."],
						[i -2,j+4,"."],
						[i-1,j+9,"."],
						[i -2,j+6,"."],
						[i ,j+10,":"],
						[i + 1, j+2,"~"],
						[i + 2, j+4,"~"],
						[i + 3, j+6,"~"],
						[i + 2, j+7,"~"],
						[i + 1, j+9,"~"],
						[i + 1, j+5,"~"],

					]
					
				end
				def sun
						i = 1 + rand(10)
					j = 35 + rand(10)
					[
						[i,j,":"],
						# [i-1,j, "'"],
						[i -1,j+1,","],
						[i -2,j+7,"."],
						[i -2,j+3,"."],
						[i -2,j+4,"."],
						[i-1,j+9,"."],
						[i -2,j+6,"."],
						[i ,j+10,":"],
						[i,j,":"],
						[i +1,j+1,","],
						[i +2,j+7,"."],
						[i +2,j+3,"."],
						[i +2,j+4,"."],
						[i+1,j+9,"."],
						[i +2,j+6,"."],
						[i ,j+10,":"]
					]
				end

				private

				def all_limbs_in_order
					[
					hanger,
					head,
					neck,
					body,
					left_arm,
					rigth_arm,
					right_leg,
					left_leg,
					right_hand,
					left_hand,
					right_foot,
					left_foot,	
					]
					#maybe use self.methods but only get private methids
				end
				
				def other_stuff
					arr = []
					rand(4).times{ arr << bird}
					r = rand(4)
					arr << horizon if r == 1 || r == 2 || r == 3
					arr << sunset if r == 2 || r == 3
					arr << sun if r == 1
					arr
				end

				def make_board
					line = ""
					70.times{ line << " "}
					17.times{ @board << [line.dup]}
				end

				def draw_extras(guesses_so_Far)
					other_stuff.flatten(1).each do |line|
						draw_a_line(line[0], line[1], line[2])
					end
				end

				def draw(guesses_so_Far)
					@draw_this[0..guesses_so_Far].flatten(1).each do |line|
						draw_a_line(line[0], line[1], line[2])
					end
				end

				def draw_a_line(board_line_no,character_no,character)
					@board[board_line_no][0].each_char.each_with_index do |char,ind|
						@board[board_line_no][0][character_no]  = character if character_no == ind
					end
				end
		end
		#########################################################################################################
		class Words
			class Dictionary
				attr_accessor :word, :defin, :root, :of_length
				attr_reader :dictionary
				def initialize
					@dictionary = {}
					@of_length  = []
					raw_to_dic
					get_new_word
				end

				def raw_to_dic
					dictionary 	 = 	File.readlines("dictionary.txt")
					dictionary.each do |line|
						next if line == " " 
						word 	= line.match(/^\w+/)[0].swapcase
						defin 	= line
						root 	= (if line =~ /<\w+/
										line.match(/<\w+/)[0][1..-1]
									elsif  line =~ /\{\w+/
									 	line.match(/\{\w+/)[0][1..-1] 
									else 
									 	" "
									end)
						@dictionary[word] = {defin => root}
					end
				end

				def get_word_of_length(length = 3)
					@dictionary.map { |word, def_root|
						if word.length == length
							@of_length << word
							[word,def_root] 
						end
					}.compact
				end

				def get_new_word(length = 3)
					all = get_word_of_length(length)
					word = all[rand(all.length)]	
					@word = word[0]
					word[1].each do |key, value|
						@defin = "Definition: #{key}"
						@root = value == " " ? " " : "      Root: #{@dictionary[value].keys[0]}"
					end
				end
				def assign_this_word(word)
					def_root = @dictionary[word]
					def_root.each do |key, value|
						@defin = key
						@root = value == " " ? " " : @dictionary[value].keys[0]
					end					

				end
				
			end
		attr_accessor :dictionary, :word, :word_left,:letters_guessed, :guessed_right, :word_hidden, :guesses, :w_l, :evil, :evil_count

		def initialize(word = "",guesses = 0)
			@dictionary = Dictionary.new
			@evil_count = 0
			@evil = 0
			@w_l = nil
			@guessed_right = 0
			@letters_guessed = ""
			@guesses = word.length 
			@word = word
			@word_left = word.dup.gsub(" ","")
			 hide(word)
			 
		end

		def new_word(length = 3)
			@dictionary.get_new_word(length)
			@evil_count = 0
			@w_l = nil
			@guessed_right = 0
			word = @dictionary.word
			@letters_guessed = ""
			@guesses = word.length 
			@word = word
			@word_left = word.dup.gsub(" ","")
			 hide(word)
		end

		def hide(word)
			@word_hidden =	(@word_left.empty? == true ? @word 
							: @word.gsub(/[#{word.split(" ").join}]/,"_") )
		end
			
		def show
			@w_l ? @word : @word_hidden.split("").join(" ") 
		end

		def guess(letter)
			if @w_l == nil
				if letter.length == 1
					word_included?(letter)
					
					win_or_loose?(letter)
				end
			end
		end

		def word_included?(letter)
			if letter.to_i == 0 && letter =~ /\w/ && letters_guessed.include?(letter) == false 
				@letters_guessed << letter if evil == 0#If evil mode is off, all guessed letters will be added
				@evil_count += 1 if @evil == 1
				if @word_left.include?(letter)
					@letters_guessed << letter if @evil == 1 #if evil mode is on only correct geusses will be added
					@guessed_right += 1

					hide(@word_left.gsub!(/#{letter}/,"")) 
				else
					false
				end
			end
		end


		def win_or_loose?(letter)
			if @word_left.empty?
				@w_l = true
			elsif (@letters_guessed.length - @guessed_right) == @guesses
			 	@w_l = false if @evil == 0
			elsif @evil_count == @guesses
				@w_l = false if @evil == 1
			end
		end

		def evil_maker
			if @evil == 1 && @w_l == nil
				wor = @word.dup.gsub(/[#{@word_left}]/," ")
				dictionary.of_length.each { |line_word|
					next if line_word == @word 
						match = []							#this is an array of ones and zeros to be multiplied. if any zeros than it will all be zero and it will not be a match
						line_word.each_char.each_with_index do |c,i|
							wor.each_char.each_with_index  do |ch,ind|
								if ch == " "
									next
								else
									if ch == c && i == ind
										match << 1 				#if the characters and the indexes match for both words than its a match
									elsif ch == c && i != ind
										match << 0				#if the characters match but the indexes to dont match is not a match 
									elsif ch != c && i == ind
										match << 0
									end	
								end
							end
						end
						
						if match.inject(:*) == 1
							
							if line_word.length == @word.length
								@word = line_word 
								@word_left = @word.dup.gsub(/[#{@letters_guessed}]/,"")
								@letter
								@dictionary.assign_this_word(@word)
								break
							end
						end
				}
			end
		end

	end
	
	####################################################################################################
		attr_accessor :word, :hang_man, :game_voice

		def initialize(word = "hangman")
			@word = Words.new(word)
				@hang_man = Man.new(0)
			# show_intro
			# intro_choose
		end

		def show_intro
			5.times{puts "\n"}
			put :hangman,
				:intro
			5.times{puts "\n"}
		end

		def game_end
			put :defin,
				:root,
				:new_game
				
			gets
		end

		def show_board
			g_left = @word.letters_guessed.length - @word.guessed_right
			puts @hang_man.show_man(g_left)
			put :win_loose
			if word.w_l == nil
				put :guessed, 
					:correct,
					:guesses_left
			end
		end

		def game_setup
			put(:word_length)
		end

		def guess(letter)	
			@word.guess(letter)
		end

		def intro_choose
			choice = gets.chomp
			choice = if choice.to_i != 0
						choice.to_i
					elsif choice == "e" || choice == "exit"
						exit
					else
						@word.evil = (@word.evil == 0 ? 1 :  0) if choice == "EVIL"
						
						num = 0
						until num >= 3
							num = rand(12)
						end
						num
					end
				choice

				@word.new_word(choice)
				@hang_man = Man.new(choice)
				
		end
	end

	
end

# GameVoice
w = HangMan::Game_board.new
loop do 
	w.show_intro
	w.intro_choose
	loop do
		w.show_board
		# p w.word.word
		letter = gets.chomp.downcase
		exit if letter == "exit"
		break if letter == "new"
		break if w.word.w_l != nil
		w.guess(letter)
		w.word.evil_maker
	end

	w.show_board
	w.game_end
end