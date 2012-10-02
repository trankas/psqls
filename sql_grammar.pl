query(query(SP,SLP,FP,TRP)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP).
query(query(SP,SLP,FP,TRP, WC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), where_clause(WC).
query(query(SP,SLP,FP,TRP, WC, GC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), where_clause(WC), group_by_clause(GC).
query(query(SP,SLP,FP,TRP, GC)) --> select_block(SP), select_list(SLP), from(FP), table_reference(TRP), group_by_clause(GC).

select_block(select_block('select')) --> ['select'].
select_block(select_block('SELECT')) --> ['SELECT'].

select_list(select_list('*')) --> ['*'].

from(from('from')) --> ['from'].
from(from('FROM')) --> ['FROM'].

table_reference(table_reference(TA)) --> [TA].
table_reference(table_reference(JC)) --> join_clause(JC).
table_reference(table_reference('(', JC, ')')) --> ['('], join_clause(JC), [')'].

join_clause(join_clause(TA, 'inner join', TB, 'on', CONDITION)) --> [TA], ['inner join'], {!},[TB], ['on'], condition(CONDITION).
join_clause(join_clause(TA, 'outer join', TB, 'on', CONDITION)) --> [TA], ['outer join'], {!}, [TB], ['on'], condition(CONDITION).
join_clause(join_clause(TA, 'join', TB, 'on', CONDITION)) --> [TA], ['join'], [TB], ['on'], condition(CONDITION).

where_clause(where_clause('where', CONDITION)) --> ['where'], condition(CONDITION).
where_clause(where_clause('WHERE', CONDITION)) --> ['WHERE'], condition(CONDITION).

group_by_clause(group_by_clause('group by', EXPR)) --> ['group by'], expr(EXPR).
group_by_clause(group_by_clause('GROUP BY', EXPR)) --> ['GROUP BY'], expr(EXPR).

condition(condition(L, OP, R)) --> [L], operator(OP), [R].
condition(condition(L, OP, R, LOGOP, COND_REST)) --> [L], operator(OP), [R], logical_operator(LOGOP), condition(COND_REST).

operator(op('=')) --> ['='].
operator(op('>=')) --> ['>='].
operator(op('<=')) --> ['<='].
operator(op('<')) --> ['<'].
operator(op('>')) --> ['>'].
operator(op('!=')) --> ['!='].
operator(op('<>')) --> ['<>'].

logical_operator(logop('AND')) --> ['AND'].
logical_operator(logop('and')) --> ['and'].
logical_operator(logop('OR')) --> ['OR'].
logical_operator(logop('or')) --> ['or'].

expr(expr(E)) --> logical_operator(E), {!, fail}.
expr(expr(E)) --> operator(E), {!, fail}.
expr(expr(E)) --> [E].

%tests
%query(Tree, ['select', '*', 'from', 'a', 'where', 'col1', '=', '1', 'and', 'col2', '=', '2'], []).
%query(Tree, ['select', '*', 'from', 'a', 'where', 'col1', '=', '1'], []).
%query(Tree, ['select', '*', 'from', 'a'], []).
%query(Tree, ['select', '*', 'from', 'a', 'group by', 'col1'], []).