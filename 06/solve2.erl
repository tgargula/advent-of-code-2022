-module(solve2).
-export([start/0]).

start() ->
	FileName = "data/input.txt",
	Data = readfile(FileName),
	case get_marker(Data, 14) of 
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

get_marker(X, _) when erlang:length(X) < 14 ->
	{error, -1};

get_marker(Data, Position) ->
    case is_unique(lists:sublist(Data, 14)) of
        true -> {ok, Position};
        _ -> 
            [_ | T] = Data,
            get_marker(T, Position + 1)
    end.

is_unique(Data) ->
    case erlang:length(lists:usort(Data)) - erlang:length(Data) of
        0 -> true;
        _ -> false
    end.