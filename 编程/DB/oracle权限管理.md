# ̸Oracle�û�Ȩ�ޱ�Ĺ�����

> ���ǽ�ͨ����������ķ�ʽ��̸̸Oracle�û�Ȩ�ޱ�Ĺ�������ϣ���Դ������������
> ���ǽ��Ӵ���Oracle�û�Ȩ�ޱ� ��ʼ̸��Ȼ�󽲽��½��һ���Զ�����ʹ��Ҷ�Oracle�û�Ȩ�ޱ��и�������˽⡣

[TOC]

## һ������

sys;//ϵͳ����Ա��ӵ�����Ȩ��

system;//���ع���Ա���θ�Ȩ��

scott;//��ͨ�û�������Ĭ��Ϊtiger,Ĭ��δ����

## ���� ��½

`sqlplus / as sysdba;`//��½sys�ʻ�

`sqlplus sys as sysdba;`//��½sys�ʻ�

`sqlplus scott/tiger;`//��½��ͨ�û�scott

## ���������û�

`create user zhangsan;`//�ڹ���Ա�ʻ��£������û�zhangsan

`alert user scott identified by tiger;/`/�޸�����

`alter user hr identified by hr account unlock;`//�޸�hr�û�������

## �ģ�����Ȩ��

1. Ĭ�ϵ���ͨ�û�scottĬ��δ���������ܽ����Ǹ�ʹ�ã��½����û�Ҳû���κ�Ȩ�ޣ���������Ȩ��

/*����Ա��Ȩ*/

`grant create session to zhangsan;`//����zhangsan�û�����session��Ȩ�ޣ�����½Ȩ��

`grant unlimited session to zhangsan;`//����zhangsan�û�ʹ�ñ�ռ��Ȩ��

`grant create table to zhangsan;`//���贴�����Ȩ��

`grante drop table to zhangsan;`//����ɾ�����Ȩ��

`grant insert table to zhangsan;/`/������Ȩ��

`grant update table to zhangsan;`//�޸ı��Ȩ��

`grant all to public;`//�����Ƚ���Ҫ����������Ȩ��(all)�������û�(public)

2. oralce��Ȩ�޹���Ƚ��Ͻ�����ͨ�û�֮��Ҳ��Ĭ�ϲ��ܻ�����ʵģ���Ҫ������Ȩ

`grant select on tablename to zhangsan;`//����zhangsan�û��鿴ָ�����Ȩ��

`grant drop on tablename to zhangsan;`//����ɾ�����Ȩ��

`grant insert on tablename to zhangsan;`//��������Ȩ��

`grant update on tablename to zhangsan;`//�����޸ı��Ȩ��
��
`grant insert(id) on tablename to zhangsan;`�������ӱ��¼��Ȩ��

`grant update(id) on tablename to zhangsan;`//�����ָ�����ض��ֶεĲ�����޸�Ȩ�ޣ�ע�⣬ֻ����insert��update

`grant alert all table to zhangsan;`//����zhangsan�û�alert������Ȩ��

## �塢����Ȩ��

�����﷨ͬ<u>grant</u>,�ؼ���Ϊ<u>**revoke**</u>

## ���� �鿴Ȩ��

`select * from user_sys_privs;`//�鿴��ǰ�û�����Ȩ��

`select * from user_tab_privs;`//�鿴�����û��Ա��Ȩ��

## �ߡ���������û��ı�

/*��Ҫ�ڱ���ǰ�����û���������*/

`select * from zhangsan.tablename`

## �ˡ� Ȩ�޴���

���û�A��Ȩ������B��B���Խ�������Ȩ��������C���������£�

`grant alert table on tablename to zhangsan with admin option;`//�ؼ��� <u>with admin option</u>

`grant alert table on tablename to zhangsan with grant option;`//�ؼ��� with grant optionЧ����admin����

## �š���ɫ

��ɫ��Ȩ�޵ļ� �ϣ����԰�һ����ɫ������û�

`create role myrole;`//������ɫ

`grant create session to myrole;`//������session��Ȩ������myrole

`grant myrole to zhangsan;`//����zhangsan�û�myrole�Ľ�ɫ

`drop role myrole;`ɾ����ɫ

/*������ЩȨ���ǲ����������ɫ�ģ�����unlimited tablespace��any�ؼ���*/

## ʮ���鿴��ɫ��
`select username from dba_users;`


Oracle�û�Ȩ�ޱ�� ���ܵ����
