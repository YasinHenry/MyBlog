# 在Elasticsearch中，可以使用以下关键字来建立条件关系：


must: 表示所有的条件都必须满足，相当于逻辑上的"AND"。



must_not: 表示所有的条件都不能满足，相当于逻辑上的"NOT"。



should: 表示至少一个条件满足，相当于逻辑上的"OR"。默认情况下，至少一个should条件满足即可。



filter: 类似于must条件，但是对于filter条件不会进行相关性评分。它适用于无需进行评分的过滤条件，可以提高搜索性能。


# 在Elasticsearch中，可以使用以下条件关键字来构建搜索查询：


match: 用于执行全文匹配，将搜索的词条与文档中的字段进行匹配。



term: 用于执行精确匹配，将搜索的词条与文档中的字段进行完全匹配。



range: 用于执行范围查询，可以指定一个字段的范围条件，如大于、小于、介于等。



exists: 用于检查某个字段是否存在于文档中。



prefix: 用于执行前缀匹配，将搜索的词条与文档中的字段进行前缀匹配。



wildcard: 用于执行通配符匹配，支持使用通配符（*或?）来进行模糊匹配。



regexp: 用于执行正则表达式匹配，将搜索的词条与文档中的字段进行正则表达式匹配。



fuzzy: 用于执行模糊匹配，可以在存在一定差异的情况下匹配文档。



bool: 用于构建复杂的布尔查询，支持组合多个条件关键字，如must、must_not、should等来进行条件组合。



match_phrase: 用于执行短语匹配，将搜索的短语与文档中的字段进行完全匹配。


在Elasticsearch中，有以下聚合关键字和条件：

1. **Terms Aggregation**: 以字段值的分桶方式进行聚合，可以指定字段和桶的大小。

2. **Range Aggregation**: 根据字段值的范围进行聚合，可以指定字段和范围条件。

3. **Date Histogram Aggregation**: 根据日期字段的时间间隔进行聚合，可以按年、月、日等进行聚合。

4. **Histogram Aggregation**: 根据数值字段的间隔进行聚合，可以指定字段和间隔大小。

5. **Average Aggregation**: 计算指定字段的平均值。

6. **Sum Aggregation**: 计算指定字段的总和。

7. **Min Aggregation**: 找到指定字段的最小值。

8. **Max Aggregation**: 找到指定字段的最大值。

9. **Stats Aggregation**: 计算指定字段的统计信息，包括平均值、总和、最小值、最大值和文档数量。

10. **Cardinality Aggregation**: 计算指定字段的基数（不重复值的数量）。

11. **Filter Aggregation**: 根据条件过滤文档，并对过滤后的文档进行聚合操作。

12. **Nested Aggregation**: 在嵌套字段上执行聚合操作。

13. **Date Range Aggregation**: 根据日期字段的范围进行聚合。

14. **Composite Aggregation**: 结合多个聚合操作的结果，进行多级聚合。

这些聚合关键字和条件可以在聚合查询中组合使用，以获取所需的聚合结果。根据具体的需求和数据结构，选择适当的聚合关键字和条件进行使用。