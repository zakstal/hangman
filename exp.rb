chars = "*"
line = [["**************"],
		["**HHHHHH******"],
		["**************"],
		]
line[1][0].each_char.each_with_index do |char, ind|
	# p line[1][0][ind]
	p line[1][0][ind] = chars if ind == 4
end

p line