sql --> subquery_factoring_clause, subquery, for_update_clause, [;].

subquery --> query_block, order_by_clause. 
subquery --> subquery, un_int_min, subquery, order_by_clause.
subquery --> [(], subquery, [)], order_by_clause.

union_all --> [union], [all].
union_all --> [union].

un_int_min --> union_all.
un_int_min --> [intersect].
un_int_min --> [minus].

query_block --> [select], query_hint, all_distinct_unique, select_list, [from], 
	multiple_from_clause, where_clause, hierarchical_query_clause, group_by_clause,
	having_clause, model_clause. 

where_clause --> [].
where_clause --> where_c.

hierarchical_query_clause --> [].
hierarchical_query_clause --> hierarchical_query_c.

group_by_clause --> [].
group_by_clause --> group_by_c.

having_clause --> [].
having_clause --> having_c.

model_clause --> [].
model_clause --> model_c.

query_hint --> hint.
query_hint --> [].

all_distinct_unique --> [all].
all_distinct_unique --> [distinct].
all_distinct_unique --> [unique].

multiple_from_clause --> from_clause.
multiple_from_clause --> from_clause, [,], from_clause.

from_clause --> table_reference.
from_clause --> join_clause.
from_clause --> [(], join_clause, [)].

subquery_factoring_clause --> [with], multi_query_name.
multi_query_name --> query_name, [as], [(], subquery, [)].

select_list --> [*].
select_list --> multi_select_list.

multi_select_list --> sub_multi_select_list.
multi_select_list --> sub_multi_select_list, [,], sub_multi_select_list.

sub_multi_select_list --> regular_sub_multi_select_list.
sub_multi_select_list --> expr_sub_multi_select_list.

regular_sub_multi_select_list --> sub_regular_sub_multi_select_list, [.*].

sub_regular_sub_multi_select_list --> query_name.
sub_regular_sub_multi_select_list --> schema_clause, table_clause.

schema_clause --> [].
schema_clause --> schema_c.

table_clause --> table_c.
table_clause --> view_clause.
table_clause --> mat_view_clause.
