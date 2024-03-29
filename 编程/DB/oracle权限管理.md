# 谈Oracle用户权限表的管理方法

> 我们将通过介绍命令的方式，谈谈Oracle用户权限表的管理方法，希望对大家有所帮助。
> 我们将从创建Oracle用户权限表 开始谈起，然后讲解登陆等一般性动作，使大家对Oracle用户权限表有个深入的了解。

[TOC]

## 一、创建

sys;//系统管理员，拥有最高权限

system;//本地管理员，次高权限

scott;//普通用户，密码默认为tiger,默认未解锁

## 二、 登陆

`sqlplus / as sysdba;`//登陆sys帐户

`sqlplus sys as sysdba;`//登陆sys帐户

`sqlplus scott/tiger;`//登陆普通用户scott

## 三、管理用户

`create user zhangsan;`//在管理员帐户下，创建用户zhangsan

`alert user scott identified by tiger;/`/修改密码

`alter user hr identified by hr account unlock;`//修改hr用户的密码

## 四，授予权限

1. 默认的普通用户scott默认未解锁，不能进行那个使用，新建的用户也没有任何权限，必须授予权限

/*管理员授权*/

`grant create session to zhangsan;`//授予zhangsan用户创建session的权限，即登陆权限

`grant unlimited session to zhangsan;`//授予zhangsan用户使用表空间的权限

`grant create table to zhangsan;`//授予创建表的权限

`grante drop table to zhangsan;`//授予删除表的权限

`grant insert table to zhangsan;/`/插入表的权限

`grant update table to zhangsan;`//修改表的权限

`grant all to public;`//这条比较重要，授予所有权限(all)给所有用户(public)

2. oralce对权限管理比较严谨，普通用户之间也是默认不能互相访问的，需要互相授权

`grant select on tablename to zhangsan;`//授予zhangsan用户查看指定表的权限

`grant drop on tablename to zhangsan;`//授予删除表的权限

`grant insert on tablename to zhangsan;`//授予插入的权限

`grant update on tablename to zhangsan;`//授予修改表的权限
及
`grant insert(id) on tablename to zhangsan;`授予增加表记录的权限

`grant update(id) on tablename to zhangsan;`//授予对指定表特定字段的插入和修改权限，注意，只能是insert和update

`grant alert all table to zhangsan;`//授予zhangsan用户alert任意表的权限

## 五、撤销权限

基本语法同<u>grant</u>,关键字为<u>**revoke**</u>

## 六、 查看权限

`select * from user_sys_privs;`//查看当前用户所有权限

`select * from user_tab_privs;`//查看所用用户对表的权限

## 七、操作表的用户的表

/*需要在表名前加上用户名，如下*/

`select * from zhangsan.tablename`

## 八、 权限传递

即用户A将权限授予B，B可以将操作的权限再授予C，命令如下：

`grant alert table on tablename to zhangsan with admin option;`//关键字 <u>with admin option</u>

`grant alert table on tablename to zhangsan with grant option;`//关键字 with grant option效果和admin类似

## 九、角色

角色即权限的集 合，可以把一个角色授予给用户

`create role myrole;`//创建角色

`grant create session to myrole;`//将创建session的权限授予myrole

`grant myrole to zhangsan;`//授予zhangsan用户myrole的角色

`drop role myrole;`删除角色

/*但是有些权限是不能授予给角色的，比如unlimited tablespace和any关键字*/

## 十、查看角色。
`select username from dba_users;`


Oracle用户权限表就 介绍到这里。
