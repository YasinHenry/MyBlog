- 查询用户

\> `select * from mysql.user;`

- 使用native加密方式创建用户

> （mysql_native_password 加密方式，mysql 8.0后的版本加密方式默认为sha2 加密，老版本工具的驱动可能无法支持，需要升级，或者用下面指定老版本加密方式加密）

\> `create user 'ctms'@'localhost' identified WITH mysql_native_password by '123456';`

- 删除用户

\> `DROP user 'ctms'@'localhost'`

- 分配权限

> （ALL PRIVILEGES 可以换为 insert,select 等；ctms.* 数据库表；'ctms'@'localhost' 用户）

\> `GRANT ALL PRIVILEGES ON ctms.* TO 'ctms'@'localhost' WITH GRANT OPTION;`

- 删除权限

\>`revoke all on ctms.* from 'ctms'@'localhost' ;`

- 查看权限分配 

\>`show grants;`

`>show grants for 'ctms'@'%';`

- 刷新权限

\>`FLUSH PRIVILEGES;`

> 有时候创建用户不成功，查询有没有这个用户可以先删除一下再创建，权限分配同样;