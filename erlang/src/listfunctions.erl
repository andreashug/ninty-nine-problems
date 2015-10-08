-module(listfunctions).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").


% #1 Find the last element of a list.

last([]) -> none;
last([X]) -> X;
last([_|T]) -> last(T).

last_0_test() ->
	?assertEqual(none, last([])).

last_1_test() ->
	?assertEqual(3, last([1, 2, 3])).


% #2 Find the last but one elements of a list.

last_two([]) -> none;
last_two([_]) -> none;
last_two([X, Y]) -> [X, Y];
last_two([_|T]) -> last_two(T).

last_two_0_test() ->
	?assertEqual([2, 3], last_two([1, 2, 3])).

last_two_1_test() ->
	?assertEqual(none, last_two([3])).


% #3 Find the k'th element of a list.

at(0, [K|_]) -> K;
at(K, [_|T]) -> at(K-1, T).

at_0_test() ->
	?assertEqual(2, at(1, [1, 2, 3])).

at_1_test() ->
	?assertEqual(3, at(2, [1, 2, 3])).


% #4 Find the number of elements of a list.

len(L) -> len_tr(L, 0).
len_tr([], L) -> L;
len_tr([_|T], L) -> len_tr(T, L+1).

len_0_test() ->
	?assertEqual(3, len([1, 2, 3])).


% #5 Reverse a list.

rev(L) -> rev_tr(L, []).
rev_tr([], R) -> R;
rev_tr([H|T], R) -> rev_tr(T, [H|R]).

rev_0_test() ->
	?assertEqual([3, 2, 1], rev([1, 2, 3])).


% #6 Find out whether a list is a palindrome.

is_palindrome(L) -> is_palindrome_inner(L, []).
is_palindrome_inner([_|R], R) -> true;
is_palindrome_inner(R, R) -> true;
is_palindrome_inner([_|T], R) when length(R) >= length(T) -> false;
is_palindrome_inner([H|T], R) -> is_palindrome_inner(T, [H|R]).

is_palindrome_0_test() ->
	?assert(is_palindrome([1, 2, 3, 2, 1])).

is_palindrome_1_test() ->
	?assert(is_palindrome([1, 2, 2, 1])).

is_palindrome_2_test() ->
	?assertNot(is_palindrome([1, 2, 3, 2])).


% #7 Flatten a nested list structure.

flatten(L) -> rev(flatten_tr(L, [])).
flatten_tr([], Result) -> Result;
flatten_tr([H|T], Result) when is_list(H) -> flatten_tr(H ++ T, Result);
flatten_tr([H|T], Result) -> flatten_tr(T, [H|Result]).

flatten_0_test() ->
	?assertEqual([1, 2, 3, 4, 5], flatten([1, [2, [3]], [4, 5]])).


% #8 Eliminate consecutive duplicates of list elements.

compress(L) -> rev(compress_tr(L, none, [])).
compress_tr([], _, R) -> R;
compress_tr([H|T], H, R) -> compress_tr(T, H, R);
compress_tr([H|T], _, R) -> compress_tr(T, H, [H|R]).

compress_0_test() ->
	?assertEqual([1, 2, 3], compress([1, 2, 2, 2, 3, 3])).


% #9 Pack consecutive duplicates of list elements into sublists.

pack(L) -> rev(pack_tr(L, none, [])).
pack_tr([], _, R) -> R;
pack_tr([H|T], H, [SubList|R]) -> pack_tr(T, H, [[H|SubList]|R]);
pack_tr([H|T], _, R) -> pack_tr(T, H, [[H]|R]).

pack_0_test() ->
	?assertEqual([[1], [2, 2, 2], [3, 3]], pack([1, 2, 2, 2, 3, 3])).


% #10 Run-length encoding of a list.

encode(L) -> rev(encode_rl(L, [])).
encode_rl([], R) -> R;
encode_rl([H|T], [{H, N}|R]) -> encode_rl(T, [{H, N+1}|R]);
encode_rl([H|T], R) -> encode_rl(T, [{H, 1}|R]).

encode_0_test() ->
	?assertEqual([{a, 2}, {b, 1}, {c, 3}], encode([a, a, b, c, c, c])).


% #11 Modified run-length encoding.

modencode(L) -> rev(modencode_tr(L, [])).
modencode_tr([], R) -> R;
modencode_tr([H|T], [{H, N}|R]) -> modencode_tr(T, [{H, N+1}|R]);
modencode_tr([H|T], [H|R]) -> modencode_tr(T, [{H, 2}|R]);
modencode_tr([H|T], R) -> modencode_tr(T, [H|R]).

modencode_0_test() ->
	?assertEqual([{a, 2}, b, {c, 3}], modencode([a, a, b, c, c, c])).


% #12 Decode a run-length encoded list.

decode(L) -> rev(decode_tr(L, [])).
decode_tr([], R) -> R;
decode_tr([{I, N}|T], R) ->
	Unfold = fun
		(_, _, 0, Result) -> Result;
		(Fun, Item, Count, Result) -> Fun(Fun, Item, Count-1, [Item|Result])
	end,
	Unfolded = Unfold(Unfold, I, N, []),
	decode_tr(T, Unfolded ++ R);
decode_tr([H|T], R) -> decode_tr(T, [H|R]).

decode_test() ->
	?assertEqual([a, a, b, c, c, c], decode([{a, 2}, b, {c, 3}])).


% #14 Duplicate the elements of a list.

duplicate(L) -> rev(duplicate_tr(L, [])).
duplicate_tr([], R) -> R;
duplicate_tr([H|T], R) -> duplicate_tr(T, [H|[H|R]]).

duplicate_0_test() ->
	?assertEqual([1, 1, 2, 2, 3, 3], duplicate([1, 2, 3])).


