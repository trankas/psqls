subquery(subquery(SQ)) --> query_block(SQ).
subquery(subquery(SQ, OB)) --> query_block(SQ), order_by_clause(OB).
subquery(subquery(SQL, 'UNION', SQR)) --> subquery(SQL), ['UNION'], subquery(SQR).
subquery(subquery(SQL, 'UNION', SQR, OB)) --> subquery(SQL), ['UNION'], subquery(SQR), order_by_clause(OB).
subquery(subquery(SQL, 'UNION', 'ALL', SQR)) --> subquery(SQL), ['UNION'], ['ALL'], subquery(SQR).
subquery(subquery(SQL, 'UNION', 'ALL', SQR, OB)) --> subquery(SQL), ['UNION'], ['ALL'], subquery(SQR), order_by_clause(OB).
subquery(subquery(SQL, 'INTERSECT', SQR)) --> subquery(SQL), ['INTERSECT'], subquery(SQR).
subquery(subquery(SQL, 'INTERSECT', SQR, OB)) --> subquery(SQL), ['INTERSECT'], subquery(SQR), order_by_clause(OB).
subquery(subquery(SQL, 'MINUS', SQR)) --> subquery(SQL), ['MINUS'], subquery(SQR).
subquery(subquery(SQL, 'MINUS', SQR, OB)) --> subquery(SQL), ['MINUS'], subquery(SQR), order_by_clause(OB).
subquery(subquery('(', SQ, ')')) --> ['('], subquery(SQ), [')'].
subquery(subquery('(', SQ, ')', OB)) --> ['('], subquery(SQ), [')'], order_by_clause(OB).

query_block(query_block(SP,SLP,FP,TRP)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP).
query_block(query_block(SP,SLP,FP,TRP, OBC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), order_by_clause(OBC).
query_block(query_block(SP,SLP,FP,TRP, WC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), where_clause(WC).
query_block(query_block(SP,SLP,FP,TRP, WC, OBC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), where_clause(WC), order_by_clause(OBC).
query_block(query_block(SP,SLP,FP,TRP, WC, GC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), where_clause(WC), group_by_clause(GC).
query_block(query_block(SP,SLP,FP,TRP, WC, GC, OBC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), where_clause(WC), group_by_clause(GC), order_by_clause(OBC).
query_block(query_block(SP,SLP,FP,TRP, GC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), group_by_clause(GC).
query_block(query_block(SP,SLP,FP,TRP, GC, OBC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), group_by_clause(GC), order_by_clause(OBC).

select_block(select_block('select')) --> ['select'].

select_list(select_list('*')) --> ['*'].
select_list(select_list(SELECT_TERM)) --> [SELECT_TERM].
select_list(select_list(SELECT_TERM, ',', REST)) --> [SELECT_TERM], [','], select_list(REST).

from(from('from')) --> ['from'].

table_reference(table_reference(TA)) --> [TA].
table_reference(table_reference(JC)) --> join_clause(JC).
table_reference(table_reference('(', JC, ')')) --> ['('], join_clause(JC), [')'].
table_reference(table_reference('(', SQ, ')')) --> ['('], subquery(SQ), [')'].

join_clause(join_clause(TA, 'inner join', TB, 'on', CONDITION)) --> [TA], ['inner join'], {!},[TB], ['on'], condition(CONDITION).
join_clause(join_clause(TA, 'outer join', TB, 'on', CONDITION)) --> [TA], ['outer join'], {!}, [TB], ['on'], condition(CONDITION).
join_clause(join_clause(TA, 'join', TB, 'on', CONDITION)) --> [TA], ['join'], [TB], ['on'], condition(CONDITION).

where_clause(where_clause('where', CONDITION)) --> ['where'], condition(CONDITION).

group_by_clause(group_by_clause('group by', EXPR)) --> ['group by'], expr(EXPR).
group_by_clause(group_by_clause('group by', EXPR, HC)) --> ['group by'], expr(EXPR), ['having'], having_clause(HC).

having_clause(having_clause(CONDITION)) --> condition(CONDITION).

order_by_clause(order_by_clause('order by', EXPR, 'asc')) --> ['order by'], expr(EXPR), ['asc'].
order_by_clause(order_by_clause('order by', EXPR, 'asc', 'nulls first')) --> ['order by'], expr(EXPR), ['asc'], ['nulls first'].
order_by_clause(order_by_clause('order by', EXPR, 'asc', 'nulls last')) --> ['order by'], expr(EXPR), ['asc'], ['nulls last'].
order_by_clause(order_by_clause('order by', EXPR, 'desc')) --> ['order by'], expr(EXPR), ['desc'].
order_by_clause(order_by_clause('order by', EXPR, 'desc', 'nulls first')) --> ['order by'], expr(EXPR), ['desc'], ['nulls first'].
order_by_clause(order_by_clause('order by', EXPR, 'desc', 'nulls last')) --> ['order by'], expr(EXPR), ['desc'], ['nulls last'].

condition(condition(L, OP, R)) --> [L], operator(OP), [R].
condition(condition(L, OP, R, LOGOP, COND_REST)) --> [L], operator(OP), [R], logical_operator(LOGOP), condition(COND_REST).

operator(op('=')) --> ['='].
operator(op('>=')) --> ['>='].
operator(op('<=')) --> ['<='].
operator(op('<')) --> ['<'].
operator(op('>')) --> ['>'].
operator(op('!=')) --> ['!='].
operator(op('<>')) --> ['<>'].

logical_operator(logop('and')) --> ['and'].
logical_operator(logop('or')) --> ['or'].

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
%query_block(Tree, ['select', '*', 'from', 'a', 'group by', 'col1', 'order by', 'col1', 'desc', 'nulls last'], []).
%subquery(Tree, ['select', '*', 'from', '(', 'select', '*', 'from', 'a', 'group by', 'col1', 'order by', 'col1', 'desc', 'nulls last', ')'], []).