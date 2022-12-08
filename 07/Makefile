name = solve

run: compile
	@./$(name).out

compile:
	@gcc $(name).c -o $(name).out

debug:
	@gcc $(name).c -ggdb -o $(name).out.debug
	@gdb $(name).out.debug