% #15 Replicate the elements of a list a given number of times.

replicate(L, N) -> rev(replicate_tr(L, N, [])).
replicate_tr([], _, R) -> R;
replicate_tr([H|T], N, R) -> replicate_tr(T, N, [H || _ <- lists:seq(1, N)] ++ R).

replicate_0_test() ->
	?assertEqual([1, 1, 1, 2, 2, 2], replicate([1, 2], 3)).


% #16 Drop every N'th element from a list.

drop(L, N) -> rev(drop_tr(L, N, 1, [])).
drop_tr([], _, _, R) -> R;
drop_tr([_|T], N, N, R) -> drop_tr(T, N, 1, R);
drop_tr([H|T], N, I, R) -> drop_tr(T, N, I+1, [H|R]).

drop_0_test() ->
	?assertEqual([1, 2, 4, 5, 7], drop([1, 2, 3, 4, 5, 6, 7], 3)).


% #17 Split a list into two parts; the length of the first part is given.

split(L, N) -> rev(split_tr(L, N, N, [])).
split_tr([], _, 0, [S|R]) -> [rev(S)|R];
split_tr([], _, _, [R]) -> [[], rev(R)];
split_tr([H|T], N, N, []) -> split_tr(T, N, N, [[H]]);
split_tr(L, _, 1, [R]) -> [L|[rev(R)]];
split_tr([H|T], N, I, [S|R]) -> split_tr(T, N, I-1, [[H|S]|R]).

split_0_test() ->
	?assertEqual([[1, 2, 3], [4, 5]], split([1, 2, 3, 4 ,5], 3)).

split_1_test() ->
	?assertEqual([[1, 2, 3, 4], []], split([1, 2, 3, 4], 5)).


% #18 Extract a slice from a list.

slice(L, First, Last) -> rev(slice_tr(L, First, Last, [])).
slice_tr([], _, _, R) -> R;
slice_tr([H|_], _, 0, R) -> [H|R];
slice_tr([H|T], 0, Last, R) -> slice_tr(T, 0, Last-1, [H|R]);
slice_tr([_|T], First, Last, R) -> slice_tr(T, First-1, Last-1, R).

slice_0_test() ->
	?assertEqual([2, 3, 4], slice([0, 1, 2, 3, 4, 5, 6], 2, 4)).

slice_1_test() ->
	?assertEqual([2, 3, 4], slice([0, 1, 2, 3, 4], 2, 10)).


% #19 Rotate a list N places to the left.

rotate(L, N) -> rotate_tr(L, N, []).
rotate_tr([], _, R) -> R;
rotate_tr(L, 0, R) -> L ++ rev(R);
rotate_tr([H|T], N, R) -> rotate_tr(T, N-1, [H|R]).

rotate_0_test() ->
	?assertEqual([3, 4, 5, 1, 2], rotate([1, 2, 3, 4, 5], 2)).


% #20 Remove the K'th element from a list.

remove_at(L, N) -> remove_at_tr(L, N, []).
remove_at_tr([], _, R) -> {rev(R), none};
remove_at_tr([H|T], 0, R) -> {rev(R) ++ T, H};
remove_at_tr([H|T], N, R) -> remove_at_tr(T, N-1, [H|R]).

remove_at_0_test() ->
	?assertEqual({[0, 1, 3, 4], 2}, remove_at([0, 1, 2, 3, 4], 2)).

remove_at_1_test() ->
	?assertEqual({[0, 1, 2, 3, 4], none}, remove_at([0, 1, 2, 3, 4], 9)).


% #21 Insert an element at a given position into a list.

insert_at(L, N, Item) -> insert_at_tr(L, N, Item, []).
insert_at_tr([], _, Item, R) -> rev([Item|R]);
insert_at_tr(L, 0, Item, R) -> rev(R) ++ [Item|L];
insert_at_tr([H|T], N, Item, R) -> insert_at_tr(T, N-1, Item, [H|R]).

insert_at_0_test() ->
	?assertEqual([0, 1, x, 2, 3], insert_at([0, 1, 2, 3], 2, x)).

insert_at_1_test() ->
	?assertEqual([0, 1, 2, 3, x], insert_at([0, 1, 2, 3], 9, x)).


% #22 Create a list containing all integers within a given range.

range(First, Last) -> range_tr(First, Last, []).
range_tr(First, First, R) -> [First|R];
range_tr(First, Last, R) -> range_tr(First, Last-1, [Last|R]).

range_0_test() ->
	?assertEqual([2, 3, 4, 5], range(2, 5)).


% #23 Extract a given number of randomly selected elements from a list.

rand_select(L, N) -> rand_select_tr(L, N, []).
rand_select_tr([], _, R) -> R;
rand_select_tr(_, 0, R) -> R;
rand_select_tr(L, N, R) ->
	RandomInt = random:uniform(len(L)),
	{L2, Item} = remove_at(L, RandomInt),
	rand_select_tr(L2, N-1, [Item|R]).

rand_select_0_test() ->
	?assertEqual(3, len(rand_select([1, 2, 3, 4, 5, 6], 3))).

rand_select_1_test() ->
	?assertEqual([a, a, a], rand_select([a, a, a, a, a, a], 3)).


% #24 Draw N different random numbers from the set 1..M.

lotto_select(N, Max) ->
	lotto_select_tr(N, Max, []).
lotto_select_tr(0, _, L) -> L;
lotto_select_tr(N, Max, L) ->
	Number = random:uniform(Max),
	case lists:member(Number, L) of
		true -> lotto_select_tr(N, Max, L);
		false -> lotto_select_tr(N-1, Max, [Number|L])
	end.

lotto_select_test() ->
	?assertEqual(3, len(lotto_select(3, 10))).
