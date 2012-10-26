%TODO: support 'nulls last'

select(select_node(S)) --> nonreq_subquery(S).
select(select_node(S)) --> subquery(S).

subquery(subquery_node(SQL, 'UNION', SQR)) --> nonreq_subquery(SQL), ['UNION'], subquery(SQR).
subquery(subquery_node(SQL, 'UNION', SQR, OB)) --> nonreq_subquery(SQL), ['UNION'], subquery(SQR), top_order_by_clause(OB).
subquery(subquery_node(SQL, 'UNION ALL', SQR)) --> nonreq_subquery(SQL), ['UNION ALL'], subquery(SQR).
subquery(subquery_node(SQL, 'UNION ALL', SQR, OB)) --> nonreq_subquery(SQL), ['UNION ALL'], subquery(SQR), top_order_by_clause(OB).
subquery(subquery_node(SQL, 'INTERSECT', SQR)) --> nonreq_subquery(SQL), ['INTERSECT'], subquery(SQR).
subquery(subquery_node(SQL, 'INTERSECT', SQR, OB)) --> nonreq_subquery(SQL), ['INTERSECT'], subquery(SQR), top_order_by_clause(OB).
subquery(subquery_node(SQL, 'MINUS', SQR)) --> nonreq_subquery(SQL), ['MINUS'], subquery(SQR).
subquery(subquery_node(SQL, 'MINUS', SQR, OB)) --> nonreq_subquery(SQL), ['MINUS'], subquery(SQR), top_order_by_clause(OB).
subquery(subquery_node('(', SQ, ')')) --> ['('], nonreq_subquery(SQ), [')'].
subquery(subquery_node('(', SQ, ')', OB)) --> ['('], nonreq_subquery(SQ), [')'], top_order_by_clause(OB).

nonreq_subquery(subquery_node(SQ)) --> query_block(SQ).
nonreq_subquery(subquery_node(SQ, OB)) --> query_block(SQ), top_order_by_clause(OB).

