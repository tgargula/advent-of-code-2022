-module(solve1).
-export([start/0]).

start() ->
	FileName = "data/input.txt",
	Data = readfile(FileName),
	case get_marker(Data, 4) of 
		{ok, Result} -> 
			io:format("~p~n", [Result]);
		{error, _} -> 
			io:format("An error occurred~n");
		_ ->
			io:format("Unknown response~n")
	end.

readfile(FileName) ->
	{ok, Data} = file:read_file(FileName),
	[Binary] = binary:split(Data, [<<"\n">>], [global]),
	erlang:binary_to_list(Binary).

get_marker(X, _) when erlang:length(X) < 4 ->
	{error, -1};

get_marker([H1 | [H2 | [H3 | [H4 | _]]]], Position) when
		H1 /= H2 andalso H1 /= H3 andalso H1 /= H4 andalso H2 /= H3 andalso H2 /= H4 andalso H3 /= H4 ->
	{ok, Position};

get_marker([_ | T], Position) ->
	get_marker(T, Position + 1).
