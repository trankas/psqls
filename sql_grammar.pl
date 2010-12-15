sql --> subquery_factoring_clause, subquery, for_update_clause, [;].

subquery --> query_block, order_by_clause. 
subquery --> subquery, [union], order_by_clause.
subquery --> subquery, [union], [all], order_by_clause.
subquery --> [(], subquery, [)], order_by_clause.