query_block(query_block_node(SP,SLP,FP,TRP)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP).
query_block(query_block_node(SP,SLP,FP,TRP,WC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), where_clause(WC).
%DUP? query_block(query_block_node(SP,SLP,FP,TRP,OBC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), top_order_by_clause(OBC).
query_block(query_block_node(SP,SLP,FP,TRP,GC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), group_by_clause(GC).
%DUP? query_block(query_block_node(SP,SLP,FP,TRP,GC,OBC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), group_by_clause(GC), top_order_by_clause(OBC).
%DUP? query_block(query_block_node(SP,SLP,FP,TRP,WC,OBC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), where_clause(WC), top_order_by_clause(OBC).
query_block(query_block_node(SP,SLP,FP,TRP,WC,GC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), where_clause(WC), group_by_clause(GC).
%DUP? query_block(query_block_node(SP,SLP,FP,TRP,WC,GC,OBC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), where_clause(WC), group_by_clause(GC), top_order_by_clause(OBC).

select_block(select_kw('select')) --> ['select'].

select_list(select_list_node(S)) --> select_item(S).
%select_list(select_list_node(SELECT_TERM, ',', REST)) --> [SELECT_TERM], [','], select_list(REST).
select_list(select_list_node(SELECT_ITEM, ',', REST)) --> select_item(SELECT_ITEM), [','], select_list(REST).

select_item(select_item_node(SELECT_TERM)) --> [SELECT_TERM].
select_item(select_item_node(SELECT_TERM, 'as', ALIAS)) --> [SELECT_TERM], ['as'], [ALIAS].

from(from_kw('from')) --> ['from'].

table_reference(table_reference_node('(', SQ, ')')) --> ['('], select(SQ), [')'].
table_reference(table_reference_node('(', JC, ')')) --> ['('], join_clause(JC), [')'].
table_reference(table_reference_node(TA)) --> maybe_aliased_expr(TA).
table_reference(table_reference_node(JC)) --> simple_join_clause(JC).
table_reference(table_reference_node(JC)) --> join_clause(JC).

simple_join_clause(simple_join_clause_node(TA, ',', TB)) --> maybe_aliased_expr(TA), [','], maybe_aliased_expr(TB).

join_clause(join_clause_node(TA, 'inner join', TB, 'on', CONDITION)) --> [TA], ['inner join'], [TB], ['on'], condition(CONDITION).
join_clause(join_clause_node(TA, 'outer join', TB, 'on', CONDITION)) --> [TA], ['outer join'], [TB], ['on'], condition(CONDITION).
join_clause(join_clause_node(TA, 'left outer join', TB, 'on', CONDITION)) --> [TA], ['left outer join'], [TB], ['on'], condition(CONDITION).
join_clause(join_clause_node(TA, 'right outer join', TB, 'on', CONDITION)) --> [TA], ['right outer join'], [TB], ['on'], condition(CONDITION).
join_clause(join_clause_node(TA, 'left join', TB, 'on', CONDITION)) --> [TA], ['left join'], [TB], ['on'], condition(CONDITION).
join_clause(join_clause_node(TA, 'right join', TB, 'on', CONDITION)) --> [TA], ['right join'], [TB], ['on'], condition(CONDITION).
join_clause(join_clause_node(TA, 'join', TB, 'on', CONDITION)) --> [TA], ['join'], [TB], ['on'], condition(CONDITION).

where_clause(where_clause_node('where', CONDITION)) --> ['where'], condition(CONDITION).

group_by_clause(group_by_clause_node('group by', EXPR)) --> ['group by'], expr(EXPR).
group_by_clause(group_by_clause_node('group by', EXPR, HC)) --> ['group by'], expr(EXPR), ['having'], having_clause(HC).

having_clause(having_clause_node(CONDITION)) --> condition(CONDITION).

top_order_by_clause(top_order_by_clause_node('order', 'by', REST)) --> ['order'], ['by'], order_by_clause(REST).

order_by_clause(order_by_clause_node(EXPR, 'asc')) --> expr(EXPR).
order_by_clause(order_by_clause_node(EXPR, 'asc', ',', REST)) --> expr(EXPR), [','], order_by_clause(REST).

order_by_clause(order_by_clause_node(EXPR, 'asc')) --> expr(EXPR), ['asc'].
order_by_clause(order_by_clause_node(EXPR, 'asc', ',', REST)) --> expr(EXPR), ['asc'], [','], order_by_clause(REST).

order_by_clause(order_by_clause_node(EXPR, 'desc')) --> expr(EXPR), ['desc'].
order_by_clause(order_by_clause_node(EXPR, 'desc', ',', REST)) --> expr(EXPR), ['desc'], [','], order_by_clause(REST).

condition(condition_node(L, OP, R)) --> [L], operator(OP), [R].
condition(condition_node(L, OP, R, LOGOP, COND_REST)) --> [L], operator(OP), [R], logical_operator(LOGOP), condition(COND_REST).

operator(op('=')) --> ['='].
operator(op('>=')) --> ['>='].
operator(op('<=')) --> ['<='].
operator(op('<')) --> ['<'].
operator(op('>')) --> ['>'].
operator(op('!=')) --> ['!='].
operator(op('<>')) --> ['<>'].

logical_operator(logop('and')) --> ['and'].
logical_operator(logop('or')) --> ['or'].

maybe_aliased_expr(maybe_aliased_expr(E, 'as', ALIAS)) --> [E], ['as'], [ALIAS], {ALIAS \= ','}.
maybe_aliased_expr(maybe_aliased_expr(E, ALIAS)) --> [E], [ALIAS], {ALIAS \= ','}.
maybe_aliased_expr(maybe_aliased_expr(E)) --> [E].

expr(expr(E)) --> logical_operator(E), {!, fail}.
expr(expr(E)) --> operator(E), {!, fail}.
expr(expr(E)) --> [E].

%tests
%query_block(Tree, ['select', '*', 'from', 'a', 'where', 'col1', '=', '1', 'and', 'col2', '=', '2'], []).
%query_block(Tree, ['select', '*', 'from', 'a', 'where', 'col1', '=', '1'], []).
%query_block(Tree, ['select', '*', 'from', 'a'], []).
%query_block(Tree, ['select', '*', 'from', 'a', 'group by', 'col1'], []).
%query_block(Tree, ['select', '*', 'from', 'a', 'group by', 'col1', 'having', 'col1', '>', '100'], []).
%query_block(Tree, ['select', 'col1', ',', 'col2', 'from', 'a', 'group by', 'col1', 'having', 'col1', '>', '100'], []).
%query_block(Tree, ['select', 'TA.col1', ',', 'TB.col2', 'from', 'TA', 'inner join', 'TB', 'on', 'TA.col1', '=', 'TB.col1', 'group by', 'TB.col1', 'having', 'TB.col1', '>', '100'], []).
%query_block(Tree, ['select', '*', 'from', 'a', 'group by', 'col1', 'order by', 'col1', 'desc'], []). % must be false

%subquery(Tree, ['select', '*', 'from', '(', 'select', '*', 'from', 'a', 'group by', 'col1', 'order by', 'col1', 'desc', ')'], []).

% LOOPS
%select(Tree, ['select', '*', 'from', '(', 'select', '*', 'from', 'a', 'group by', 'col1', 'order by', 'col1', 'desc', ')'], []).
% END LOOPS
%select(Tree, ['select', '*', 'from', 'a', 'group by', 'col1', 'order by', 'col1', ',', 'col2'], []).
%select(Tree, ['select', '*', 'from', 'a', 'group by', 'col1', 'order by', 'col1', ',', 'col2', 'asc'], []).
%select(Tree, ['select', '*', 'from', 'a', 'group by', 'col1', 'order by', 'col1', 'desc', ',', 'col2', 'asc'], []).
%select(Tree, ['select', '*', 'from', 'a', 'order by', 'col1', ',', 'col2', 'asc'], []).
%top_order_by_clause(Tree, ['order by', 'col1', ',', 'col2', 'asc'], []).
%select(Tree, ['select', '*', 'from', '(', 'select', '*', 'from', 'a', ')'], []).
%select(Tree, ['select', 'tsur.icompany,', 'tsur.inflight,', 'tleg.idepflight,', 'tsur.iboardpnt,', 'tsur.ioffpoint,', 'tsur.icabin,', 'tsur.irbd,', '0', 'as', 'subclass,', 'tsur.qshowup,', '0', 'as', 'etb', 'from', 'tbmzsleg', 'tleg,', 'tbmzssur', 'tsur', 'where', 'tsur.icompany', '=', 'tleg.icompany', 'and', 'tsur.inflight', '=', 'tleg.inflight', 'and', 'tsur.ideparture', '=', 'tleg.edeparture', 'and', 'tsur.iboardpnt', '=', 'tleg.eboardpnt', 'and', 'tsur.ioffpoint', '=', 'tleg.eoffpoint', 'and', 'trunc(tleg.edeparture)', '>=', 'trunc(sysdate)', 'and', 'trunc(tleg.edeparture)', '<=', 'trunc(sysdate)+1', 'order', 'by', 'tsur.icompany,', 'tsur.inflight,', 'tsur.ideparture,', 'tsur.iboardpnt,', 'tsur.ioffpoint,', 'tsur.icabin,', 'tsur.irbd'], []).