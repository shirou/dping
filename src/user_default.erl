-module(user_default).
-export([help/0, dping/1, dping/2, members/0, join/1]).

help() ->
    io:format([
               "distributed ping:\n",
               "  help()     - Display this screen.\n",
               "  dping(url) - check the url \n",
               "  q()        - Quit.\n\n"
              ]).

dping(Address) ->
    dping:dping(Address).
dping(Address, N) ->
    dping:dping(Address, N).

members() ->
    {ok, Ring} = riak_core_ring_manager:get_my_ring(),
	    riak_core_ring:all_members(Ring).

join(NodeToJoin) ->
	    case net_adm:ping(NodeToJoin) of
        pong ->
				riak_core_gossip:send_ring(NodeToJoin, node()),
				io:format("Joining to node ~p~n", [NodeToJoin]),
				ok;
			        pang ->            io:format("Could not find node ~p~n", [NodeToJoin]),
            error
    end.
