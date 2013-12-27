-module(dping).
-include("dping.hrl").
-include_lib("riak_core/include/riak_core_vnode.hrl").

-export([
         ping/0,
         dping/1,
         dping/2
        ]).

%% @doc default node number which command will be sent.
-define(DEFAULT_NODE_NUM, 3).

%% Public API

%% @doc Pings a random vnode to make sure communication is functional
ping() ->
    DocIdx = riak_core_util:chash_key({<<"ping">>, term_to_binary(now())}),
    PrefList = riak_core_apl:get_primary_apl(DocIdx, 1, dping),
    [{IndexNode, _Type}] = PrefList,
    riak_core_vnode_master:sync_command(IndexNode, ping, dping_vnode_master).

%% @doc check url with DEFAULT_NODE_NUM(3)
dping(URL) ->
	dping(URL, ?DEFAULT_NODE_NUM).
%% @doc check url via sync_command/3
-spec dping(string(), integer()) -> ok.
dping(URL, N) ->
    Message = {dping, URL},
	io:format("command from ~p~n", [node()]),

    PrefList = riak_core_apl:active_owners(dping),
	Results = lists:map(fun({IndexNode, _Type}) ->
					  riak_core_vnode_master:sync_command(IndexNode, Message, dping_vnode_master)
			  end, lists:sublist(PrefList, N)),

	case check_results(Results, length(PrefList)) of
		success ->
			io:format("dping to ~p success.~n", [URL]);
		fail ->
			io:format("dping to ~p failed.~n", [URL])
	end.

%% @doc check target is ok or not by given results. currently, node num is not used.
-spec check_results(list(), integer()) -> atom().
check_results(Results, _Node_N) ->
	Success_N = lists:foldl(fun({R, _code, Node}, Sum) ->
									io:format("responsed node ~p ~n", [Node]),
									case R of
										success -> 1 + Sum;
										_ -> Sum
									end
							end,
							0,
							Results),
    case Success_N == length(Results) of
		true ->
			success;
		false ->
			fail
	end.
