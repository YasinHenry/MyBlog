- 方式1：查出重复数据（保留的一条不查出,下面是保留了id最小的那条没显示）

> project_code 重复认为数据重复
```sql
SELECT
	*
FROM
	pmp_project_collection a
WHERE
	EXISTS (
		SELECT
			1
		FROM
			pmp_project_collection b
		WHERE
			 a.id > b.id
		AND a.project_code = b.project_code
	);
```


- 方式2：查询有重复记录的 数据
```
SELECT
     *
FROM
     pmp_project_collection  a 
WHERE
     (
          SELECT
               count(1)
          FROM
               pmp_project_collection b
          where a.project_code = b.project_code 
     )>1;

SELECT
     *
FROM
     pmp_project_collection 
WHERE
     project_code IN (
          SELECT
               project_code
          FROM
               pmp_project_collection
          GROUP BY
               dealer_customer_code,
               customer_name
          HAVING
               count(*) > 1
     )
```


 - 方式3：查询不带重复数据的记录（当重复时查询出的是id 最小的那一条数据）
```
SELECT
     *
FROM
     pmp_project_collection  a 
WHERE
     (
          SELECT
               count(1)
          FROM
               pmp_project_collection b
          where a.project_code = b.project_code and a.id<b.id
     )<1;
```


 - 方式4：数据表中数据去重（需要mysql 版本支持）

> 为认为重复字段值重复数据就重复得字段加唯一索引，原来是新建一张一样得表并且此字段加有唯一索引，然后从原来得表copy 数据到这个新表，重复数据忽略（用得是insert ignore ....语句插入得）。
```
ALTER IGNORE TABLE pmp_project_collection 
ADD UNIQUE INDEX idx_project_code (project_code);
```
- 方式5：

> 原理上是从需要删除得里面忽略需要保留得 数据
```
DELETE
FROM
    pmp_project_collection
WHERE
    project_code IN
    (
        SELECT
            t1.project_code
        FROM
            (
                SELECT
                    project_code
                FROM
                    tr_dealer_customer_relation
                GROUP BY
                    project_code
                HAVING
                    count(*) > 1
            )
            AS t1
    )
    AND id NOT IN
    (
        SELECT
            t2.id
        FROM
            (
                SELECT
                    max(id)
                FROM
                    tr_dealer_customer_relation
                GROUP BY
                    project_code
                HAVING
                    count(*) > 1
            )
            AS t2
    )
;
```
- 方式6：从b表中取数据更新到a表字段中
```
UPDATE  table_a a, table_b b
SET a.domain_code = b.domain_code,
a.domain_name = b.domain_name,
a.child_domain_code = b.child_domain_code,
a.child_domain_name = b.child_domain_name
WHERE
     a.commodity_cid = b.commodity_cid
AND a.commodity_code != b.commodity_code;
```
- 方式7：a 表 a字段更新到a表b字段
```
UPDATE pln_config_item a
SET a.parent_item_key = (select id  from(
	SELECT
		id,item_key
	FROM
		pln_config_item b
	WHERE
		(
			b.parent_item_key = ''
			OR b.parent_item_key IS NULL
		)
	AND b.category_key = 'fillInstruction'
) n where  n.item_key = a.parent_item_key)
WHERE
	a.category_key = 'fillInstruction'
AND 
	a.parent_item_key != ''
	and a.parent_item_key IS NOT NULL
;
```






